trigger Trigger_Contact on Contact (after insert, after update, before update) {
    
    //Instantiate Google Geo Controller
    System.debug('Inside contact trigger before instance creation');
    googleGeoController gGeoC = new googleGeoController();
    System.debug('Inside contact trigger after instance creation');
        
    if(trigger.isAfter){
        if(trigger.isInsert){
        //Container to store new iGeoLocates to be created
        List<Contact> contactsToBeLocated = new List<Contact>();    
         for(Contact ObjContact:trigger.new)
         {
                //If Mailing Address is valid
                if (ObjContact.MailingStreet !=null && ObjContact.MailingCity !=null && ObjContact.MailingCountry !=null && ObjContact.MailingPostalCode !=null && ObjContact.MailingState !=null)
                {
                    //If Contact is an Ayusa Validator
                    If(ObjContact.Program_Role__c == 'Ayusa Validator')
                    {
                        iGeolocate__c objiGeolocate=new iGeolocate__c();
                        objiGeolocate.Contact__c = ObjContact.Id;
                        insert objiGeolocate;
                    }
                    //Else if Contact is an Area Director- ******* Need more qualification here ********
                    else if(ObjContact.Title == 'Area Director'){
                        contactsToBeLocated.add(ObjContact);
                    }
                }
         }
        //If there are GeoLocates to be handled do that in a batch through the Geo Controller
        if (contactsToBeLocated.size() > 0){
            gGeoC.sObjectList = contactsToBeLocated;
            gGeoC.theInstanceGateKeeper();
        }
            //IUtilities.sContactAction(trigger.new);                       
        } //Enf if trigger.isInsert
        if(trigger.isUpdate){
            //Container to store contacts to be geo handled
            List<Contact> contactsToBeGeoHandled = new List<Contact>();
            
            for(Contact ObjContact:trigger.new)
            {
                string OldMailingStreet = trigger.oldMap.get(ObjContact.Id).MailingStreet;
                string NewMailingStreet = trigger.newMap.get(ObjContact.Id).MailingStreet;
                string OldMailingCity = trigger.oldMap.get(ObjContact.Id).MailingCity;
                string NewMailingCity = trigger.newMap.get(ObjContact.Id).MailingCity;
                string OldMailingCountry = trigger.oldMap.get(ObjContact.Id).MailingCountry;
                string NewMailingCountry = trigger.newMap.get(ObjContact.Id).MailingCountry;
                string OldMailingPostalCode = trigger.oldMap.get(ObjContact.Id).MailingPostalCode;
                string NewMailingPostalCode = trigger.newMap.get(ObjContact.Id).MailingPostalCode;
                string OldMailingState = trigger.oldMap.get(ObjContact.Id).MailingState;
                string NewMailingState = trigger.newMap.get(ObjContact.Id).MailingState;

                //If Mailing address of the contact record has changed
                if(OldMailingStreet != NewMailingStreet || OldMailingCity!=NewMailingCity ||  OldMailingCountry!=NewMailingCountry || OldMailingPostalCode!=NewMailingPostalCode || OldMailingState!=NewMailingState)
                {
                    //If the record is an Ayusa Validator
                    If(ObjContact.Program_Role__c == 'Ayusa Validator')
                    {
                        List<iGeolocate__c> objiGeolocate=[Select i.Position__r.Country__c,i.isUpdated__c,i.name, i.Position__r.Postal_Code__c, i.Position__r.State__c, i.Position__r.City__c, i.Position__r.Street__c, i.Position__c,i.Id, i.GeoAddress__Longitude__s, i.GeoAddress__Latitude__s, i.Contact__r.MailingCountry, i.Contact__r.MailingPostalCode, i.Contact__r.MailingState, i.Contact__r.MailingCity, i.Contact__r.MailingStreet, i.Contact__r.Id, i.Contact__c, i.Account__r.PersonMailingCountry, i.Account__r.PersonMailingPostalCode, i.Account__r.PersonMailingState, i.Account__r.PersonMailingCity, i.Account__r.PersonMailingStreet, i.Account__r.Type, i.Account__r.Name, i.Account__c From iGeoLocate__c i where i.Contact__c =: ObjContact.Id  ];
                        if(objiGeolocate!=null && objiGeolocate.size()>0)
                        {
                                For(iGeolocate__c igeo :objiGeolocate)
                                {
                                    igeo.isUpdated__c = true;                           
                                }
                                update objiGeolocate;
                        }
                        else
                        {
                            iGeolocate__c NewObjiGeolocate=new iGeolocate__c();
                            NewObjiGeolocate.Contact__c = ObjContact.Id;
                            insert NewObjiGeolocate;
                        }
                    }
                    //If the record is an APC Area Director  
                    else if (ObjContact.Title == 'Area Director')
                    {
                        contactsToBeGeoHandled.add(ObjContact);
                    }
                }

                 string oldFirstName = trigger.oldMap.get(ObjContact.Id).FirstName;  
                 string newFirstName = trigger.newMap.get(ObjContact.Id).FirstName;  
                 string oldLastName = trigger.oldMap.get(ObjContact.Id).LastName;  
                 string newLastName = trigger.newMap.get(ObjContact.Id).LastName;  
                 string oldTitle = trigger.oldMap.get(ObjContact.Id).Title;
                 string newTitle = trigger.newMap.get(ObjContact.Id).Title;
                 string oldEmail = trigger.oldMap.get(ObjContact.Id).Email;
                 string newEmail = trigger.newMap.get(ObjContact.Id).Email;
                 string oldPhone = trigger.oldMap.get(ObjContact.Id).Phone;
                 string newPhone = trigger.newMap.get(ObjContact.Id).Phone;
                 
                 if(oldFirstName != newFirstName || oldLastName != newLastName || oldTitle!=newTitle ||  oldEmail!=newEmail || oldPhone!=newPhone){
                    List<Development_Plan__c> dev_plans_toUpdate = [select Id, Name, Supervisor_First_Name__c, Supervisor_Last_Name__c, Supervisor_Title__c, Supervisor_Email__c, Supervisor_Phone__c from Development_Plan__c where Supervisor_Contact__c = :ObjContact.Id];
                    for (Development_Plan__c dev_plan : dev_plans_toUpdate){
                        System.debug('*** updating contact information on development plan ' + dev_plan.Name);
                        System.debug('*** ... with the following Supervisor info: ' + newFirstName + ' ' + newLastName + ' ' + newTitle + ' ' + newEmail + ' ' + newPhone + ' ' );
                        dev_plan.Supervisor_First_Name__c = newFirstName;
                        dev_plan.Supervisor_Last_Name__c = newLastName;
                        dev_plan.Supervisor_Title__c = newTitle;
                        dev_plan.Supervisor_Email__c = newEmail;
                        dev_plan.Supervisor_Phone__c = newPhone;
                    }
                    update dev_plans_toUpdate;
                    }
                    
                 }
                //If there are contacts to be Geo-Handled
                if (contactsToBeGeoHandled.size() > 0){
                    gGeoC.sObjectList = contactsToBeGeoHandled;
                    gGeoC.theInstanceGateKeeper();
                }   
             //B-03185
           for(Contact ObjContact:trigger.new)
            { 
             if(ObjContact.Status__c == 'Inactive' && ObjContact.Intrax_Programs__c == 'Internship')
             {            
               User_Controller.DisableContact(ObjContact.Email);  
              
             }   
                
                
            }    
           //B-03185                   
            }
            //IUtilities.sContactAction(trigger.new);
        }   
     
    
    if(trigger.isBefore){
        Set<Id> lstConIds = new set<Id>();
        Set<Id> lstHCConIds = new set<Id>();
        boolean blnDeployTestFlag = Constants.blnDeployTestFlag;
        if(trigger.isUpdate){
            for(Contact ObjContact: Trigger.new){
                 string strContactName = objContact.Name;
                 boolean blnOldManualShare = trigger.oldMap.get(ObjContact.Id).ManualPartnerShareExists__c;
                 boolean blnNewManualShare = trigger.newMap.get(ObjContact.Id).ManualPartnerShareExists__c;
                 boolean blnOldManualHCShare = trigger.oldMap.get(ObjContact.Id).ManualHCPortalUserShareExists__c;
                 boolean blnNewManualHCShare = trigger.newMap.get(ObjContact.Id).ManualHCPortalUserShareExists__c;
               
                  if(blnOldManualShare!=blnNewManualShare && blnNewManualShare) 
                 {
                    if(!(blnDeployTestFlag && strContactName.containsIgnoreCase('Test')))
                     lstConIds.add(ObjContact.Id);    
                 }
                  if(blnOldManualHCShare!=blnNewManualHCShare && blnNewManualHCShare) 
                 {
                    if(!(blnDeployTestFlag && strContactName.containsIgnoreCase('Test')))
                     lstHCConIds.add(ObjContact.Id);    
                 }                
                system.debug('Inside Trigger con*******'+lstConIds); 
                 system.debug('Inside Trigger con lstHCConIds*******'+lstHCConIds); 
               }
                     if(lstConIds!=null && lstConIds.size()>0)
                     SharingSecurityHelper.sharePartnerContact(lstConIds);
                      if(lstHCConIds!=null && lstHCConIds.size()>0)
                     SharingSecurityHelper.shareHCPortalContact(lstHCConIds);
                     
            } 
        }
    }