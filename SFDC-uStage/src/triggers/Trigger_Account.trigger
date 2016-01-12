/****************************************
  Name:       Trigger_Account.trigger
  
  Functionality:   Automatically create new sAccount__c ans sContacts__c (if necessary) when
          a new Account is created.
  
  Version:     1.0
          For now, only considering person Accounts (Participants and HF)
        
*****************************************/

trigger Trigger_Account on Account (after insert, after update, before update){
	//I have to exclude this trigger if Auto Sync Application.
   	if(TriggerExclusion.isTriggerExclude('Account')){
   		return;
   	}
   
// TRIGGER VARS INSTANTIATION  
    //Instantiate Google Geo Controller
    System.debug('Inside Account trigger before instance creation');
    googleGeoController gGeoC = new googleGeoController();
    System.debug('Inside Account trigger after instance creation');
    
    AccountShare acc_share=new AccountShare();
    String flag;
    
    list<AccountShare> AccSharetoPersist = new list<AccountShare>();
    list<Manual_Sharing_Info__c> ManualShareInfolst = new list<Manual_Sharing_Info__c>();
    
// BEFORE TRIGGER STARTS HERE 
    if(trigger.isBefore){
// BEFORE ALL TRIGGER STARTS HERE       
        boolean blnDeployTestFlag = Constants.blnDeployTestFlag;
        Set<Id> accountIds = new Set<Id>();
        string strAccName;
        for (Account newValues : Trigger.new){
            if(newValues.IsPersonAccount){
                newValues.Intrax_Programs__pc = newValues.Intrax_Programs__c;
                newValues.Intrax_Program_Options_CT__pc = newValues.Intrax_Program_Options__c;
            }
        }
// BEFORE ALL TRIGGER ENDS HERE         
// BEFORE UPDATE TRIGGER STARTS HERE            
        if(trigger.isUpdate){
            if (userinfo.getUserName().equals(Constants.SYS_ADMIN)) {
                for (Account newValues : Trigger.new){
                    for (Account oldValues: Trigger.old){
                        if (oldValues.PersonHasOptedOutOfEmail == true){
                            if (newValues.PersonHasOptedOutOfEmail == false){
                                //Casper cannot override email optout
                                newValues.PersonHasOptedOutOfEmail = true;
                            }
                        }                
                    }
                }
            }
            
            set<String> setacName = new set<String>();
            List<Applicant_Info__c> listAppln = new List<Applicant_Info__c>();
            List<Applicant_Info__c> lstapplupdate = new List<Applicant_Info__c>();
          /*  for (Account acRecord : Trigger.New){
             if(Trigger.oldMap.get(acRecord.id).Intrax_Region__c != acRecord.Intrax_Region__c || Trigger.oldMap.get(acRecord.id).Intrax_Market__c != acRecord.Intrax_Market__c)
              {
               setacName.add(acRecord.Name);
              }
            }
           
           if(setacName!=null && setacName.size()>0)
           {
           system.debug('here' +setacName);
           listAppln = [Select Id,RecordTypeId,Name,Intrax_Market__c,Intrax_Region__c,Partner_Intrax_Id__c,Partner_Account__r.Name from Applicant_Info__c where Partner_Account__r.Name IN:setacName];
           }
           
           if(listAppln!=null && listAppln.size()>0)
           {
            for(Applicant_Info__c apln: listAppln)
            {   
             apln = ApplicantInfoHelper.setApp_IntraxRegion_and_Market(apln,'Participant');
            }
           // update apln;
           }  */   
                 
                  
            for(Account record: Trigger.new)
            {
                strAccName = record.Name;
                if(record.OwnerId != Trigger.oldMap.get(record.Id).OwnerId && Trigger.oldMap.get(record.Id).OwnerId!=null)
                  {
                    if(!(blnDeployTestFlag && strAccName!=null && strAccName.containsIgnoreCase('Test')))  
                    accountIds.add(record.Id);
                    system.debug('**accountIds**'+accountIds);
                  }
            
            }
                if(accountIds!=null && accountIds.size()>0)  
                {    
                    flag='before';
                    SharingSecurityHelper.persistSharingWithOwner(acc_share, flag, accountIds); 
                    /*       
                    SharingSecurityHelper.persistAccountSharing(
                        JSON.serialize(
                            [Select a.UserOrGroupId, a.RowCause, a.OpportunityAccessLevel, a.LastModifiedDate, a.LastModifiedById, a.IsDeleted, a.ContactAccessLevel, a.CaseAccessLevel, a.AccountId, a.AccountAccessLevel From AccountShare a WHERE  a.AccountId IN :accountIds AND 
                               a.RowCause = 'Manual']
                        )
                    );
                    
                    // Added for persisting sharing on ownership change
                    AccSharetoPersist = [Select a.UserOrGroupId, a.RowCause, a.OpportunityAccessLevel, a.LastModifiedDate, a.LastModifiedById, a.IsDeleted, a.ContactAccessLevel, a.CaseAccessLevel, a.AccountId, a.AccountAccessLevel 
                                        From AccountShare a 
                                        WHERE  a.AccountId IN :accountIds AND 
                                        a.RowCause = 'Manual'];
                    
                    if(AccSharetoPersist != NULL && AccSharetoPersist.size()>0)
                    {
                        list<string> lststr = new list<string>();
                        for(AccountShare accshr :AccSharetoPersist)
                        {
                            Manual_Sharing_Info__c newmShare = new Manual_Sharing_Info__c();
                            newmShare.Object_ID__c = accshr.AccountId;
                            newmShare.User_ID__c = accshr.UserOrGroupId;
                            ManualShareInfolst.add(newmShare);
                        }
                    }
                    */
                    
                }
            
            /*
            if (ManualShareInfolst != NULL && ManualShareInfolst.size()>0)
            {
                insert ManualShareInfolst;
            }
            */
        }
// BEFORE UPDATE TRIGGER ENDS HERE          
    }
// BEFORE TRIGGER ENDS HERE 
  
// AFTER TRIGGER STARTS HERE  
     if(trigger.isAfter){
        List<Account> geoAccounts = new List<Account>();
// AFTER ALL TRIGGER STARTS HERE     
        if (trigger.isInsert){  
            for (Account accRecord : Trigger.New){
                if (accRecord.Lead_Type__c == 'Host Family' && accRecord.Intrax_Programs__c == 'AuPairCare' ){
                    //Call the intacct wrapper to create the account in Intaccct and Sync
                    //Intacct_Wrapper wrapper= new Intacct_wrapper();
                    //wrapper.CreateIntacctAccnt_Sync(accRecord.Id);
                    
                    geoAccounts.add(accRecord);
                }
                
                System.debug('before creating intacct accoun');
                //System.debug('***** Application Owner in AccTrig'+([SELECT OwnerId FROM Applicant_Info__c WHERE Account__c=:accRecord.Id].ownerId));
                 
                 //System.debug('***** Application Owner in AccTrig'+([SELECT OwnerId FROM Applicant_Info__c WHERE Account__c=:accRecord.Id].ownerId));
            }       
        
            gGeoC.sObjectList = geoAccounts;
        }
        
// AFTER ALL TRIGGER ENDS HERE          
// AFTER UPDATE TRIGGER STARTS HERE     
        if(trigger.isUpdate){
            set<Id> allshareIDs = new set<Id>();
              for (Account accRecord : Trigger.New){
                if(Trigger.oldMap!=null && Trigger.oldMap.get(accRecord.Id).OwnerId!=null &&  accRecord.OwnerId != Trigger.oldMap.get(accRecord.Id).OwnerId) {  
                    allshareIDs.add(accRecord.id);
                }
              if (accRecord.Lead_Type__c == 'Host Family' && accRecord.Intrax_Programs__c == 'AuPairCare' ){
                //share the account record
                system.debug('Inside account trigger and after Update');
                system.debug('create by id ' + accRecord.createdBy.id + 'createdByid' + accRecord.createdByid);
                Sharing_Security_Controller.shareAccount(accRecord.Id ,accRecord.createdByid);
                  
                System.debug('Checking whether the customor details have changed to update the customer account in Intacct');
               if(//Trigger.oldMap.get(accRecord.id).FirstName != accRecord.FirstName ||
                  //Trigger.oldMap.get(accRecord.id).LastName != accRecord.LastName ||
                  //Trigger.oldMap.get(accRecord.id).BillingStreet != accRecord.BillingStreet ||
                  //Trigger.oldMap.get(accRecord.id).BillingCity != accRecord.BillingCity ||
                  //Trigger.oldMap.get(accRecord.id).BillingState != accRecord.BillingState ||
                  //Trigger.oldMap.get(accRecord.id).BillingCountry != accRecord.BillingCountry ||
                  //Trigger.oldMap.get(accRecord.id).BillingPostalCode != accRecord.BillingPostalCode ||
                  Trigger.oldMap.get(accRecord.id).ShippingStreet != accRecord.ShippingStreet ||
                  Trigger.oldMap.get(accRecord.id).ShippingCity != accRecord.ShippingCity ||
                  Trigger.oldMap.get(accRecord.id).ShippingState != accRecord.ShippingState ||
                  Trigger.oldMap.get(accRecord.id).ShippingCountry != accRecord.ShippingCountry ||
                  Trigger.oldMap.get(accRecord.id).ShippingPostalCode != accRecord.ShippingPostalCode //||
                  //Trigger.oldMap.get(accRecord.id).Phone != accRecord.Phone ||
                  //Trigger.oldMap.get(accRecord.id).Fax != accRecord.Fax ||
                  //Trigger.oldMap.get(accRecord.id).PersonEmail != accRecord.PersonEmail
                 )
               {
                   Intacct_Wrapper wrapper= new Intacct_wrapper();
                   //new method call
                   wrapper.UpdateIntacctAccnt_Sync(accRecord.id,null);
                   /*List<Intacct__c> parentIntacct = [Select id from Intacct__c 
                                               where Account__c =:accRecord.id and
                                                     Is_Parent__c = true and
                                                     Type__c = 'Create Customer' and
                                                     Intacct_Response__c = 'Success'
                                               limit 1];
                   //intacct account no present so create it and sync
                   if(parentIntacct.isEmpty())
                   {
                       System.debug('Parent Intacct is not present. Create one and sync');
                       //wrapper.CreateIntacctAccnt_Sync(accRecord.id);   
                   }
                   else
                   {
                       //Account already created so just update the account and sync it.
                       System.debug('Parent Intacct is present. Id is ' + parentIntacct[0].id + ' Just update the customer and sync it');
                       //wrapper.UpdateIntacctAccnt_Sync(accRecord.id,parentIntacct[0].id);
                   }*/
                   
               }
                  
              }
              
             
             //B-03185 
             if(accRecord.Status__c == 'Terminated' && accRecord.Type == 'Host Company')
             {
              List<Contact> con = new List<Contact>();
              List<Contact> lstcon = new List<Contact>();
              con = [Select Id, Name,Status__c from Contact where AccountId =:accRecord.Id];
              system.debug('contact' +con);
              for(Contact c:con)
              {
               if(c.Status__c == 'Active')
               {
                c.Status__c = 'Inactive';
                lstcon.add(c);
               }
              }
              if(lstcon!=null && lstcon.size()>0)
              {
               update lstcon;
              }
             }
              //B-03185     
            }
            
           
            //manual share
            if(allshareIDs != NULL && allshareIDs.size()>0)
            {
                flag='after';
                SharingSecurityHelper.persistSharingWithOwner(acc_share, flag, allshareIDs);
                /*  
                list<AccountShare> allManualAccShare = new list<AccountShare>();
                list<Manual_Sharing_Info__c> selMShareSOQL = [SELECT Object_ID__c, User_ID__c FROM Manual_Sharing_Info__c WHERE Object_ID__c IN : allshareIDs];
                if (selMShareSOQL != NULL && selMShareSOQL.size()>0)
                {
                    for (Manual_Sharing_Info__c SingleShr : selMShareSOQL)
                    {
                        AccountShare singleaccshr = new AccountShare();
                        singleaccshr.AccountId = SingleShr.Object_ID__c;
                        singleaccshr.UserOrGroupId = SingleShr.User_ID__c;
                        singleaccshr.AccountAccessLevel = 'Edit';
                        singleaccshr.OpportunityAccessLevel = 'Edit';
                        allManualAccShare.add(singleaccshr);
                    }
                    if(allManualAccShare != NULL && allManualAccShare.size()>0)
                    {
                        insert allManualAccShare;
                        delete selMShareSOQL;
                    }
                }
                */
            }
                     
        }
// AFTER UPDATE TRIGGER ENDS HERE   
        if (geoAccounts.size() > 0)
            gGeoC.theInstanceGateKeeper();     
     }
// AFTER TRIGGER ENDS HERE     
}