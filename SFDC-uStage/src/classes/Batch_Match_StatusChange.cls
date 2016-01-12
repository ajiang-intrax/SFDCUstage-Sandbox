global class Batch_Match_StatusChange implements Database.Batchable<sObject>
{
    global Database.queryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator([SELECT Id,Position_Name__r.Host_Company_Id__c,Intrax_Program__c, Status__c FROM Match__c
                                                    WHERE (Intrax_Program__c = 'AuPairCare' OR Intrax_Program__c ='Work Travel' OR Intrax_Program__c ='Internship'  OR Intrax_Program__c ='Ayusa' )
                                                    AND Status__c = 'Confirmed'
                                                    AND End_Date__c < :date.today() AND End_Date__c > 2015-12-03]);
    }
    global void execute (Database.BatchableContext BC, list<Match__c> MatchList)
    {
        list<Match__c> UpdMatchList = new list<Match__c>();
        list<Account> hostAccountList = new list<Account>();
        set<id> AccountIds = new set<id>();
        if(MatchList!=null && MatchList.size()>0)
        {
            for (Match__c OneMatch : MatchList)
            {
                OneMatch.Status__c = 'Completed';
                UpdMatchList.add(OneMatch);
                If(OneMatch.Intrax_Program__c=='AuPairCare'){
                 AccountIds.add(oneMatch.Position_Name__r.Host_Company_Id__c); 
                }
            }
            system.debug('debug:::AccountIds==='+AccountIds);
            //get the host Account
            if(AccountIds.size()>0)
            {
                List<Account> hostAccount = [select id, rematch_type__c,discretionary_discount__c from account where id in:AccountIds];
                if(hostAccount.size() > 0)
                {
                   system.debug('debug:::Inside Loop--AccountIds==='+hostAccount);
                    for(Account ha: hostAccount){
                        ha.rematch_type__c=null;
                        ha.Discretionary_Discount__c=null;
                        hostAccountlist.add(ha);
                    }
                }
            }
            
            if(UpdMatchList != NULL && UpdMatchList.size()>0)
            {
                update UpdMatchList;
            }
            if(hostAccountlist != NULL && hostAccountlist.size()>0)
            {
                update hostAccountlist;
            }
        }
    }
    global void finish(Database.BatchableContext BC)
    {
    }
}