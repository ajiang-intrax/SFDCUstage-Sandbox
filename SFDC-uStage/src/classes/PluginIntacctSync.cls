global class PluginIntacctSync 
//implements Process.Plugin, Database.AllowsCallouts 
{  
    /*
    // The main method to be implemented. The Flow calls this at runtime.
    
    global Process.PluginResult invoke(Process.PluginRequest request) { 
        // Get the subject of the Chatter post from the flow
        
        List<Account> lstAccounts;
        List<Intacct__c> lstIntacct;
        Account account;      
        PageReference nextPage;
        
        Id AccountId = (Id) request.inputParameters.get('pAccountId');
        Id IntacctId = (Id) request.inputParameters.get('IntacctId');
        Id OpportunityId = (Id) request.inputParameters.get('pOpportunityId');
        System.debug('****acId: ' + AccountId);
        System.debug('****inId: ' + IntacctId);
        System.debug('****oppId: ' + OpportunityId);
        
        if(IntacctId==null && AccountId!=null) 
            IntAcctOppSyncHelper.InitiaiteIntAcct(AccountId );
        else if(IntacctId!=null && AccountId!=null && OpportunityId==null)
            IntAcctOppSyncHelper.UpdateCustomer(AccountId,IntacctId);         
        else if (IntacctId==null && OpportunityId!=null && (!Test.isRunningTest())) 
            IntAcctOppSyncHelper.CreateSalesOrder(OpportunityId,IntacctId,null,false,null); 
        else if (IntacctId!=null && OpportunityId!=null)
        {
            lstIntacct = [Select i.Parent_Intacct__c, i.LastModifiedDate,i.type__c, i.LastModifiedById, i.Is_Parent__c, i.IsDeleted, i.Intacct_Response__c, i.Id, i.Account__c From Intacct__c i where i.Opportunity__c=:OpportunityId];
            System.debug('****lstIntacct: ' + lstIntacct);
            If(lstIntacct!=null && lstIntacct.size()>0)
            {
                for(Intacct__c intacct: lstIntacct)
                {  
                    //if(intacct.type__c=='Create Sales Invoice' && intacct.Intacct_Response__c=='Failure')    
                    // IntAcctOppSyncHelper.CreateSalesInvoice(OpportunityId,IntacctId);
                    //else if (intacct.type__c=='Create Revenue Contract' && intacct.Intacct_Response__c=='Failure')
                    // IntAcctOppSyncHelper.CreateRevContract(OpportunityId,IntacctId);
                    if (intacct.type__c=='Create Sales Order' && intacct.Intacct_Response__c=='Failure')
                        IntAcctOppSyncHelper.CreateSalesOrder(OpportunityId,IntacctId,null,false,null);
                }
            }
        }
        
        // return to Flow
        Map<String,Object> result = new Map<String,Object>(); 
        return new Process.PluginResult(result); 

    } 
    
    // Returns the describe information for the interface
    global Process.PluginDescribeResult describe() {
        
        Process.PluginDescribeResult result = new Process.PluginDescribeResult(); 
        
        result.inputParameters = new list<Process.PluginDescribeResult.InputParameter>{ 
            new Process.PluginDescribeResult.InputParameter('pAccountId', 
                                                            Process.PluginDescribeResult.ParameterType.Id, true),
                new Process.PluginDescribeResult.InputParameter('IntacctId', 
                                                                Process.PluginDescribeResult.ParameterType.Id, true),
                new Process.PluginDescribeResult.InputParameter('pOpportunityId', 
                                                                Process.PluginDescribeResult.ParameterType.Id, true)
                
                }; 
                    
                    
                    result.outputParameters = new list<Process.PluginDescribeResult.OutputParameter>{
                        new Process.PluginDescribeResult.OutputParameter('ReturnFlag', 
                                                                         Process.PluginDescribeResult.ParameterType.String)
                            
                            };
                                
                                return result; 
        
        
       
    }
    
    */
    
}