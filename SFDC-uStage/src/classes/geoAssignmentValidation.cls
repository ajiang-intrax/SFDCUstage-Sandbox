public class geoAssignmentValidation {
    
    public Account HFAccount{get;set;}
    public String status{get;set;}
    googleGeoController gGeoC = new googleGeoController(); 
    public List<Account> HFAccList = new List<Account>();
    public Static Boolean isTestMode = false;
    //public List<iGeoLocate__c> iGeoL = new List<iGeoLocate__c>();
    public string context='';
    
    public geoAssignmentValidation(ApexPages.StandardController stdcontroller){
        HFAccount = (Account)stdController.getRecord(); 
        //HFAccList.add(HFAccount); 
        system.debug('HFAccList size standard constructor---->'+HFAccList.size());
    }
    
    public geoAssignmentValidation(){
        system.debug('HFAccList size main constructor---->'+HFAccList.size());
        context = 'Batch';
    }
    
    public List<Account> HFAccWOIGeoLocList = new List<Account>();
    //public List<Account> HFAccGeoMatToBeValidatedList = new List<Account>();
    public List<iGeoLocate__c> igeosToBeGeoCoded = new List<iGeoLocate__c>();
    public List<iGeoLocate__c> igeosToBeValidated = new List<iGeoLocate__c>();
    
    //bulkified load method
    public void loadforBatch(){
        //sent from scheduler
        
        system.debug('HFAccWOIGeoLocList size---->'+HFAccWOIGeoLocList.size());
        system.debug('igeosToBeGeoCoded size---->'+igeosToBeGeoCoded.size());
        system.debug('igeosToBeValidated size---->'+igeosToBeValidated.size());
        
        //1. no geolocate
        if(HFAccWOIGeoLocList!=null && HFAccWOIGeoLocList.size()>0){
            List<iGeoLocate__c> toBeCreatediGeoL = new List<iGeoLocate__c>();       
                for(Account hfacc:HFAccWOIGeoLocList){              
                    iGeoLocate__c newIGeoL = new iGeoLocate__c();
                    newIGeoL.Account__c = hfacc.Id;
                    toBeCreatediGeoL.add(newIGeoL);
                }               
                insert toBeCreatediGeoL;
                //insert and end of transaction         
        }
        //2. no latlong not geocoded                
        if(igeosToBeGeoCoded!=null && igeosToBeGeoCoded.size()>0){
            Set<Id> igeosToBeGeoCodedIds = new Set<Id>();
            
            for(iGeoLocate__c igeo:igeosToBeGeoCoded){
                igeosToBeGeoCodedIds.add(igeo.Id);
            }
            googleGeoController.computeGoogleGeoCode(igeosToBeGeoCodedIds);
        }
        
        //3. geolocateExists and geocoded. may/may not be geo matched 
        if(igeosToBeValidated!=null && igeosToBeValidated.size()>0){
            
            Set<Id> hfAccWithGeoLIds = new Set<Id>();
            Set<Id> iGeoLocateIds = new Set<Id>();
            Set<Id> HFAccountValidateDoneIds = new Set<Id>();
            Set<Id> HFAccountNeedsReviewIds = new Set<Id>();
            
            if(igeosToBeValidated!=null && igeosToBeValidated.size()>0){
                for(iGeoLocate__c igeoL : igeosToBeValidated){
                    iGeoLocateIds.add(igeoL.Id);
                    hfAccWithGeoLIds.add(igeoL.Account__r.Id);
                }   
            }
            
            List<Zip_Code__c> ADAssociatedWithZipList = [select Id,Zip_Code__c,area__r.area_director__r.contactid from zip_Code__c];
            Map<String,Zip_Code__c> mapZipStringCode = new Map<String,Zip_Code__c>();
            
            if(ADAssociatedWithZipList!=null && ADAssociatedWithZipList.size()>0){
                for(Zip_Code__c zip: ADAssociatedWithZipList){
                    mapZipStringCode.put(zip.Zip_Code__c, zip);
                }
            }
            
            //check for geoMatch
            for(iGeoLocate__c igeo:igeosToBeValidated){
                List<GeoMatch__c> geoMatchList = [SELECT Id,FromIGeoLocate__c,FromIGeoLocate__r.Id,ToIGeoLocate__c,ToIGeoLocate__r.Id,Match_Status__c,FromiGeoLocate__r.GeoAddress__Latitude__s,FromiGeoLocate__r.GeoAddress__Longitude__s,
                                    FromiGeoLocate__r.Account__r.Id,FromiGeoLocate__r.Account__r.PersonMailingPostalCode FROM GeoMatch__c WHERE FromIGeoLocate__c=:igeo.Id AND Match_Status__c='Geo Matched'];
                if(geoMatchList!=null && geoMatchList.size()>0){
                    //geoMatch exists
                    for(GeoMatch__c geoM:geoMatchList){
                        Double HFLat = geoM.FromiGeoLocate__r.GeoAddress__Latitude__s;
                        Double HFLong = geoM.FromiGeoLocate__r.GeoAddress__Longitude__s;
                        String zipCode = '';
                        
                        if (geoM.FromiGeoLocate__r.Account__r.PersonMailingPostalCode.contains('-'))
                            zipCode = geoM.FromiGeoLocate__r.Account__r.PersonMailingPostalCode.substring(0,geoM.FromiGeoLocate__r.Account__r.PersonMailingPostalCode.indexOfChar(45));
                        else
                            zipCode = geoM.FromiGeoLocate__r.Account__r.PersonMailingPostalCode;
                        
                        Zip_Code__c ADAssociatedWithZip = new Zip_Code__c();
                        ADAssociatedWithZip = mapZipStringCode.get(zipCode);
                        
                        Set<Id> toGeoIds = new Set<Id>();
                        toGeoIds.add(geoM.ToiGeoLocate__r.Id);
                        
                        if(ADAssociatedWithZip!=null && ADAssociatedWithZip.Id!=null)
                            googleGeoController.computeDistance1xn(geoM.FromiGeoLocate__r.Id,toGeoIds,ADAssociatedWithZip.Id,null,false);
                        else
                            googleGeoController.computeDistance1xn(geoM.FromiGeoLocate__r.Id,toGeoIds,null,null,false);
                        
                        //update accounts to done 
                        HFAccountValidateDoneIds.add(geoM.FromiGeoLocate__r.Account__r.Id);
                        /*for(Account HFAccount: HFAccGeoMatToBeValidatedList){
                            HFAccount.Geo_Validation_Status__c = 'Validation Done';
                        }*/
                                     
                    }
                }
                
            }                                    
            
                //excluding the geomatch existing ones here.
                hfAccWithGeoLIds.removeAll(HFAccountValidateDoneIds);
            
                Set<Id> toValidateAccIds = new Set<Id>();
                //no geoMatch
                //check if AP match exists for these HF Accounts
                for(Id accId:hfAccWithGeoLIds){
                    List<Match__c> matchList = [SELECT Position_Name__r.Host_Company_Id__c FROM Match__c WHERE Position_Name__r.Host_Company_Id__c =: accId];
                                
                    //List<Match__c> matchList = [SELECT Id,Position_Name__r.Host_Company_Id__c FROM Match__c WHERE Position_Name__r.Host_Company_Id__c IN: hfAccWithGeoLIds];
                    //if match exists mark these accounts as needs review
                    if(matchList!=null && matchList.size()>0){                        
                        try{
                            //update HF Account as "needs review". With no geo match, there should be no Match also.
                            for(Match__c m:matchList){
                                HFAccountNeedsReviewIds.add(m.Position_Name__r.Host_Company_Id__c);
                            }
                            /*
                            for(Account HFAccount: HFAccGeoMatToBeValidatedList){
                                HFAccount.Geo_Validation_Status__c = 'Needs Review';
                            }*/
                                            
                        }
                        catch(exception e){
                            system.debug('EXCEPTION IN UPDATING ACCOUNT to Needs Review---->'+e);
                        }
                             
                    }
                    //if no AP match. collect those ids and do geo validation
                    else{
                        toValidateAccIds.add(accId);
                    }
                }
                
                List<iGeoLocate__c> iGeoList = [select i.Applicant_Info__r.Home_Street_1__c,i.Applicant_Info__r.Home_Street_2__c,
                                                i.Applicant_Info__r.Home_City__c,i.Applicant_Info__r.Home_State__c,
                                                i.Applicant_Info__r.Home_Country__c,i.Applicant_Info__r.Home_Postal_Code__c,
                                                i.Contact__r.MailingStreet,i.Contact__r.MailingCity,i.Contact__r.MailingState,
                                                i.Contact__r.MailingCountry,i.Contact__r.MailingPostalCode,
                                                i.Lead__r.Street,i.Lead__r.City,i.Lead__r.State,i.Lead__r.PostalCode,i.Lead__r.Country,                                            
                                                i.Account__r.PersonMailingStreet,i.Account__r.PersonMailingCity,i.Account__r.PersonMailingState,i.Account__r.PersonMailingPostalCode,i.Account__r.PersonMailingCountry,
                                                i.Zip_Code__r.State__c,i.Zip_Code__r.Zip_Code__c   
                                                 from iGeoLocate__c i where Account__c IN:toValidateAccIds];
                
                    //treat as new HF. do full computation.
                    if(iGeoList!=null && iGeoList.size()>0){
                        googleGeoController gGeoC = new googleGeoController();                                                  
                        gGeoC.sObjectList = iGeoList;
                        gGeoC.handleGeoProcessesForBatch();                                     
                        
                    
                        if(googleGeoController.geoMatchesHistoryMaster!=null && googleGeoController.geoMatchesHistoryMaster.size()>0)
                                insert googleGeoController.geoMatchesHistoryMaster;
                        if(googleGeoController.geoMatchesProcessedMaster!=null && googleGeoController.geoMatchesProcessedMaster.size()>0)
                            insert googleGeoController.geoMatchesProcessedMaster;
            
                    
                        //change ownership also. if match created.
                        List<GeoMatch__c> geoMatches = [SELECT Id FROM GeoMatch__c WHERE FromIGeoLocate__c=:iGeoLocateIds AND Match_Status__c='Geo Matched'];
                        if(geoMatches!=null && geoMatches.size()>0){                    
                            geoReASsign geoReAss = new geoReAssign();
                            geoReAss.changeOwnerForGeoMatchedRelatedObjs(geoMatches);                                                   
                            /*
                            for(Account HFAccount: HFAccGeoMatToBeValidatedList){
                                HFAccount.Geo_Validation_Status__c = 'Validation Done';
                            }*/
                        }   
                    }
            
                                
            HFAccountValidateDoneIds.addAll(toValidateAccIds);  
            
            system.debug('size--->'+googleGeoController.geoMatchesHistoryMaster.size());
            system.debug('size--->'+googleGeoController.geoMatchesProcessedMaster.size());
            system.debug('size--->'+googleGeoController.existingGeoMatchListMaster.size());
            system.debug('size--->'+googleGeoController.serializedMatchMaster.size()); 
            system.debug('size--->'+googleGeoController.noMatchListMaster.size());
            
            //if(googleGeoController.existingGeoMatchListMaster!=null && googleGeoController.existingGeoMatchListMaster.size()>0)
            //  update googleGeoController.existingGeoMatchListMaster; 
            if(googleGeoController.existingGeoMatchListMasterMap!=null && googleGeoController.existingGeoMatchListMasterMap.size()>0)
                update googleGeoController.existingGeoMatchListMasterMap.values(); 
            
            if(googleGeoController.serializedMatchMaster!=null && googleGeoController.serializedMatchMaster.size()>0)
                insert googleGeoController.serializedMatchMaster;
            
            if(googleGeoController.noMatchListMaster!=null && googleGeoController.noMatchListMaster.size()>0)
                insert googleGeoController.noMatchListMaster;
            
            
            if(HFAccountValidateDoneIds!=null && HFAccountValidateDoneIds.size()>0){
                List<Account> accList = [SELECT Id,Geo_Validation_Status__c FROM Account WHERE ID IN:HFAccountValidateDoneIds];
                if(accList!=null && accList.size()>0){
                    for(Account a:accList){
                        a.Geo_Validation_Status__c = 'Validation Done';
                    }
                    update accList;
                }
            }
            if(HFAccountNeedsReviewIds!=null && HFAccountNeedsReviewIds.size()>0){
                List<Account> accList = [SELECT Id,Geo_Validation_Status__c FROM Account WHERE ID IN:HFAccountNeedsReviewIds];
                if(accList!=null && accList.size()>0){
                    for(Account a:accList){
                        a.Geo_Validation_Status__c = 'Needs Review';
                    }
                    update accList;
                }
            }
            
            //update HFAccGeoMatToBeValidatedList;      
        }
    }
    
    public PageReference load(){
        system.debug('HFAccList size---->'+HFAccList.size());   
        //this is for batch
        if(context == 'Batch'){
            if(HFAccList!=null && HFAccList.size()>0)
                HFAccount = HFAccList[0];
        }
        //CHECK IF HF IS MGRATED or Not.  Utility is migrated HFs only.
        HFAccount = [SELECT Id,Sys_Admin_Tag__c,Geo_Validation_Status__c FROM Account WHERE Id=:HFAccount.Id LIMIT 1];
        if(HFAccount.Sys_Admin_Tag__c!=null && (HFAccount.Geo_Validation_Status__c=='' || HFAccount.Geo_Validation_Status__c==null)){
            //check for geoLocate
            List<iGeoLocate__c> iGeoL = [SELECT Id,GeoAddress__Latitude__s FROM iGeoLocate__c WHERE Account__c =: HFAccount.Id];
            if(iGeoL!=null && iGeoL.size()>0 && iGeoL[0].GeoAddress__Latitude__s!=null){            
                
                //check for geoMatch
                List<GeoMatch__c> geoM = [SELECT Id,FromIGeoLocate__c,FromIGeoLocate__r.Id,ToIGeoLocate__c,ToIGeoLocate__r.Id,Match_Status__c,FromiGeoLocate__r.GeoAddress__Latitude__s,FromiGeoLocate__r.GeoAddress__Longitude__s,
                                            FromiGeoLocate__r.Account__r.PersonMailingPostalCode FROM GeoMatch__c WHERE FromIGeoLocate__c=:iGeoL[0].Id AND Match_Status__c='Geo Matched'];
                if(geoM!=null && geoM.size()>0){                    
                        
                    //Do 1-1 computation b/w HF and assigned AD i.e., FromIGeo to ToIGeo
                    if(geoM[0].Match_Status__c=='Geo Matched'){                 
                        //compute 1-1. From - HF ; To - AD
                        Double HFLat = geoM[0].FromiGeoLocate__r.GeoAddress__Latitude__s;
                        Double HFLong = geoM[0].FromiGeoLocate__r.GeoAddress__Longitude__s;
                        String zipCode = '';
                        
                        System.debug('LATITUDE---->'+HFLat);
                        System.debug('LONGITUDE---->'+HFLong);                  
                        
                        if (geoM[0].FromiGeoLocate__r.Account__r.PersonMailingPostalCode.contains('-'))
                            zipCode = geoM[0].FromiGeoLocate__r.Account__r.PersonMailingPostalCode.substring(0,geoM[0].FromiGeoLocate__r.Account__r.PersonMailingPostalCode.indexOfChar(45));
                        else
                            zipCode = geoM[0].FromiGeoLocate__r.Account__r.PersonMailingPostalCode;    
                        
                        
                        Zip_code__c ADAssociatedWithZip = new Zip_Code__c();
                        iGeoLocate__c ADiGeoLocate = new iGeoLocate__c();
                        
                        List<Zip_Code__c> ADAssociatedWithZipList = [select area__r.area_director__r.contactid from zip_Code__c where zip_code__c = :zipCode];
                        if(ADAssociatedWithZipList!=null && ADAssociatedWithZipList.size()>0){
                            ADAssociatedWithZip = ADAssociatedWithZipList[0];
                        }   
                        
                        Set<Id> toGeoIds = new Set<Id>();
                        toGeoIds.add(geoM[0].ToiGeoLocate__r.Id);                   
                        
                        //computeDistance(fromGeo,toGeo,ZipCode,GeoMatch);
                        //computeDistance1x1(geoM[0].FromiGeoLocate__r.Id,geoM[0].ToiGeoLocate__r.Id,ADAssociatedWithZip.Id,geoM[0].Id);         
                        
                        //computeDistance1xn (Id fromGeoId,set<Id> toiGeoIds,Id associatedZip,googleGeoController geoC,Boolean alreadyAMassComputation)
                        googleGeoController.computeDistance1xn(geoM[0].FromiGeoLocate__r.Id,toGeoIds,ADAssociatedWithZip.Id,null,false);   
                        
                        updateAccToDone();
                        status = 'Validation successfully done. GeoMatch updated.';            
                    }           
                }
                else{
                    //no geo match.                     
                    //check if match exists for this HF Account
                    List<Match__c> matchList = [SELECT Id FROM Match__c WHERE Position_Name__r.Host_Company_Id__c=:HFAccount.Id];
                    if(matchList!=null && matchList.size()>0){
                        //update HF Account as "needs review". With no geo match, there should be no Match also.
                        try{
                            HFAccount.Geo_Validation_Status__c = 'Needs Review';
                            update HFAccount;  
                            status = 'Validation done.  No existing AD assigned. But match exists!  Needs Review.  Account Flagged.';
                        }
                        catch(exception e){
                            system.debug('EXCEPTION IN UPDATING ACCOUNT to Needs Review---->'+e);
                        }
                             
                    }   
                    else{
                        //treat as new HF. do full computation.
                        //Match();
                        doGeoMatch(iGeoL[0].Id);
                        
                        UpdateAccToDone();
                        
                        //change ownership also. if match created.
                        List<GeoMatch__c> geoMat = [SELECT Id FROM GeoMatch__c WHERE FromIGeoLocate__c=:iGeoL[0].Id AND Match_Status__c='Geo Matched'];
                        if(geoMat!=null && geoMat.size()>0){                    
                            geoReASsign geoReAss = new geoReAssign();
                            geoReAss.changeOwnerForGeoMatchedRelatedObjs(geoMat);   
                            
                            status = 'Validation successfully done. GeoMatch Created. Account/Application/Position ownerships changed.';    
                        }       
                        else
                            status = 'Validation successfully done. GeoMatch Created.'; 
                    }           
                }
            }
            else{               
                //not geo coded.
                //status = 'No Geo Locate & Geo Match';
                if(context != 'Batch'){
                    if(ApexPages.currentPage().getUrl()!=null && ApexPages.currentPage().getUrl().contains('geoAssignValidationIntermediate')){
                        Set<Id> iGeoIds = new Set<Id>();
                        iGeoIds.add(iGeoL[0].Id);                           
                                        
                        //geoCoding. working. future call           
                        //googleGeoController.createGoogleReadyAddressString(iGeoL[0]);
                        //computeGoogleGeoCodeHERE(iGeoIds);
                        googleGeoController.computeGoogleGeoCode(iGeoIds);
                        status = 'Validation Successfully Done. Geo Coded.'; 
                    }
                    else{
                        googleGeoController.iAmAlreadyCalled = true;
                        
                        //insert geoLocate and call load again. so it checks.
                        iGeoLocate__c newIGeo = new iGeoLocate__c();
                        newIGeo.Account__c = HFAccount.Id;
                        insert newIGeo;     
                    }                               
                        //testing to call existing. not working. it has to be future.
                        //Error:You have uncommitted work pending. Please commit or rollback before calling out
                        //googleGeoController.computeGoogleGeoCode(iGeoIds);
                        PageReference p = new PageReference('/apex/geoAssignValidationIntermediate?Id='+HFAccount.Id);
                        p.setRedirect(true);
                        return p;               
                }
                //batch
                else{
                    if(iGeoL!=null && iGeoL.size()==0){
                        googleGeoController.iAmAlreadyCalled = true;
                        
                        iGeoLocate__c newIGeo = new iGeoLocate__c();
                        newIGeo.Account__c = HFAccount.Id;
                        insert newIGeo; 
                    }
                    else{
                        Set<Id> iGeoIds = new Set<Id>();
                        iGeoIds.add(iGeoL[0].Id);                           
                                        
                        googleGeoController.computeGoogleGeoCode(iGeoIds);
                    }       
                    
                    load();         
                }           
            }
        }//sys admin tag
        
        else{
            if(HFAccount.Sys_Admin_Tag__c==null || HFAccount.Sys_Admin_Tag__c=='')
                status='This HF Account cannot be validated.  Validation Utility is only for Migrated HFs';
            else if(HFAccount.Geo_Validation_Status__c!='')
                status='This HF Account is already validated.';
            return null;
        }
        return null;
    }
    /*
    public string sTypeParam{get;set;}
    public String sType {
        get;
        // *** setter is NOT being called ***
        set {
            sType = value;
            System.debug('value: '+value);
        }
    }        
    */
    
    //this is for creating geoMatch
    public void Match(){
        List<iGeoLocate__c> iGeoL = [SELECT Id FROM iGeoLocate__c WHERE Account__c =: HFAccount.Id];
        if(iGeoL!=null && iGeoL.size()>0){
            doGeoMatch(iGeoL[0].Id);
            status='Matching Done';                 
        }       
    }
    
    public void updateAccToDone(){
        try{
            HFAccount.Geo_Validation_Status__c = 'Validation Done';
            update HFAccount;
        }
        catch(exception e){
            system.debug('EXCEPTION IN UPDATING ACCOUNT to DONE---->'+e);
        }
    }
    
    public pageReference viewAccount(){
        PageReference acc = new PageReference('/'+HFAccount.Id);
        return acc;
    }
        
    public static void doGeoMatch(Id iGeoL){
        List<iGeoLocate__c> newIGeoList = [select i.Applicant_Info__r.Home_Street_1__c,i.Applicant_Info__r.Home_Street_2__c,
                                            i.Applicant_Info__r.Home_City__c,i.Applicant_Info__r.Home_State__c,
                                            i.Applicant_Info__r.Home_Country__c,i.Applicant_Info__r.Home_Postal_Code__c,
                                            i.Contact__r.MailingStreet,i.Contact__r.MailingCity,i.Contact__r.MailingState,
                                            i.Contact__r.MailingCountry,i.Contact__r.MailingPostalCode,
                                            i.Lead__r.Street,i.Lead__r.City,i.Lead__r.State,i.Lead__r.PostalCode,i.Lead__r.Country,
                                            //i.Account__r.BillingStreet,i.Account__r.BillingCity,i.Account__r.BillingState,i.Account__r.BillingPostalCode,i.Account__r.BillingCountry,
                                            i.Account__r.PersonMailingStreet,i.Account__r.PersonMailingCity,i.Account__r.PersonMailingState,i.Account__r.PersonMailingPostalCode,i.Account__r.PersonMailingCountry,
                                            i.Zip_Code__r.State__c,i.Zip_Code__r.Zip_Code__c   
                                             from iGeoLocate__c i where Id=:iGeoL];
        googleGeoController gGeoC = new googleGeoController();                                    
        gGeoC.HFAccount = null;
        gGeoC.iGeoLocate = newIGeoList[0];
        gGeoC.handleGeoProcesses();         
    }
    
    /*
    @future(callout=true)   
    public static void computeGoogleGeoCodeHERE(Set<Id> iGeoIds){
        
        System.debug(iGeoIds);
        List<iGeoLocate__c> toBeGeoCoded = [select i.Applicant_Info__r.Home_Street_1__c,i.Applicant_Info__r.Home_Street_2__c,
                                            i.Applicant_Info__r.Home_City__c,i.Applicant_Info__r.Home_State__c,
                                            i.Applicant_Info__r.Home_Country__c,i.Applicant_Info__r.Home_Postal_Code__c,
                                            i.Contact__r.MailingStreet,i.Contact__r.MailingCity,i.Contact__r.MailingState,
                                            i.Contact__r.MailingCountry,i.Contact__r.MailingPostalCode,
                                            i.Lead__r.Street,i.Lead__r.City,i.Lead__r.State,i.Lead__r.PostalCode,i.Lead__r.Country,
                                            //i.Account__r.BillingStreet,i.Account__r.BillingCity,i.Account__r.BillingState,i.Account__r.BillingPostalCode,i.Account__r.BillingCountry,
                                            i.Account__r.PersonMailingStreet,i.Account__r.PersonMailingCity,i.Account__r.PersonMailingState,i.Account__r.PersonMailingPostalCode,i.Account__r.PersonMailingCountry,
                                            i.Zip_Code__r.State__c,i.Zip_Code__r.Zip_Code__c   
                                             from iGeoLocate__c i where Id in :iGeoIds];
        Http h = new Http();
        HttpResponse res = new HttpResponse();
        HttpRequest req = new HttpRequest();
        List<iGeoLocate__c> geoCoded = new List<iGeoLocate__c>();
        Boolean pickedLocation = false;
        Boolean pickedLocationLatLong = false;
        
        for (iGeoLocate__c i : toBeGeoCoded){
            req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            req.setHeader('Content-length', '0');
            if (googleGeoController.createGoogleReadyAddressString(i)){
                req.setEndpoint('https://maps.googleapis.com/maps/api/geocode/json?address='+googleGeoController.googleReadyAddressString+'&key=AIzaSyDhHJveUM7lfcyYvhdzrMnWN_pEvbjnQ24');
                req.setMethod('POST'); 
                //req.setBody('');
                String responseJson;
                if (!isTestMode){
                    res = h.send(req);
                    responseJson = res.getBody();
                }
                else{
                    responseJson = Test_IntraxTestConstants.googleGeoCodeSampleResponse;
                }
                    
                JSONParser parser = JSON.createParser(responseJson);
                System.debug(responseJson);
                pickedLocation = false;
                pickedLocationLatLong = false;
                while (parser.nextToken() != null) {
                    if (!pickedLocation && (parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'location')) {
                        System.debug('A big true');
                        pickedLocation = true;
                    }
                    if (pickedLocation && !pickedLocationLatLong && (parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'lat')) {
                        parser.nextToken();
                        System.debug('Latitude:'+parser.getDoubleValue());
                            i.GeoAddress__Latitude__s = parser.getDoubleValue();
                    }
                    if (pickedLocation && !pickedLocationLatLong && (parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'lng')) {
                        parser.nextToken();
                        System.debug('Longitude:'+parser.getDoubleValue());
                            i.GeoAddress__Longitude__s = parser.getDoubleValue();
                        pickedLocationLatLong = true;
                    }
                    if (pickedLocation && pickedLocationLatLong)
                        break;
            }
                geoCoded.add(i);
            }
        }
        googleGeoController.iAmAlreadyCalled = true;
        system.debug('********geoCoded**********'+geoCoded);
        update geoCoded;               
        
    }
    
    //1-1
    public static void computeDistance1x1 (Id fromGeoId,Id toiGeoId,Id associatedZip,Id geoMatchId){
        //Beef up the From and To iGeoLocates
        iGeoLocate__c fromiGeoLocate = [select id,Applicant_Info__r.Name,Contact__r.Name,Account__r.Name,Lead__r.Name,GeoAddress__Latitude__s,GeoAddress__Longitude__s from iGeoLocate__c where id =:fromGeoId];
        iGeoLocate__c toiGeoLocate = [select id,Applicant_Info__r.Name,Contact__r.Name,Account__r.Name,GeoAddress__Latitude__s,GeoAddress__Longitude__s from iGeoLocate__c where id =:toiGeoId];
        //The API limits - ******Need to revisit this*******
        //integer toLimit = 80;
        //integer toCounter = 0;
        String origins = '';
        String destinations = '';
        //The 1 in N
        googleGeoDistanceMatrixElementOneD aMate;
        //The N
        googleGeoDistanceMatrixElementOneD dMate;// = new googleGeoDistanceMatrixElementOneD();
        //The 1:N
        Map<Id,googleGeoDistanceMatrixElementOneD> odGroup = new Map<Id,googleGeoDistanceMatrixElementOneD>();
        origins = fromiGeoLocate.GeoAddress__Latitude__s.toPlainString()+','+fromiGeoLocate.GeoAddress__Longitude__s.toPlainString();
        //With the limit in check, keep appending the to Geo's as a string and populate the N
        
            if (destinations == '')
                destinations = toiGeoLocate.GeoAddress__Latitude__s.toPlainString()+','+toiGeoLocate.GeoAddress__Longitude__s.toPlainString();
            else
                destinations = destinations + '|' + toiGeoLocate.GeoAddress__Latitude__s.toPlainString()+','+toiGeoLocate.GeoAddress__Longitude__s.toPlainString();
            dMate = new googleGeoDistanceMatrixElementOneD(toiGeoLocate,(Double)toiGeoLocate.GeoAddress__Latitude__s,(Double)toiGeoLocate.GeoAddress__Longitude__s );
            //dMates.add(aMate);
            //toCounter++;
         
        //The 1:N is set
        odGroup.put(fromiGeoLocate.Id,dMate);
        System.debug('odGroup----->'+odGroup);
        //Connect to GDMatrix API
        googleDistanceMatrix gdMatrix = callGDMatrixAPI(origins,destinations);
        System.debug(gdMatrix);
        
        integer colCounter = 0;
        String WithInRangeOfZipCodeAD='';
        //Overlaying the parsed Google result onto the N list, paris set as Compatible vs inCompatible 
        googleGeoDistanceMatrixElementOneD ge = odGroup.get(fromiGeoLocate.Id);
        
            if (gdMatrix.rows[0].elements[colCounter].status == 'OK' ){
                if (gdMatrix.rows[0].elements[colCounter].distance.value == null){
                    ge.markAsInCompatible();
                    WithInRangeOfZipCodeAD = 'No';
                }
                else if(gdMatrix.rows[0].elements[colCounter].duration.value == null){
                    ge.markAsInCompatible();
                    WithInRangeOfZipCodeAD = 'No';
                }
                else{
                    ge.distanceInKms = ((double)gdMatrix.rows[0].elements[colCounter].distance.value)/1000;
                    ge.durationInMins = ((double)gdMatrix.rows[0].elements[colCounter].duration.value)/60;
                    if (ge.durationInMins > 60){
                        ge.markAsInCompatible();
                        WithInRangeOfZipCodeAD = 'No';
                    }
                    else{
                        ge.markAsCompatible();
                        WithInRangeOfZipCodeAD = 'Yes';
                    }
                }
            }
            else{
                ge.markAsInCompatible();
                WithInRangeOfZipCodeAD = 'No';
            }
        //colCounter++;
        
        System.debug(odGroup);
        //Create a match , store the 1:N computed matrix as a serialized data
        geoMatch__c geoM = [SELECT Id,serializedMatchMatrix__c,Associated_Zip_Code__c,Is_In_Range_Of_ZipCode_AD__c FROM geoMatch__c WHERE Id=:geoMatchId];
        
        //geoMatch__c serializedMatch = new geoMatch__c();
        //serializedMatch.FromiGeoLocate__c = fromiGeoLocate.Id;
        //serializedMatch.FromGeoAddress__Latitude__s = fromiGeoLocate.GeoAddress__Latitude__s;
        //serializedMatch.FromGeoAddress__Longitude__s = fromiGeoLocate.GeoAddress__Longitude__s;
        geoM.serializedMatchMatrix__c = JSON.serialize(odGroup);
        //if (associatedZip != null){
        //    geoM.Associated_Zip_Code__c = associatedZip;
        //}                
        geoM.Is_In_Range_Of_ZipCode_AD__c = WithInRangeOfZipCodeAD;
        update geoM;
        
        //call a method to mark HFAccount as validation done.        
          
    }
    
    //The GDMatrix call abstracted out for 1x1
    public static googleDistanceMatrix callGDMatrixAPI(String origins, String destinations){
    //Connect to GDMatrix API
        Http h = new Http();
        HttpResponse res = new HttpResponse();
        HttpRequest req = new HttpRequest();
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        req.setHeader('Content-length', '0');
        req.setEndpoint('https://maps.googleapis.com/maps/api/distancematrix/json?origins='+origins+'&destinations='+destinations+'&key=AIzaSyDhHJveUM7lfcyYvhdzrMnWN_pEvbjnQ24');
        req.setMethod('POST'); 
        System.debug(req);
        String responseJson;
        if (!isTestMode){
            res = h.send(req);
            responseJson = res.getBody();
        }
        else{
            responseJson = Test_IntraxTestConstants.googleGeoDistanceSampleResponse;
        }
        JSONParser parser = JSON.createParser(responseJson);
        System.debug(responseJson);
        googleDistanceMatrix gdMatrix = (googleDistanceMatrix)parser.readValueAs(googleDistanceMatrix.class);
        System.debug(gdMatrix);
        return gdMatrix;
    }
    */
    
}