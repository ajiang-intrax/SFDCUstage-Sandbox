public without sharing class Intacct_Wrapper implements Database.AllowsCallouts {
    
    public void CreateSalesOrder(Id OpportunityId, Id AccountId)
    {
        try{
            //First get the parentIntacct Id frokm account Id       
            List<Intacct__c> lstParentIntacct = new List<Intacct__c>();
            lstParentIntacct = [Select i.Parent_Intacct__c, i.LastModifiedDate, i.LastModifiedById, i.Is_Parent__c, i.IsDeleted, i.Intacct_Response__c, i.Id, i.Account__c From Intacct__c i 
                                where i.account__c=:AccountId and i.Is_Parent__c=true and i.Intacct_Response__c='Success'];
            
            system.debug('lstParentIntacct' + lstParentIntacct);
            if(lstParentIntacct!=null && lstParentIntacct.size()>0)
            {                    
                List<Payment__c> lstPayment = new List<Payment__c>();
                lstPayment = [Select p.Id, p.name,p.Payment_Type__c From Payment__c p
                              where p.Account_Name__c=:AccountId and p.Opportunity_Name__c = :OpportunityId and p.Sucess__c=true];
                
                System.debug('payment list ' + lstPayment);
                if(lstPayment!=null && lstPayment.size()==1 && lstPayment[0].payment_type__c !='Service Credit')
                {
                    System.debug('First Payment has been made. payment id: ' + lstPayment[0].Id + 'Create SO,RC,SI and ARUpdate');
                    //If Payment is available then create SO,RC,SI and AR update
                    IntAcctOppSyncHelper.CreateSalesOrder(OpportunityId, lstParentIntacct[0].Id,lstPayment[0].Id,false,null,null,'');
                }
                else if(lstPayment!=null && lstPayment.size()>=1)
                {// this means we have mulitple payments. 1 manual and 1 service credit
                 //or multiple service credits.
                    System.debug('this means we have mulitple payments. 1 manual and 1 service credit' + 
                 				  'or multiple service credits. ' + lstPayment +  'Create SO,RC,SI and ARUpdates for all payments');
                    Id ccPaymentId=null;
                    List<Id> payListIds = new List<Id>();
                   
                    for(payment__c p : lstPayment)
                    {
                        if(p.Payment_Type__c == 'Service Credit')
                        payListIds.add(p.Id);
                        
                        if(p.Payment_Type__c == 'Credit')
                        ccPaymentId = p.id;                        
                    }
                    
                    System.debug('paylistIds : ' + payListIds);
                    IntAcctOppSyncHelper.CreateSalesOrder(OpportunityId, lstParentIntacct[0].Id,ccPaymentId,true,OpportunityId,payListIds,'Rematch');
                }
                else
                {
                    System.debug('No payment is available. Just Create SO,RC,SI');
                    //If Payment is not available then just create SO,RC,SI
                    IntAcctOppSyncHelper.CreateSalesOrder(OpportunityId, lstParentIntacct[0].Id,null,false,null,null,'');
                }
            } 
            else
            {
                System.debug('parent Intacct record not present. That means Intacct Customer account is not created');
            }
        }
        catch(Exception ex)
        {
            System.debug('Exception occured while doing the integration with Intacct. Exception is ' + ex);
        }
    }
    
    public boolean CreateIntacctAccnt_Sync(Id accId)
    {
        boolean isSuccessful=false;
        try{
            //IntAcctOppSyncHelper.InitiaiteIntAcct(accId);
            //first time calling the new method
            //IntAcctOppSyncHelper.InitiaiteIntAcct_new(accId);
            IntAcctOppSyncHelper.SyncAccountToCustomer_new(accId);
            isSuccessful = true;
        }
        catch(Exception exp)
        {
            System.debug('Exception occured in Intacct Account creation and sync. Exception is :' + exp);
            isSuccessful = false;
        }
        return isSuccessful;
    }
    
    public boolean UpdateIntacctAccnt_Sync(Id accId, Id IntacctId)
    {
        boolean isSuccessful=false;
        try{
            IntAcctOppSyncHelper.SyncAccountToCustomerfuture(accId);
            //IntAcctOppSyncHelper.UpdateCustomer(accId,IntacctId);
            isSuccessful = true;
        }
        catch(Exception exp)
        {
            System.debug('Exception occured in Update of Intacct Account and sync. Exception is :' + exp);
            isSuccessful = false;
        }
        return isSuccessful;
    }
    
    /*public boolean SyncIntacctAccnt(Id accId)
    {
        boolean isSuccessful=false;
        try{
            IntAcctOppSyncHelper.SyncAccountToCustomer(accId, true);
            isSuccessful = true;
        }
        catch(Exception exp)
        {
            System.debug('Exception occured in Intacct Account sync. Exception is :' + exp);
            isSuccessful = false;
        }
        return isSuccessful;
    }*/
    
    
    public void CreateAndApplyServiceCredit(Id matchBreakOppId, Id AccountId, Id matchOppId, decimal serviceCreditAmount,Id matchId)
    {
        try{
            //First get the parentIntacct Id from account Id       
            List<Intacct__c> lstParentIntacct = new List<Intacct__c>();
            lstParentIntacct = [Select i.Parent_Intacct__c, i.LastModifiedDate, i.LastModifiedById, i.Is_Parent__c, i.IsDeleted, i.Intacct_Response__c, i.Id, i.Account__c From Intacct__c i 
                                where i.account__c=:AccountId and i.Is_Parent__c=true and i.Intacct_Response__c='Success'];
            
            system.debug('lstParentIntacct' + lstParentIntacct);
            if(lstParentIntacct!=null && lstParentIntacct.size()>0)
            {     
                	System.debug('ServiceCredit is true and PrevMatchOppId ' + matchOppId);
                        List<Sales_Invoice__c> outstandingSIs = [Select id,Account__c,Amount_Due__c,Document_Type__c,Document_Number__c,
                                                                 		Opportunity__c,Payment_Status__c,Name 
                                                                from 	Sales_Invoice__c
                                                                where	Account__c = :AccountId 
                                                                 and	Opportunity__c = :matchOppId
                                                                 and	(Payment_Status__c = 'Open' or payment_Status__c = 'Partial') 
                                                                 and	Document_type__c = 'Sales Invoice'];
                        
                		
                        if(outstandingSIs!=null && outstandingSIs.size()>0)
                        {
                            Id applicationId;
                            // Get the application id from the match position
                            List<Applicant_Info__c> appList = [select id,name from Applicant_Info__c where Position__c in (select Position_Name__c from match__c where id = :matchId)];
                            
                            if(appList!=null && appList.size()>0)
                            {
                              system.debug('host family application is ' + appList[0]);
                              applicationId = appList[0].Id;
                            }
                            
                            decimal SITotal = 0.0;
                            System.debug('outstanding sales invoices : ' + outstandingSIs);
                            List<Payment__c> payList = new List<Payment__c>();
                            List<Id> payListIds = new List<Id>();
                            for(Sales_Invoice__c SI:outstandingSIs)
                            {
                                SITotal = SITotal + SI.Amount_Due__c;
                                if(SITotal <=math.abs(serviceCreditAmount))
                                {
                                    Payment__c serviceCreditPmnt = new Payment__c();
                                    serviceCreditPmnt.Account_Name__c = AccountId;
                                    serviceCreditPmnt.Opportunity_Name__c = matchOppId;
                                    serviceCreditPmnt.Payment_Type__c = 'Service Credit';
                                    serviceCreditPmnt.Txn_Amount__c = SI.Amount_Due__c.setScale(2);
                                    serviceCreditPmnt.Amount__c = SI.Amount_Due__c.setScale(2);
                                    serviceCreditPmnt.Sucess__c = true;
                                    serviceCreditPmnt.Txn_Date__c = System.now();
                                    serviceCreditPmnt.Txn_Gateway__c = 'Au Pair Care';
	                                serviceCreditPmnt.Txn_Id__c = SI.Document_Number__c;
                                    serviceCreditPmnt.Txn_Reference_Id__c = serviceCreditPmnt.Txn_Id__c;
                                    serviceCreditPmnt.Txn__c = 'Service Credit applied to sales invoice' + SI.Document_Number__c;
                                    serviceCreditPmnt.Card_Holder__c = applicationId;
                                    payList.add(serviceCreditPmnt);
                                    //payListIds.add(serviceCreditPmnt.Id);
                                }
                                /*else
                                {
                                    Payment__c serviceCreditPmnt = new Payment__c();
                                    serviceCreditPmnt.Account_Name__c = AccountId;
                                    serviceCreditPmnt.Opportunity_Name__c = matchOppId;
                                    serviceCreditPmnt.Payment_Type__c = 'Service Credit';
                                    serviceCreditPmnt.Txn_Amount__c = SI.Amount_Due__c;
                                    serviceCreditPmnt.Amount__c = SI.Amount_Due__c;
                                    serviceCreditPmnt.Sucess__c = true;
                                    serviceCreditPmnt.Txn_Date__c = System.now();
                                    serviceCreditPmnt.Txn_Gateway__c = 'Au Pair Care';
	                                serviceCreditPmnt.Txn_Id__c = SI.Document_Number__c;
                                    serviceCreditPmnt.Txn_Reference_Id__c = serviceCreditPmnt.Txn_Id__c;
                                    serviceCreditPmnt.Txn__c = 'Service Credit applied to sales invoice' + SI.Document_Number__c;
                                    serviceCreditPmnt.Card_Holder__c = applicationId;
                                    payList.add(serviceCreditPmnt);
                                    return;
                                }*/
                                //IntAcctOppSyncHelper.ApplyAccountReceivables(OppId,OppAccountId,IntacctId,
                                  //                                           SI.Document_Number__c,ARUpdateKey,SI.Amount_Due__c);
                            }
                            
                            //first  insert the service credit payments and then call intacct to do the update on Salesinvoices
                            if(payList!=null && payList.size()>0)
                            {
                                insert paylist;
                                for(Payment__c p : paylist)
                                    payListIds.add(p.Id);
                                System.debug('This is service credit creation. Create SO,RC,SI and apply to outstanding match invoices' 
                                             + 'if there are any');
                                System.debug('paylist ids before calling intacct ' + payListIds);
                    			IntAcctOppSyncHelper.CreateSalesOrder(matchBreakOppId, lstParentIntacct[0].Id,null,true,matchOppId,payListIds,'');

                            }
                        }
                		else
                        {
                            System.debug('There are no oustanding invoices');
                            System.debug('This is service credit creation. Create SO,RC,SI');
                    		IntAcctOppSyncHelper.CreateSalesOrder(matchBreakOppId, lstParentIntacct[0].Id,null,false,null,null,'');
                        }
                
                       } 
            else
            {
                System.debug('parent Intacct record not present. That means Intacct Customer account is not created');
            }
        }
        catch(Exception ex)
        {
            System.debug('Exception occured while doing the integration with Intacct. Exception is ' + ex);
        }
    }
    
}