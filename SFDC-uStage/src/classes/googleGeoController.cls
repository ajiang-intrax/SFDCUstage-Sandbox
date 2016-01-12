/*

The Master controller for handling geo-processes with Google API

The following api's are used:

1) Google GeoCoding API
2) Google Distance Matrix API

The calls are REST calls

*/

public class googleGeoController {
    public static String googleReadyAddressString {get; set;}
    public static Boolean iAmAlreadyCalled = false;
    public static Contact onDemandAD {get; set;}
    public static Account onDemandHF {get; set;}  
    List<List<googleGeoDistanceMatrixElement>> distanceMatrix {get;set;}
    Map<Id,List<googleGeoDistanceMatrixElementOneD>> odGroup {get;set;}
    public Applicant_Info__c applicantInfo {get;set;}
    public iGeoLocate__c iGeoLocate {get;set;}
    public Contact staffContact {get;set;}
    public Account HostFamilyAcc {get;set;}
    public Account HFAccount {get;set;}
    public Lead HFLead {get;set;}
    public Zip_Code__c zipCode {get;set;}
    public GeoMatch__c geoMatch {get;set;}
    public Id matchedToGeoLocateId {get;set;}
    public List<Applicant_Info__c> appInfoList {get;set;}
    public List<Contact> contactList {get;set;}
    public List<Lead> leadList {get;set;}
    public List<Account> accountList {get;set;}
    public List<Zip_Code__c> zipList {get;set;}
    public List<sObject> sObjectList {get;set;}
    public List<iGeoLocate__c> iGeoListForBatchGeoCode {get;set;}
    public List<iGeoLocate__c> iGeoListForBatchGeoDistance {get;set;}
    public iGeoLocate__c fromGeo {get;set;}
    public Map<Id,Map<String,String>> adAddresses {get;set;}
    public Static Boolean isTestMode = false;
    public String distanceReComputationType = 'YetToBegin';
    public List<GeoMatch__c> geoMatchesHistory{get;set;}
    public Boolean uniMatch{get;set;}
    public iGeoLocate__c iGeoForZip {get;set;}
    public iGeoLocate__c iGeoForAD {get;set;}
    public Integer compatiblePair{get;set;}
    public Integer incompatiblePair{get;set;}
    public static Boolean changeOwnerCalled = false;
    public String sType{get;set{sType=value;}}
    public List<Applicant_Info__c> applicationsChOwned = new List<Applicant_Info__c>();
    public static List<GeoMatch__c> geoMatchesHistoryMaster = new List<GeoMatch__c>();
    public static List<GeoMatch__c> geoMatchesProcessedMaster = new List<GeoMatch__c>();  
    public static List<GeoMatch__c> existingGeoMatchListMaster = new List<GeoMatch__c>();
    public static List<GeoMatch__c> serializedMatchMaster = new List<GeoMatch__c>();
    public static List<GeoMatch__c> noMatchListMaster = new List<GeoMatch__c>();
    
    public static Map<Id,GeoMatch__c> existingGeoMatchListMasterMap = new Map<Id,GeoMatch__c>();
    
    //This is for triggers to handle the super conductor
    public static void theGateKeeper(Set<Id> iGeoIds){
        if (iAmAlreadyCalled)
            return;
        else{
            googleGeoController.iAmAlreadyCalled = true;
            computeGoogleGeoCode_future(iGeoIds);
        }
    }
    
    public void theInstanceGateKeeper(){
        System.debug('theInstanceGateKeeper iAmAlreadyCalled ---> '+iAmAlreadyCalled);
        if(iAmAlreadyCalled){           
            return;
        }
        else{
            if(changeOwnerCalled){
                changeOwnerForGeoMatchedApplications(sObjectList);
            }
            else{
                handleGeoProcessesForBatch();
            }
            //computeGoogleGeoCode_future(iGeoIds);
            
        }       
    }
    
    //Default Constructor
    public googleGeoController(){
        System.debug('Inside constructor after instance creation and iAmAlreadyCalled is: '+iAmAlreadyCalled);
        sObjectList = new List<sObject>();
        geoMatchesHistory = new List<GeoMatch__c>();
    }
    
    //The Overloaded one for page level calls
    //Button Click objects need to be instantiated here
    public googleGeoController(ApexPages.StandardController stdcontroller){
        System.debug('sType----constructor---->'+ApexPages.currentPage().getParameters().get('sType'));
        sType = '';
        sObject theObject = stdController.getRecord();
        if (theObject.getSObjectType() == GeoMatch__c.SObjectType){
            geoMatch = (geoMatch__c)stdController.getRecord();
            geoMatch = [select Id,FromiGeoLocate__r.Account__r.Name,Duration_In_Mins__c,ToiGeoLocate__c,ToiGeoLocate__r.Id,ToiGeoLocate__r.Contact__r.Name,HF_Ownership_Set__c,ToGeoAddress__latitude__s,ToGeoAddress__longitude__s from GeoMatch__c where Id = :geoMatch.Id];
        }
        else if (theObject.getSObjectType() == Applicant_Info__c.SObjectType)
            applicantInfo = (Applicant_Info__c)stdController.getRecord();
        else if (theObject.getSObjectType() == iGeoLocate__c.SObjectType)
            iGeoLocate = (iGeoLocate__c)stdController.getRecord();
        else if (theObject.getSObjectType() == Contact.SObjectType)
            staffContact = (Contact)stdController.getRecord();
        else if (theObject.getSObjectType() == Lead.SObjectType)
            HFLead = (Lead)stdController.getRecord();
        else if (theObject.getSObjectType() == Account.SObjectType)
            HFAccount = (Account)stdController.getRecord();
        else if (theObject.getSObjectType() == Zip_Code__c.SObjectType)
            zipCode = (Zip_Code__c)stdController.getRecord();
        System.debug(iGeoLocate);
        distanceMatrix = new List<List<googleGeoDistanceMatrixElement>>();
        odGroup = new Map<Id,List<googleGeoDistanceMatrixElementOneD>>(); 
    }
    
    @RemoteAction
    public static Contact getStaffContactDetails(String adId){
        onDemandAD = [select mailingStreet,mailingCity,mailingState,mailingCountry,mailingPostalCode from Contact where Id = :adId];
        return onDemandAD;
    }
    
    public static Account getHostFamilyContactDetails(String hfId){
        onDemandHF = [select PersonMailingStreet,PersonMailingCity,PersonMailingState,PersonMailingPostalCode,PersonMailingCountry from Account where Id = :hfId];
        return onDemandHF;
    }
    
    //For future calls to be made in trigger context
    @Future(callout=true)
    public static void computeGoogleGeoCode_future(Set<Id> iGeoIds){
        computeGoogleGeoCode(iGeoIds);
    }
    
    public PageReference HFChangeOwner(){
        //Ownership change moved from //Geo Controller to the trigger // to after 3rd page in HF application
        Id appId;
        List<Applicant_Info__c> appList = new List<Applicant_Info__c>();
        
        appId = ApexPages.currentPage().getParameters().get('Id');
        if(appId!=null){
            appList = [SELECT Id,Account__c,OwnerId FROM Applicant_Info__c WHERE Id=:appId LIMIT 1];
        }
        
        if(appList!=null && appList.size()>0){    
            if(appList[0].Account__c!=null){        
                List<GeoMatch__c> geoMatchesForOwnerChange = [select Match_Status__c,HF_Ownership_Set__c,Duration_In_Mins__c,FromiGeoLocate__r.Lead__c,FromiGeoLocate__r.Lead__r.Id,FromiGeoLocate__r.Account__c,FromiGeoLocate__r.Account__r.Id,FromiGeoLocate__r.Applicant_Info__c,FromiGeoLocate__r.Applicant_Info__r.Id,ToiGeoLocate__r.Contact__c,ToiGeoLocate__r.Contact__r.Id from GeoMatch__C where FromiGeoLocate__r.Account__c !=NULL AND HF_Ownership_Set__c=false AND FromiGeoLocate__r.Account__c=:appList[0].Account__c AND Match_Status__c='Geo Matched'];
                if(geoMatchesForOwnerChange!=null && geoMatchesForOwnerChange.size()>0){                
                    //gGeoC.changeOwnerForGeoMatchedApplications(geoMatchesForOwnerChange);                  
                    //sObjectList = geoMatchesForOwnerChange;                   
                    //changeOwnerCalled = true;
                    changeOwnerForGeoMatchedApplications(geoMatchesForOwnerChange); 
                    //InstanceGateKeeper();
                                    
                    for(Applicant_Info__c appCh:applicationsChOwned){                    
                        if(appId == appCh.Id){
                            appList[0].OwnerId = appCh.OwnerId;                            
                            geoMatchesForOwnerChange[0].HF_Ownership_Set__c = TRUE;                                                                            
                        }                                           
                    }
                    try{
                        update appList[0];
                        update geoMatchesForOwnerChange[0]; 
                    }
                    catch(exception e){
                        System.debug('Exception in change owner------>'+e);
                    }
                }
            }
        }
        //PageReference p = new PageReference('/apex/apc_hf_app_program_pref?id='+appId);
        PageReference p = new PageReference('/apex/apc_hf_app_references?id='+appId);
        p.setRedirect(true);
        return p;
    }
    
    //The core GeoCode method
    public static void computeGoogleGeoCode(Set<Id> iGeoIds){
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
        
        String googleAPIKey = Global_Constants__c.getInstance().Google_API_Key__c;
        String googleGeoCodeEndPoint = Global_Constants__c.getInstance().Google_Geo_Code_Endpoint__c;
        
        for (iGeoLocate__c i : toBeGeoCoded){
            req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            req.setHeader('Content-length', '0');
            if (createGoogleReadyAddressString(i)){
                req.setEndpoint(googleGeoCodeEndPoint+'?address='+googleReadyAddressString+'&key='+googleAPIKey);
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
    
    //The future method for distance computation to help with trigger context
    @Future(callout=true)
    public static void computeDistance_future (Id fromiGeoId,set<Id> toiGeoIds,Id associatedZip,Boolean alreadyAMassComputation){
        //computeDistance (fromiGeoIds,toiGeoIds);
        computeDistance1xn(fromiGeoId,toiGeoIds,associatedZip,null,alreadyAMassComputation);
    }
    //m*n , where m = 1
    public static void computeDistance1xn (Id fromGeoId,set<Id> toiGeoIds,Id associatedZip,googleGeoController geoC,Boolean alreadyAMassComputation){        
        //Beef up the From and To iGeoLocates
        iGeoLocate__c fromiGeoLocate = [select id,Applicant_Info__r.Name,Contact__r.Name,Account__r.Name,Lead__r.Name,GeoAddress__Latitude__s,GeoAddress__Longitude__s from iGeoLocate__c where id = :fromGeoId];
        List<iGeoLocate__c> toiGeoLocates = [select id,Applicant_Info__r.Name,Contact__r.Name,Account__r.Name,GeoAddress__Latitude__s,GeoAddress__Longitude__s from iGeoLocate__c where id in :toiGeoIds];
        //The API limits - ******Need to revisit this*******
        integer toLimit = 80;
        integer toCounter = 0;
        String origins = '';
        String destinations = '';
        //The 1 in N
        googleGeoDistanceMatrixElementOneD aMate;
        //The N
        List<googleGeoDistanceMatrixElementOneD> dMates = new List<googleGeoDistanceMatrixElementOneD>();
        //The 1:N
        Map<Id,List<googleGeoDistanceMatrixElementOneD>> odGroup = new Map<Id,List<googleGeoDistanceMatrixElementOneD>>();
        origins = fromiGeoLocate.GeoAddress__Latitude__s.toPlainString()+','+fromiGeoLocate.GeoAddress__Longitude__s.toPlainString();
        //With the limit in check, keep appending the to Geo's as a string and populate the N
        for (iGeoLocate__c toGeo : toiGeoLocates){
            if (toCounter < toLimit){
                if (destinations == '')
                    destinations = toGeo.GeoAddress__Latitude__s.toPlainString()+','+toGeo.GeoAddress__Longitude__s.toPlainString();
                else
                    destinations = destinations + '|' + toGeo.GeoAddress__Latitude__s.toPlainString()+','+toGeo.GeoAddress__Longitude__s.toPlainString();
                aMate = new googleGeoDistanceMatrixElementOneD(toGeo,(Double)toGeo.GeoAddress__Latitude__s,(Double)toGeo.GeoAddress__Longitude__s );
                dMates.add(aMate);
                toCounter++;
            }
        }
        //The 1:N is set
        odGroup.put(fromiGeoLocate.Id,dMates);
        System.debug('odGroup----->'+odGroup);
        //Connect to GDMatrix API
        googleDistanceMatrix gdMatrix = callGDMatrixAPI(origins,destinations);
        System.debug(gdMatrix);
        String WithInRangeOfZipCodeAD='';
        integer colCounter = 0;
        //Overlaying the parsed Google result onto the N list, paris set as Compatible vs inCompatible 
        for (googleGeoDistanceMatrixElementOneD ge : odGroup.get(fromiGeoLocate.Id)){
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
            colCounter++;
        }
        System.debug(odGroup);
        
        string paramType = '';
        if(ApexPages.currentPage()!=null)
            paramType = ApexPages.currentPage().getParameters().get('sType');
        
        System.debug('paramType------>'+paramType);            
        //diverting if it is validation utility. if already geoMatch exists, validate. else continue.  
        //In ReAssigning HF scenario also, geoMatch exits, hence do no go into this if paramType is reAssign.
        List<GeoMatch__c> existingGeoMatchList = [SELECT Id,serializedMatchMatrix__c,Duration_In_Mins__c,Is_In_Range_Of_ZipCode_AD__c,Assigned_AD__c,Assigned_AD_Status__c,toIgeoLocate__r.Contact__r.Id FROM GeoMatch__c WHERE FromiGeoLocate__c=:fromiGeoLocate.Id AND ToiGeoLocate__c=:toiGeoLocates[0].Id AND Match_Status__c='Geo Matched' LIMIT 1];
        if(existingGeoMatchList!=null && existingGeoMatchList.size()>0 && paramType!='reAssignHF'){
            existingGeoMatchList[0].serializedMatchMatrix__c = JSON.serialize(odGroup);     
            List<Zip_Code__c> zipList = new List<Zip_Code__c>();
            if(associatedZip!=null){
                zipList = [SELECT Id,Area__r.Area_Director__r.ContactId FROM Zip_Code__c WHERE Id=:associatedZip LIMIT 1];
                if(zipList!=null && zipList.size()>0){
                    //zipcode AD
                    if(zipList[0].Area__r.Area_Director__r.ContactId == existingGeoMatchList[0].toIgeoLocate__r.Contact__r.Id){
                        existingGeoMatchList[0].Assigned_AD__c = 'Zipcode AD';
                        //compatible
                        if(WithInRangeOfZipCodeAD=='Yes'){                      
                            existingGeoMatchList[0].Assigned_AD_Status__c = 'Approved'; 
                            existingGeoMatchList[0].Is_In_Range_Of_ZipCode_AD__c = 'Yes';                           
                        }
                        else{
                            existingGeoMatchList[0].Assigned_AD_Status__c = 'Needs Review';
                            existingGeoMatchList[0].Is_In_Range_Of_ZipCode_AD__c = 'No'; 
                        }
                    }
                    //other AD
                    else{
                        existingGeoMatchList[0].Assigned_AD__c = 'Other AD';
                        existingGeoMatchList[0].Is_In_Range_Of_ZipCode_AD__c = 'No';
                        //compatible
                        if(WithInRangeOfZipCodeAD=='Yes'){                      
                            existingGeoMatchList[0].Assigned_AD_Status__c = 'Approved';                                                         
                        }
                        else{
                            existingGeoMatchList[0].Assigned_AD_Status__c = 'Needs Review';                         
                        }
                        
                    }
                }
            }
            //new zip
            if(associatedZip==null || zipList.size()==0){
                existingGeoMatchList[0].Assigned_AD__c = 'Other AD';
                existingGeoMatchList[0].Is_In_Range_Of_ZipCode_AD__c = 'No';
                //compatible
                if(WithInRangeOfZipCodeAD=='Yes'){                      
                    existingGeoMatchList[0].Assigned_AD_Status__c = 'Approved';                                                         
                }
                else{
                    existingGeoMatchList[0].Assigned_AD_Status__c = 'Needs Review';                         
                }
            }
            
            if(!System.isBatch()){
                update existingGeoMatchList[0];
            }
            else{
                existingGeoMatchListMaster.add(existingGeoMatchList[0]);
                existingGeoMatchListMasterMap.put(existingGeoMatchList[0].Id, existingGeoMatchList[0]);
                system.debug('size--->'+existingGeoMatchListMaster.size());
            }
        }
        else{
            //Create a match , store the 1:N computed matrix as a serialized data        
            geoMatch__c serializedMatch = new geoMatch__c();
            serializedMatch.FromiGeoLocate__c = fromiGeoLocate.Id;
            serializedMatch.FromGeoAddress__Latitude__s = fromiGeoLocate.GeoAddress__Latitude__s;
            serializedMatch.FromGeoAddress__Longitude__s = fromiGeoLocate.GeoAddress__Longitude__s;
            serializedMatch.serializedMatchMatrix__c = JSON.serialize(odGroup);
            if (associatedZip != null){
                serializedMatch.Associated_Zip_Code__c = associatedZip;
            }
            googleGeoController.iAmAlreadyCalled = true; 
            //Dont insert as we might have to make further calls
            //insert serializedMatch;
            if (geoC == null){
                geoC = new googleGeoController();
            }
            //geoC.sObjectList = [select Id,ToiGeoLocate__c,ToiGeoLocate__r.Contact__r.Name from GeoMatch__c where Id = :serializedMatch.Id];
            List<GeoMatch__c> geoListToBeMatched = new List<GeoMatch__c>();
            geoListToBeMatched.add(serializedMatch);
            geoC.sObjectList = geoListToBeMatched;
            System.debug(geoListToBeMatched);
            //If its HF To AD computation, call match maker which will decide if we need further computation
            //if reassigning HF, skip this, insert a geomatch with no toGeo! and show compatible/incompatible page. on selection assign toGeo. set ownership
            //System.debug('sType------->'+ApexPages.currentPage().getParameters().get('sType'));
            
                
            if (fromiGeoLocate.contact__c == null && (paramType==null || paramType == '')){
                System.debug('entered auto matchmaking------->');
                geoC.autoMatchMakingBatch(alreadyAMassComputation);            
            }  
            else if(fromiGeoLocate.contact__c == null && paramType!=null && paramType=='reAssignHF'){
                //creating geomatch for reassigning HF.  this will redirect to compliant and non-compliant page. on selection. update toGeo of this geoMatch with selected
                System.debug('entered reMatch------->');
                serializedMatch.Match_Status__c = 'Geo ReMatch';
                insert serializedMatch;
            }
            //Need to write another recursive handling
            else{                
                serializedMatch.Assignment_Type__c = 'Temporary';            
                serializedMatch.Match_Status__c = 'Geo PreMatch';
                if(!System.isBatch()){
                    insert serializedMatch;
                }
                else{
                    serializedMatchMaster.add(serializedMatch);
                }
            }  
        }
        
    }
    
    
    //10*10 is the free api limit
    //m*n
    public static void computeDistance (set<Id> fromiGeoIds,set<Id> toiGeoIds){
        List<iGeoLocate__c> fromiGeoLocates = [select id,Applicant_Info__r.Name,Contact__r.Name,GeoAddress__Latitude__s,GeoAddress__Longitude__s from iGeoLocate__c where id in :fromiGeoIds];
        List<iGeoLocate__c> toiGeoLocates = [select id,Applicant_Info__r.Name,Contact__r.Name,GeoAddress__Latitude__s,GeoAddress__Longitude__s from iGeoLocate__c where id in :toiGeoIds];
        integer fromLimit = 10;
        integer fromCounter = 0;
        integer toLimit = 100;
        integer toCounter = 0;
        integer toDestStringCounter = 0;
        String origins = '';
        String destinations = '';
        Boolean hasLoadedDestinationString = false;
        googleGeoDistanceMatrixElement aPair;
        List<googleGeoDistanceMatrixElement> odpairs;
        List<List<googleGeoDistanceMatrixElement>> odmatrix = new List<List<googleGeoDistanceMatrixElement>>();
        for (iGeoLocate__c fromGeo : fromiGeoLocates){
            
            if (fromCounter < fromLimit){
                if (origins == '')
                    origins = fromGeo.GeoAddress__Latitude__s.toPlainString()+','+fromGeo.GeoAddress__Longitude__s.toPlainString();
                else
                    origins = origins + '|' + fromGeo.GeoAddress__Latitude__s.toPlainString()+','+fromGeo.GeoAddress__Longitude__s.toPlainString();
                fromCounter++;
            }
            odpairs = new List<googleGeoDistanceMatrixElement>();
            for (iGeoLocate__c toGeo : toiGeoLocates){
                if (fromCounter == 2)
                    hasLoadedDestinationString = true;
                if (toDestStringCounter < toLimit && fromCounter == 1 && !hasLoadedDestinationString){
                    if (destinations == '')
                        destinations = toGeo.GeoAddress__Latitude__s.toPlainString()+','+toGeo.GeoAddress__Longitude__s.toPlainString();
                    else
                        destinations = destinations + '|' + toGeo.GeoAddress__Latitude__s.toPlainString()+','+toGeo.GeoAddress__Longitude__s.toPlainString();
                    aPair = new googleGeoDistanceMatrixElement(fromGeo,toGeo,(Double)fromGeo.GeoAddress__Latitude__s,(Double)fromGeo.GeoAddress__Longitude__s,(Double)toGeo.GeoAddress__Latitude__s,(Double)toGeo.GeoAddress__Longitude__s );
                    odpairs.add(apair);
                    toDestStringCounter++;
                    //air
                }
                else if (toCounter < toLimit && hasLoadedDestinationString){
                    aPair = new googleGeoDistanceMatrixElement(fromGeo,toGeo,(Double)fromGeo.GeoAddress__Latitude__s,(Double)fromGeo.GeoAddress__Longitude__s,(Double)toGeo.GeoAddress__Latitude__s,(Double)toGeo.GeoAddress__Longitude__s );
                    odpairs.add(apair);
                    toCounter++;
                }
                System.debug('toDestStringCounter:'+toDestStringCounter);
            }
            odmatrix.add(odpairs);
            /*if (fromCounter == fromLimit && toCounter == toLimit){
                break;
            }*/
            if (fromCounter*toCounter > 100){
                break;
            }
        }
        System.debug(destinations);
        
        googleDistanceMatrix gdMatrix = callGDMatrixAPI(origins,destinations);
        System.debug(gdMatrix);
        
        integer rowCounter = 0;
        integer colCounter = 0;
        for (List<googleGeoDistanceMatrixElement> geList: odmatrix){
            //rowCounter = 0;
            colCounter = 0;
            for (googleGeoDistanceMatrixElement ge : geList){
                if (gdMatrix.rows[rowCounter].elements[colCounter].status == 'OK' ){
                    if (gdMatrix.rows[rowCounter].elements[colCounter].distance.value == null){
                        ge.markAsInCompatible();
                    }
                    else if(gdMatrix.rows[rowCounter].elements[colCounter].duration.value == null){
                        ge.markAsInCompatible();
                    }
                    else{
                        ge.distanceInKms = ((double)gdMatrix.rows[rowCounter].elements[colCounter].distance.value)/1000;
                        ge.durationInMins = ((double)gdMatrix.rows[rowCounter].elements[colCounter].duration.value)/60;
                        if (rowCounter+colCounter !=0 && ge.durationInMins > 60)
                            ge.markAsInCompatible();
                        else if (rowCounter+colCounter ==0 && ge.durationInMins > 60)
                            ge.makeFromSingle();
                        else
                            ge.markAsCompatible();
                    }
                }
                else{
                    ge.markAsInCompatible();
                }
                colCounter++;
            }
            rowCounter++;
        }
        System.debug(odmatrix);
        geoMatch__c serializedMatch = new geoMatch__c();
        if (fromiGeoLocates.size() == 1){
            serializedMatch.FromiGeoLocate__c = fromiGeoLocates[0].Id;
            serializedMatch.FromGeoAddress__Latitude__s = fromiGeoLocates[0].GeoAddress__Latitude__s;
            serializedMatch.FromGeoAddress__Longitude__s = fromiGeoLocates[0].GeoAddress__Longitude__s;
        }
        serializedMatch.serializedMatchMatrix__c = JSON.serialize(odmatrix);
        insert serializedMatch;
        
    }
    
    //The GDMatrix call abstracted out for m*n and 1*n functions above
    public static googleDistanceMatrix callGDMatrixAPI(String origins, String destinations){
    //Connect to GDMatrix API
        
        String googleAPIKey = Global_Constants__c.getInstance().Google_API_Key__c;
        String googleDistanceEndPoint = Global_Constants__c.getInstance().Google_Distance_Endpoint__c;
        
        Http h = new Http();
        HttpResponse res = new HttpResponse();
        HttpRequest req = new HttpRequest();
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        req.setHeader('Content-length', '0');
        req.setEndpoint(googleDistanceEndPoint+'?origins='+origins+'&destinations='+destinations+'&key='+googleAPIKey);
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
    
    public static Boolean createGoogleReadyAddressString(sObject anyObjectRecord){
        googleReadyAddressString = '';
        if (anyObjectRecord.getSObjectType() == iGeoLocate__c.sObjectType ){
           
            iGeoLocate__c geoLocate = (iGeoLocate__c)anyObjectRecord;
            
            if (geoLocate.Applicant_Info__r != null){
                if (geoLocate.Applicant_Info__r.Home_Street_1__c != null)
                    googleReadyAddressString = EncodingUtil.urlEncode(geoLocate.Applicant_Info__r.Home_Street_1__c,'UTF-8');
                if (geoLocate.Applicant_Info__r.Home_Street_2__c != null)
                    googleReadyAddressString = googleReadyAddressString+','+EncodingUtil.urlEncode(geoLocate.Applicant_Info__r.Home_Street_2__c,'UTF-8');
                if (geoLocate.Applicant_Info__r.Home_City__c != null)
                    googleReadyAddressString = googleReadyAddressString+','+EncodingUtil.urlEncode(geoLocate.Applicant_Info__r.Home_City__c,'UTF-8');
                if (geoLocate.Applicant_Info__r.Home_State__c != null)
                    googleReadyAddressString = googleReadyAddressString+','+EncodingUtil.urlEncode(geoLocate.Applicant_Info__r.Home_State__c,'UTF-8');
                if (geoLocate.Applicant_Info__r.Home_Country__c != null)
                    googleReadyAddressString = googleReadyAddressString+','+EncodingUtil.urlEncode(geoLocate.Applicant_Info__r.Home_Country__c,'UTF-8');
                if (geoLocate.Applicant_Info__r.Home_Postal_Code__c != null)
                    googleReadyAddressString = googleReadyAddressString+','+EncodingUtil.urlEncode(geoLocate.Applicant_Info__r.Home_Postal_Code__c,'UTF-8');
            }
            else if (geoLocate.Contact__r != null){
                if (geoLocate.Contact__r.MailingStreet != null)
                    googleReadyAddressString = EncodingUtil.urlEncode(geoLocate.Contact__r.MailingStreet,'UTF-8');
                if (geoLocate.Contact__r.MailingCity != null)
                    googleReadyAddressString = googleReadyAddressString+','+EncodingUtil.urlEncode(geoLocate.Contact__r.MailingCity,'UTF-8');
                if (geoLocate.Contact__r.MailingState != null)
                    googleReadyAddressString = googleReadyAddressString+','+EncodingUtil.urlEncode(geoLocate.Contact__r.MailingState,'UTF-8');
                if (geoLocate.Contact__r.MailingPostalCode != null)
                    googleReadyAddressString = googleReadyAddressString+','+EncodingUtil.urlEncode(geoLocate.Contact__r.MailingPostalCode,'UTF-8');
                if (geoLocate.Contact__r.MailingCountry != null)
                    googleReadyAddressString = googleReadyAddressString+','+EncodingUtil.urlEncode(geoLocate.Contact__r.MailingCountry,'UTF-8');
            }
            else if (geoLocate.Lead__r != null){
                if (geoLocate.Lead__r.Street != null)
                    googleReadyAddressString = EncodingUtil.urlEncode(geoLocate.Lead__r.Street,'UTF-8');
                if (geoLocate.Lead__r.City != null)
                    googleReadyAddressString = googleReadyAddressString+','+EncodingUtil.urlEncode(geoLocate.Lead__r.City,'UTF-8');
                if (geoLocate.Lead__r.State != null)
                    googleReadyAddressString = googleReadyAddressString+','+EncodingUtil.urlEncode(geoLocate.Lead__r.State,'UTF-8');
                if (geoLocate.Lead__r.PostalCode != null)
                    googleReadyAddressString = googleReadyAddressString+','+EncodingUtil.urlEncode(geoLocate.Lead__r.PostalCode,'UTF-8');
                if (geoLocate.Lead__r.Country != null)
                    googleReadyAddressString = googleReadyAddressString+','+EncodingUtil.urlEncode(geoLocate.Lead__r.Country,'UTF-8');
                /*if (geoLocate.Lead__r. != null)
                    googleReadyAddressString = EncodingUtil.urlEncode(geoLocate.Lead__r.,'UTF-8');*/
            }
            /*else if (geoLocate.Account__r != null){
                if (geoLocate.Account__r.BillingStreet != null)
                    googleReadyAddressString = googleReadyAddressString+','+EncodingUtil.urlEncode(geoLocate.Account__r.BillingStreet,'UTF-8');
                if (geoLocate.Account__r.BillingCity != null)
                    googleReadyAddressString = googleReadyAddressString+','+EncodingUtil.urlEncode(geoLocate.Account__r.BillingCity,'UTF-8');
                if (geoLocate.Account__r.BillingState != null)
                    googleReadyAddressString = googleReadyAddressString+','+EncodingUtil.urlEncode(geoLocate.Account__r.BillingState,'UTF-8');
                if (geoLocate.Account__r.BillingPostalCode != null)
                    googleReadyAddressString = googleReadyAddressString+','+EncodingUtil.urlEncode(geoLocate.Account__r.BillingPostalCode,'UTF-8');
                if (geoLocate.Account__r.BillingCountry != null)
                    googleReadyAddressString = googleReadyAddressString+','+EncodingUtil.urlEncode(geoLocate.Account__r.BillingCountry,'UTF-8');                
            }*/
            else if (geoLocate.Account__r != null){
                if (geoLocate.Account__r.PersonMailingStreet != null)
                    googleReadyAddressString = googleReadyAddressString+','+EncodingUtil.urlEncode(geoLocate.Account__r.PersonMailingStreet,'UTF-8');
                if (geoLocate.Account__r.PersonMailingCity != null)
                    googleReadyAddressString = googleReadyAddressString+','+EncodingUtil.urlEncode(geoLocate.Account__r.PersonMailingCity,'UTF-8');
                if (geoLocate.Account__r.PersonMailingState != null)
                    googleReadyAddressString = googleReadyAddressString+','+EncodingUtil.urlEncode(geoLocate.Account__r.PersonMailingState,'UTF-8');
                if (geoLocate.Account__r.PersonMailingPostalCode != null)
                    googleReadyAddressString = googleReadyAddressString+','+EncodingUtil.urlEncode(geoLocate.Account__r.PersonMailingPostalCode,'UTF-8');
                if (geoLocate.Account__r.PersonMailingCountry != null)
                    googleReadyAddressString = googleReadyAddressString+','+EncodingUtil.urlEncode(geoLocate.Account__r.PersonMailingCountry,'UTF-8');                
            }            
            else if (geoLocate.Zip_Code__r != null){
                googleReadyAddressString = EncodingUtil.urlEncode(geoLocate.Zip_Code__r.State__c,'UTF-8');
                googleReadyAddressString = googleReadyAddressString+','+EncodingUtil.urlEncode(geoLocate.Zip_Code__r.Zip_Code__c,'UTF-8');
                googleReadyAddressString = googleReadyAddressString+','+EncodingUtil.urlEncode('USA','UTF-8');
            }
            system.debug('googleReadyAddressString---->'+googleReadyAddressString);
            if (googleReadyAddressString != '')
                return true;
            else
                return false;
        }
        
        return false;
    }
    
    //Load the geoMatrix for m*n
    public void loadGeoMatrix(){
        geoMatch__c geoMatrix = [select serializedMatchMatrix__c from geoMatch__c where id = :ApexPages.currentPage().getParameters().get('Id')];
        distanceMatrix = (List<List<googleGeoDistanceMatrixElement>>)JSON.deserialize(geoMatrix.serializedMatchMatrix__c, List<List<googleGeoDistanceMatrixElement>>.class);
        
    }
    
    //Load the geoMatrix for 1*n
    public void loadGeoMatrix1xn(){
        compatiblePair = 0;
        incompatiblePair = 0;
        adAddresses = new Map<Id,Map<String,String>>();
        Map<String,String> addressMap;
        
        geoMatch__c geoMatrix = [select previous_zip_code__c, new_area__c, serializedMatchMatrix__c from geoMatch__c where id = :ApexPages.currentPage().getParameters().get('Id')];
        if (geoMatrix.previous_zip_code__c != null && geoMatrix.new_area__c != null){
            iGeoForZip = [select GeoAddress__Latitude__s,GeoAddress__Longitude__s from iGeoLocate__c where zip_code__c = :geoMatrix.previous_zip_code__c];
            zipCode = [select Zip_Code__c,Boundaries__c from Zip_Code__c where id = :geoMatrix.previous_zip_code__c];
        } 
        else{
            zipCode = new Zip_Code__c();
            iGeoForZip = new iGeoLocate__c();
        }
        odGroup = (Map<Id,List<googleGeoDistanceMatrixElementOneD>>)JSON.deserialize(geoMatrix.serializedMatchMatrix__c,Map<Id,List<googleGeoDistanceMatrixElementOneD>>.class);
        for (Id fromiGeoId : odGroup.KeySet()){
            fromGeo = [select i.id,i.Applicant_Info__c,i.contact__c,i.contact__r.Name,i.Applicant_Info__r.Name,i.Account__r.Name,i.Lead__r.Name,i.GeoAddress__Latitude__s,i.GeoAddress__Longitude__s,
                                            i.Applicant_Info__r.Home_Street_1__c,i.Applicant_Info__r.Home_Street_2__c,
                                            i.Applicant_Info__r.Home_City__c,i.Applicant_Info__r.Home_State__c,
                                            i.Applicant_Info__r.Home_Country__c,i.Applicant_Info__r.Home_Postal_Code__c,
                                            i.Contact__r.MailingStreet,i.Contact__r.MailingCity,i.Contact__r.MailingState,
                                            i.Contact__r.MailingCountry,i.Contact__r.MailingPostalCode,
                                            i.Lead__r.Street,i.Lead__r.City,i.Lead__r.State,i.Lead__r.PostalCode,i.Lead__r.Country,
                                            //i.Account__r.BillingStreet,i.Account__r.BillingCity,i.Account__r.BillingState,i.Account__r.BillingPostalCode,i.Account__r.BillingCountry, 
                                            i.Account__r.PersonMailingStreet,i.Account__r.PersonMailingCity,i.Account__r.PersonMailingState,i.Account__r.PersonMailingPostalCode,i.Account__r.PersonMailingCountry
                                            from iGeoLocate__c i where id = :fromiGeoId];
            for (googleGeoDistanceMatrixElementOneD gOneD : odGroup.get(fromiGeoId)){
                if (gOneD.pairingStatus == 'Compatible' || gOneD.pairingStatus == 'Compatible-Spawned'){
                    compatiblePair++;
                }
                else{
                    incompatiblePair++;
                }
                addressMap = new Map<String,String>();
                if (gOneD.toGeo.Contact__c != null){
                    staffContact = getStaffContactDetails(gOneD.toGeo.Contact__r.Id);
                    
                    String fullmailingstreet = staffContact.mailingStreet;
                    /*fullmailingstreet = fullmailingstreet.replace('\r\n', ' ');                    
                    fullmailingstreet = fullmailingstreet.replace('\n', ' ');
                    fullmailingstreet = fullmailingstreet.replace('\r', ' '); //replace new line or return with comma
                    fullmailingstreet = fullmailingstreet.replaceAll('\n', '\\\\n');
                    fullmailingstreet = fullmailingstreet.replace('<br/>', ' ');
                    fullmailingstreet = fullmailingstreet.replace('\'', ''); //remove quote
                    fullmailingstreet = fullmailingstreet.replace('"', ''); //remove double quote
                    */
                    //addressMap.put('mailingStreet',staffContact.mailingStreet);
                    addressMap.put('mailingStreet',fullmailingstreet);
                    addressMap.put('mailingCity',staffContact.mailingCity);
                    addressMap.put('mailingState',staffContact.mailingState);
                    addressMap.put('mailingPostalCode',staffContact.mailingPostalCode);
                    addressMap.put('mailingCountry',staffContact.mailingCountry);
                    adAddresses.put(gOneD.toGeo.Id,addressMap);
                }
                else{
                    HostFamilyAcc = getHostFamilyContactDetails(gOneD.toGeo.Account__r.Id);
                                        
                    String fullmailingstreet = HostFamilyAcc.PersonMailingStreet;
                    /*fullmailingstreet = fullmailingstreet.replace('\r\n', ' ');                    
                    fullmailingstreet = fullmailingstreet.replace('\n', ' '); 
                    fullmailingstreet = fullmailingstreet.replace('\r', ' '); //replace new line or return with comma
                    fullmailingstreet = fullmailingstreet.replaceAll('\n', '\\\\n');
                    fullmailingstreet = fullmailingstreet.replace('<br/>', ' ');
                    fullmailingstreet = fullmailingstreet.replace('\'', ''); //remove quote
                    fullmailingstreet = fullmailingstreet.replace('"', ''); //remove double quote
                    */
                    System.debug('HostFamilyAcc.PersonMailingStreet----->'+HostFamilyAcc.PersonMailingStreet);
                    System.debug('fullmailingstreet----->'+fullmailingstreet);
                    
                    //addressMap.put('mailingStreet',HostFamilyAcc.PersonMailingStreet);
                    addressMap.put('mailingStreet',fullmailingstreet);                    
                    addressMap.put('mailingCity',HostFamilyAcc.PersonMailingCity);
                    addressMap.put('mailingState',HostFamilyAcc.PersonMailingState);
                    addressMap.put('mailingPostalCode',HostFamilyAcc.PersonMailingPostalCode);
                    addressMap.put('mailingCountry',HostFamilyAcc.PersonMailingCountry);
                    
                    adAddresses.put(gOneD.toGeo.Id,addressMap);
                }
            }
            if (odGroup.get(fromiGeoId).size() ==  1)
                uniMatch = true;
        }
    }
    
    //Page level handling of GeoCoding and GeoDistance
    public PageReference handleGeoProcesses(){
        System.debug(iGeoLocate);
        if (applicantInfo != null){
            List<iGeoLocate__c> iGeoForApp = [select id from iGeoLocate__c where applicant_info__c = :applicantInfo.Id];
            if (iGeoForApp.size() == 0){
                iGeoLocate__c igeoForAppNew = new iGeoLocate__c();
                igeoForAppNew.Applicant_Info__c = applicantInfo.Id;
                insert igeoForAppNew;
                PageReference iGeoPage = new ApexPages.StandardController(igeoForAppNew).view();
                iGeoPage.setRedirect(true);
                return iGeoPage;
            }
            else{
                computeGoogleGeoCode((new Map<Id,SObject>(iGeoForApp)).keySet());
                PageReference iGeoPage = new ApexPages.StandardController(iGeoForApp[0]).view();
                iGeoPage.setRedirect(true);
                return iGeoPage;
            }
        }
        else if (staffContact != null) {
            List<iGeoLocate__c> iGeoForStaff = [select id from iGeoLocate__c where contact__c = :staffContact.Id];
            if (iGeoForStaff.size() == 0){
                iGeoLocate__c igeoForStaffNew = new iGeoLocate__c();
                igeoForStaffNew.Contact__c = staffContact.Id;
                insert igeoForStaffNew;
                PageReference iGeoPage = new ApexPages.StandardController(igeoForStaffNew).view();
                iGeoPage.setRedirect(true);
                return iGeoPage;
            }
            else{
                computeGoogleGeoCode((new Map<Id,SObject>(iGeoForStaff)).keySet());
                PageReference iGeoPage = new ApexPages.StandardController(iGeoForStaff[0]).view();
                iGeoPage.setRedirect(true);
                return iGeoPage;
            }
        }
        else if (HFLead != null) {
            List<iGeoLocate__c> iGeoForHFLead = [select id from iGeoLocate__c where lead__c = :HFLead.Id];
            if (iGeoForHFLead.size() == 0){
                iGeoLocate__c iGeoForHFLeadNew = new iGeoLocate__c();
                iGeoForHFLeadNew.Lead__c = HFLead.Id;
                insert iGeoForHFLeadNew;
                PageReference iGeoPage = new ApexPages.StandardController(iGeoForHFLeadNew).view();
                iGeoPage.setRedirect(true);
                return iGeoPage;
            }
            else{
                computeGoogleGeoCode((new Map<Id,SObject>(iGeoForHFLead)).keySet());
                PageReference iGeoPage = new ApexPages.StandardController(iGeoForHFLead[0]).view();
                iGeoPage.setRedirect(true);
                return iGeoPage;
            }
        }
        else if (HFAccount != null) {
            List<iGeoLocate__c> iGeoForHFAccount = [select id from iGeoLocate__c where  Account__c = :HFAccount.Id];
            if (iGeoForHFAccount.size() == 0){
                iGeoLocate__c iGeoForHFAccountNew = new iGeoLocate__c();
                iGeoForHFAccountNew.Account__c = HFAccount.Id;
                insert iGeoForHFAccountNew;
                PageReference iGeoPage = new ApexPages.StandardController(iGeoForHFAccountNew).view();
                iGeoPage.setRedirect(true);
                return iGeoPage;
            }
            else{
                computeGoogleGeoCode((new Map<Id,SObject>(iGeoForHFAccount)).keySet());
                PageReference iGeoPage = new ApexPages.StandardController(iGeoForHFAccount[0]).view();
                iGeoPage.setRedirect(true);
                return iGeoPage;
            }
        }
        else if (zipCode != null) {
            List<iGeoLocate__c> iGeoForZipCode = [select id from iGeoLocate__c where zip_code__c = :zipCode.Id];
            if (iGeoForZipCode.size() == 0){
                iGeoLocate__c iGeoForZipCodeNew = new iGeoLocate__c();
                iGeoForZipCodeNew.Zip_Code__c = zipCode.Id;
                insert iGeoForZipCodeNew;
                PageReference iGeoPage = new ApexPages.StandardController(iGeoForZipCodeNew).view();
                iGeoPage.setRedirect(true);
                return iGeoPage;
            }
            else{
                computeGoogleGeoCode((new Map<Id,SObject>(iGeoForZipCode)).keySet());
                PageReference iGeoPage = new ApexPages.StandardController(iGeoForZipCode[0]).view();
                iGeoPage.setRedirect(true);
                return iGeoPage;
            }
        }
        else if (iGeoLocate != null) {
            //ZipCode based assignment
            iGeoLocate = [select Applicant_Info__c,GeoAddress__Latitude__s,GeoAddress__Longitude__s,Contact__c,Lead__c,Account__c,Account__r.PersonMailingPostalCode,Account__r.PersonMailingState from iGeoLocate__c where id = :iGeoLocate.id];
            
            if (iGeoLocate.Applicant_Info__c != null || iGeoLocate.Lead__c != null ||iGeoLocate.Account__c != null ){
                //From - HF ; To - AD
                Double HFLat = iGeoLocate.GeoAddress__Latitude__s;
                Double HFLong = iGeoLocate.GeoAddress__Longitude__s;
                String zipCode = '';
                
                System.debug('LATITUDE---->'+HFLat);
                System.debug('LONGITUDE---->'+HFLong);
                //Commenting mass compute for zipcode based assignment
                //List<iGeoLocate__c> ADGeos = Database.Query('select Id from iGeoLocate__c where contact__c in (select Id from contact where Title = \'Area Director\') and GeoAddress__Latitude__s != null and GeoAddress__Longitude__s != null and DISTANCE(GeoAddress__c,GEOLOCATION('+HFLat+','+HFLong+'),\'mi\') < 100 limit 80');
   
                if (iGeoLocate.Account__r.PersonMailingPostalCode.contains('-'))
                    zipCode = iGeoLocate.Account__r.PersonMailingPostalCode.substring(0,iGeoLocate.Account__r.PersonMailingPostalCode.indexOfChar(45));
                else
                    zipCode = iGeoLocate.Account__r.PersonMailingPostalCode;    
                
                Zip_Code__c ADAssociatedWithZip = new Zip_Code__c();
                
                List<Zip_Code__c> ADAssociatedWithZipList = [select area__r.area_director__r.contactid from zip_Code__c where zip_code__c = :zipCode];
                //zip exists in the system
                if(ADAssociatedWithZipList!=null && ADAssociatedWithZipList.size()>0){
                    ADAssociatedWithZip = ADAssociatedWithZipList[0];
                    List<iGeoLocate__c> ADiGeoLocateList = [select id from iGeoLocate__c where contact__c = :ADAssociatedWithZip.area__r.area_director__r.contactid];
                    iGeoLocate__c ADiGeoLocate = new iGeoLocate__c();
                    if(ADiGeoLocateList!=null && ADiGeoLocateList.size()>0){
                        ADiGeoLocate = ADiGeoLocateList[0];
                    } 
                    Set<Id> toGeos = new Set<Id>();
                    
                    //Adding zipcode igeo instead of mass compute
                    toGeos.add(ADiGeoLocate.Id);
                    Set<Id> fromGeos = new Set<Id>();
                    fromGeos.add(iGeoLocate.Id);
                    //computeDistance(fromGeos,toGeos);
                    computeDistance1xn(iGeoLocate.Id,toGeos,ADAssociatedWithZip.Id,null,false);
                }
                //if no zip exists in the system. get all AD's from the same state as the USER
                else{
                    List<iGeoLocate__c> ADiGeoLocates = new List<iGeoLocate__c>();
                    if(iGeoLocate.Account__r.PersonMailingState!=null){
                                
                        Set<Id> setConId = new Set<Id>();
                        List<User> userList = [SELECT ContactId FROM User WHERE Profile.Name='APC AD PC'];
                        for(User u:userList){
                            setConId.add(u.ContactId);
                        }
                        
                        List<contact> conList = [select Id,Title,MailingState from contact where Id IN :setConId AND Title = 'Area Director' and MailingState = :iGeoLocate.Account__r.PersonMailingState];
                                                                        
                        Map<Id,sObject> mapCon = new Map<Id,sObject>(conList);
                        
                        ADiGeoLocates = [select id,Contact__c from iGeoLocate__c where contact__c!=null AND contact__c in :mapCon.keySet()];
                    }
                    //if there are AD's either from Zip or same State then compute
                    if (ADiGeoLocates.size() > 0){
                        //Already a mass 1:N computation
                        computeDistance_future(iGeoLocate.Id,new Map<Id,SObject>(ADiGeoLocates).keySet(),null,true);
                    }
                    else{
                        //do nothing?
                        geoMatch__c noMatch = new geoMatch__c();
                        noMatch.FromiGeoLocate__c = iGeoLocate.Id;
                        noMatch.FromGeoAddress__Latitude__s = iGeoLocate.GeoAddress__Latitude__s;
                        noMatch.FromGeoAddress__Longitude__s = iGeoLocate.GeoAddress__Longitude__s;
                        noMatch.Match_Status__c = 'Geo UnMatched';
                        googleGeoController.iAmAlreadyCalled = true;
                        insert noMatch;
                    }
                    
                }
            }
            else if (iGeoLocate.Contact__c != null){
                 //From - AD ; To - HF
                List<iGeoLocate__c> HFGeos = [select Id from iGeoLocate__c where Applicant_Info__c in (select Id from Applicant_Info__c where Type__c = 'Host Family' and Intrax_Program__c = 'AuPairCare') limit 80];
                Set<Id> toGeos = new Set<Id>();
                for (iGeoLocate__c i : HFGeos)
                    toGeos.add(i.Id);
                Set<Id> fromGeos = new Set<Id>();
                fromGeos.add(iGeoLocate.Id);
                //computeDistance(fromGeos,toGeos);
                computeDistance1xn(iGeoLocate.Id,toGeos,null,null,false);
            }
            
            PageReference iGeoPage = new ApexPages.StandardController(iGeoLocate).view();
            iGeoPage.setRedirect(true);
            return iGeoPage;
        }
        else if (geoMatch != null){
            geoMatch = [select Id,FromiGeoLocate__c,ToiGeoLocate__c from geoMatch__c where Id = :geoMatch.Id ];
            PageReference geoMatchPage = new ApexPages.StandardController(geoMatch).view(); 
            if (geoMatch.FromiGeoLocate__c != null && geoMatch.ToiGeoLocate__c != null){
                geoMatch.Match_Status__c = 'Geo Matched';
                geoMatch.Approved_By__c = UserInfo.getUserId();
                geoMatch.Approved_Date__c = System.now();
                update geoMatch;
                geoMatchPage.setRedirect(true);
            }
            else{
                geoMatchPage.setRedirect(true);
                ApexPages.Message errorInMatch = new ApexPages.Message(ApexPages.Severity.ERROR, 'Need a pair to approve match!');
                apexpages.addmessage(errorInMatch);
            }
            
            return geoMatchPage;
        }
        else
            return null;
    }
    
    //Batch handling of GeoCoding and GeoDistance
    public void handleGeoProcessesForBatch(){
        googleGeoController.iAmAlreadyCalled = true;        
        //Get the bulk load as a generic object list
        if (sObjectList != null){
            iGeoListForBatchGeoCode = new List<iGeoLocate__c>();
            iGeoListForBatchGeoDistance = new List<iGeoLocate__c>();
            List<iGeoLocate__c> iGeoListForBatchUndecided = new List<iGeoLocate__c>();
            List<iGeoLocate__c> iGeoListIgnored = new List<iGeoLocate__c>();
            //Some data containers 
            List<Applicant_Info__c> applicationsWithoutGeoLocate = new List<Applicant_Info__c>();
            List<Contact> contactsWithoutGeoLocate = new List<Contact>();
            List<Lead> leadsWithoutGeoLocate = new List<Lead>();
            List<Account> accountsWithoutGeoLocate = new List<Account>();
            List<Zip_Code__c> zipsWithoutGeoLocate = new List<Zip_Code__c>();
            List<iGeoLocate__c> geoLocatesToBeGeoCoded = new List<iGeoLocate__c>();
            List<iGeoLocate__c> geoLocatesToBeGeoMatched = new List<iGeoLocate__c>(); 
            List<iGeoLocate__c> geoLocatesIgnored = new List<iGeoLocate__c>(); 
            
            //Determine what type of load it is and create the iGeos
            if (sObjectList.size() != 0 && sObjectList.getSObjectType() == Applicant_Info__c.sObjectType){
                appInfoList = (List<Applicant_Info__c>)sObjectList;
                //Sort the basket into ones without geolocate and ones to be geoCoded
                applicationsWithoutGeoLocate = [select Id from Applicant_Info__c where id not in (select Applicant_Info__c from iGeoLocate__c where Applicant_Info__c in  :appInfoList) and id in :appInfoList];
                geoLocatesToBeGeoCoded =  [select Applicant_Info__c from iGeoLocate__c where Applicant_Info__c in  :appInfoList and GeoAddress__Latitude__s = null and GeoAddress__Longitude__s = null];
                iGeoLocate__c igeoForAppNew;
                // for the ones without iGeoLocate create one first
                for (Applicant_Info__c appInfo : applicationsWithoutGeoLocate){
                    igeoForAppNew = new iGeoLocate__c();
                    igeoForAppNew.Applicant_Info__c = appInfo.Id;
                    iGeoListForBatchGeoCode.add(igeoForAppNew);
                }
                //Bulk insert
                insert iGeoListForBatchGeoCode;
                //Once the empty geoLocate is created,  call for GeoCode
                if (geoLocatesToBeGeoCoded.size() > 0)
                    iGeoListForBatchGeoCode.addAll(geoLocatesToBeGeoCoded);
            }
            if (sObjectList.size() != 0 && sObjectList.getSObjectType() == Contact.sObjectType){
                contactList = (List<Contact>)sObjectList;
                //Sort the basket into ones without geolocate and ones to be geoCoded
                contactsWithoutGeoLocate = [select Id from Contact where id not in (select Contact__c from iGeoLocate__c where Contact__c in  :contactList) and id in :contactList];
                geoLocatesToBeGeoCoded =  [select Contact__c from iGeoLocate__c where contact__c in  :contactList and GeoAddress__Latitude__s = null and GeoAddress__Longitude__s = null];
                iGeoLocate__c igeoForContactNew;
                for (Contact contact : contactsWithoutGeoLocate){
                    igeoForContactNew = new iGeoLocate__c();
                    igeoForContactNew.contact__c = contact.Id;
                    iGeoListForBatchGeoCode.add(igeoForContactNew);
                }
                insert iGeoListForBatchGeoCode;
                //Once the empty geoLocate is created,  call for GeoCode
                if (geoLocatesToBeGeoCoded.size() > 0)
                    iGeoListForBatchGeoCode.addAll(geoLocatesToBeGeoCoded);
            }
            //Logic For Lead
            if (sObjectList.size() != 0 && sObjectList.getSObjectType() == Lead.sObjectType){
                leadList = (List<Lead>)sObjectList;
                //if global constants is checked. do geocomputation.
                if(Global_Constants__c.getInstance().Geo_Code_Lead__c){
                    //Sort the basket into ones without geolocate and ones to be geoCoded
                    leadsWithoutGeoLocate = [select Id from Lead where id not in (select Lead__c from iGeoLocate__c where Lead__c in  :leadList) and id in :leadList];
                    geoLocatesToBeGeoCoded =  [select Lead__c from iGeoLocate__c where lead__c in  :leadList and GeoAddress__Latitude__s = null and GeoAddress__Longitude__s = null];
                    iGeoLocate__c igeoForLeadNew;
                    for (Lead leadrec : leadsWithoutGeoLocate){
                        igeoForLeadNew = new iGeoLocate__c();
                        igeoForLeadNew.lead__c = leadrec.Id;
                        iGeoListForBatchGeoCode.add(igeoForLeadNew);
                    }
                    insert iGeoListForBatchGeoCode;
                    //Once the empty geoLocate is created,  call for GeoCode
                    if (geoLocatesToBeGeoCoded.size() > 0)
                        iGeoListForBatchGeoCode.addAll(geoLocatesToBeGeoCoded);
                }
                //global constants in unchecked. do zipcode verification only
                else{
                    System.debug('entered geo controller from lead trigger custom settings unchecked--->');
                    if(leadList!=null && leadList.size()>0){
                        Map<String,Id> mapZipAD = new Map<String,Id>();
                        Map<String,String> mapZipADProf = new Map<String,String>();
                        List<Zip_Code__c> AllZipsWithAD = [SELECT Id,Zip_Code__c,Area__r.Area_Director__r.Id,Area__r.Area_Director__r.Profile.Name FROM Zip_Code__c];
                        if(AllZipsWithAD!=null && AllZipsWithAD.size()>0){
                            for(Zip_Code__c zip:AllZipsWithAD){
                                mapZipAD.put(zip.Zip_Code__c, zip.Area__r.Area_Director__r.Id);
                                mapZipADProf.put(zip.Zip_Code__c, zip.Area__r.Area_Director__r.Profile.Name);
                            }
                        }
                        
                        for(Lead l:leadList){
                            system.debug('lead postalcode---->'+l.PostalCode);
                            system.debug('lead owner before---->'+l.ownerId);
                            
                            String lZipCode;
                            //Remove hyphen extensions
                            if(l.PostalCode!=null && l.PostalCode.contains('-')){
                                lZipCode = l.PostalCode.substring(0,l.PostalCode.indexOfChar(45));   
                            }
                            else{
                                lZipCode = l.PostalCode;
                            }
                            
                            Id AreaDirectorId = mapZipAD.get(lZipCode);
                            if(AreaDirectorId!=null){
                                if(mapZipADProf.get(lZipCode) == 'APC AD PC'){
                                    l.OwnerId = AreaDirectorId;
                                    //IMPORTANT: DO NOT CHANGE THE TEXT BELOW. THIS IS USED IN LEAD ASSIGNMENT RULES
                                    l.Sys_Admin_Tag__c = 'Assign To AD';
                                }
                                system.debug('AreaDirectorId---->'+AreaDirectorId);
                            }
                            system.debug('lead owner after---->'+l.ownerId);
                            
                        }
                        try{
                            //update not required. Calling this from Before Insert Trigger
                            //update leadList;
                        }
                        catch(exception e){
                            system.debug('ERROR UPDATING LEAD OWNER--->'+e);
                        }
                    }
                }
            }
            //Logic for Account
            if (sObjectList.size() != 0 && sObjectList.getSObjectType() == Account.sObjectType){
                accountList = (List<Account>)sObjectList;
                System.debug('Incoming Accounts:'+accountList);
                //Sort the basket into ones without geolocate and ones to be geoCoded
                accountsWithoutGeoLocate = [select Id from Account where id not in (select Account__c from iGeoLocate__c where Account__c in  :accountList) and id in :accountList];
                geoLocatesToBeGeoCoded =  [select Account__c from iGeoLocate__c where Account__c in  :accountList and GeoAddress__Latitude__s = null and GeoAddress__Longitude__s = null];
                iGeoLocate__c igeoForAccountNew;
                //List<iGeoLocate__c> newiGeoList = new List<iGeoLocate__c>();
                for (Account accountRec : accountsWithoutGeoLocate){                    
                    igeoForAccountNew = new iGeoLocate__c();
                    igeoForAccountNew.account__c = accountRec.Id;
                    iGeoListForBatchGeoCode.add(igeoForAccountNew);
                    //newiGeoList.add(igeoForAccountNew);
                }
                insert iGeoListForBatchGeoCode;
                //insert newiGeoList;
                //Once the empty geoLocate is created,  call for GeoCode
                if(!System.isBatch()){
                    if (geoLocatesToBeGeoCoded.size() > 0)
                        iGeoListForBatchGeoCode.addAll(geoLocatesToBeGeoCoded);
                }
            }
            //Logic for ZipCode
            if (sObjectList.size() != 0 && sObjectList.getSObjectType() == Zip_Code__c.sObjectType){
                zipList = (List<Zip_Code__c>)sObjectList;
                System.debug('Incoming ZipCodes:'+zipList);
                List<iGeoLocate__c> iGeoForZipToBeCreated = new List<iGeoLocate__c>();
                //Sort the basket into ones without geolocate and ones to be geoCoded
                zipsWithoutGeoLocate = [select Id from Zip_Code__c where id not in (select Zip_Code__c from iGeoLocate__c where Zip_Code__c in  :zipList) and id in :zipList];
                geoLocatesToBeGeoCoded =  [select Zip_Code__c from iGeoLocate__c where Zip_Code__c in  :zipList and GeoAddress__Latitude__s = null and GeoAddress__Longitude__s = null];
                iGeoLocate__c igeoForZipNew;
                for (Zip_Code__c zipRec : zipsWithoutGeoLocate){
                    igeoForZipNew = new iGeoLocate__c();
                    igeoForZipNew.zip_code__c = zipRec.Id;
                    iGeoForZipToBeCreated.add(igeoForZipNew);
                }
                insert iGeoForZipToBeCreated;
                //Once the empty geoLocate is created,  call for GeoCode
                if (geoLocatesToBeGeoCoded.size() > 0)
                    iGeoListForBatchGeoCode.addAll(geoLocatesToBeGeoCoded);
            }
            if (sObjectList.size() != 0 && sObjectList.getSObjectType() == iGeoLocate__c.sObjectType){
                //GeoCoding or GeoMapping
                iGeoListForBatchUndecided = (List<iGeoLocate__c>)sObjectList;
                iGeoListForBatchUndecided = [select Account__c,Account__r.PersonMailingPostalCode,Account__r.PersonMailingState,GeoAddress__Longitude__s,GeoAddress__Latitude__s from iGeoLocate__c where Id in :iGeoListForBatchUndecided ];
                
                System.debug(iGeoListForBatchUndecided);
                Set<Id> geoLocatesInAMatch = new Set<Id>();
                //If a host family is already in a geo-Relationship, ignore
                List<GeoMatch__c> geoMatches = [select Id,FromiGeoLocate__c, ToiGeoLocate__c from GeoMatch__c where FromiGeoLocate__c in :iGeoListForBatchUndecided or ToiGeoLocate__c = :iGeoListForBatchUndecided];
                for (GeoMatch__c geoMatch : geoMatches){
                    if(geoMatch.FromiGeoLocate__c != null)
                        geoLocatesInAMatch.add(geoMatch.FromiGeoLocate__c);
                    /*if(geoMatch.ToiGeoLocate__c != null)
                        geoLocatesInAMatch.add(geoMatch.ToiGeoLocate__c);*/
                }
                for (iGeoLocate__c iGeo : iGeoListForBatchUndecided){
                    if (iGeo.GeoAddress__Longitude__s == null && iGeo.GeoAddress__Latitude__s == null){
                        iGeoListForBatchGeoCode.add(iGeo);                        
                    }
                    else{
                        if (!geoLocatesInAMatch.contains(iGeo.Id))
                            iGeoListForBatchGeoDistance.add(iGeo);
                        else
                            iGeoListIgnored.add(iGeo);
                    }
                        
                }
                
                
            }
            
            System.debug('***geoMatch sObjectList check--->'+sObjectList.getSObjectType());
            if (sObjectList.size() != 0 && sObjectList.getSObjectType() == GeoMatch__c.sObjectType){
                //System.debug('***geoMatch check--->');
                //System.debug('***geoMatch changeOwnerCalled check--->'+changeOwnerCalled);
                //System.debug('***geoMatch iAmAlreadyCalled check--->'+iAmAlreadyCalled);
                //if(!changeOwnerCalled){
                //  System.debug('***geoMatch changeOwnerCalled check--->'+changeOwnerCalled);
                    //if(!iAmAlreadyCalled){
                //      System.debug('***geoMatch iAmAlreadyCalled check--->'+iAmAlreadyCalled);
                        autoMatchMakingBatch(false); 
                    //}  
                    //else{             
                //      System.debug('***geoMatch iAmAlreadyCalled Else check--->'+iAmAlreadyCalled);
                        //changeOwnerForGeoMatchedApplications(sObjectList);
                    //}
                //}
            }
            //Some debugs
            System.debug('***Some debugs***');
            System.debug('Incoming List Size: '+sObjectList.size());
            System.debug('Applications without GeoLocate: '+applicationsWithoutGeoLocate.size());
            System.debug('Contacts without GeoLocate: '+contactsWithoutGeoLocate.size());
            System.debug('Leads without GeoLocate: '+leadsWithoutGeoLocate.size());
            System.debug('Accounts without GeoLocate: '+accountsWithoutGeoLocate.size());
            System.debug('GeoLocates to be GeoCoded: '+geoLocatesToBeGeoCoded.size());
            System.debug('GeoLocates to be GeoMatched: '+geoLocatesToBeGeoMatched.size());
            System.debug('iGeoListForBatchGeoCode: '+iGeoListForBatchGeoCode.size());
            System.debug('iGeoListForBatchGeoDistance: '+iGeoListForBatchGeoDistance.size());
            System.debug('iGeoListIgnored: '+iGeoListIgnored.size());
            
            
            System.debug('***Some debugs***');
            //If there are iGeos to be geoCoded 
            //if (iGeoListForBatchGeoCode.size() > 0 && sObjectList.getSObjectType() == iGeoLocate__c.sObjectType){
            if (iGeoListForBatchGeoCode.size() > 0){
                if (System.isBatch() || isTestMode){
                    computeGoogleGeoCode((new Map<Id,SObject>(iGeoListForBatchGeoCode)).keySet());
                }
                else{
                    computeGoogleGeoCode_future((new Map<Id,SObject>(iGeoListForBatchGeoCode)).keySet());
                }
            }
            else if (iGeoListForBatchGeoDistance.size() > 0){
                //List<iGeoLocate__c> ADGeos = [select Id from iGeoLocate__c where contact__c in (select Id from contact where Title = 'Area Director') and GeoAddress__Latitude__s != null and GeoAddress__Longitude__s != null limit 80];
                
                                
                if (System.isBatch() || isTestMode){
                    Set<Id> setConId = new Set<Id>();
                    List<User> userList = [SELECT ContactId FROM User WHERE Profile.Name='APC AD PC'];
                    for(User u:userList){
                        setConId.add(u.ContactId);
                    }
                    List<GeoMatch__c> noMatchRecs = new List<GeoMatch__c>();
                    //computeGoogleGeoCode((new Map<Id,SObject>(iGeoListForBatchGeoDistance)).keySet());
                    for (iGeoLocate__c toBeMatched : iGeoListForBatchGeoDistance){
                        system.debug('entered here');
                        List<Zip_Code__c> ADAssociatedWithZipList = new List<Zip_Code__c>();
                        
                        String zipCode;
                        //Remove hyphen extensions
                        if (toBeMatched.Account__r.PersonMailingPostalCode.contains('-')){
                            zipCode = toBeMatched.Account__r.PersonMailingPostalCode.substring(0,toBeMatched.Account__r.PersonMailingPostalCode.indexOfChar(45));   
                        }
                        else{
                            zipCode = toBeMatched.Account__r.PersonMailingPostalCode;
                        }
                        
                        ADAssociatedWithZipList = [select area__r.area_director__r.contactid from zip_Code__c where zip_code__c = :zipCode];
                        //zip exists in the system
                        if(ADAssociatedWithZipList!=null && ADAssociatedWithZipList.size()>0){
                            List<iGeoLocate__c> iGeoLs = new List<iGeoLocate__c>();
                            iGeoLocate__c ADiGeoLocate = new iGeoLocate__c();
                            
                            iGeoLs = [select id,GeoAddress__latitude__s from iGeoLocate__c where contact__c!= null and contact__c = :ADAssociatedWithZipList[0].area__r.area_director__r.contactid];
                            if(iGeoLs!=null && iGeoLs.size()>0){
                                ADiGeoLocate = iGeoLs[0];
                            }
                            Set<Id> toGeos = new Set<Id>();
                            if(ADiGeoLocate!=null && ADiGeoLocate.Id!=null && ADiGeoLocate.GeoAddress__latitude__s!=null){
                                toGeos.add(ADiGeoLocate.Id);
                                //computeDistance1xn(toBeMatched.Id,(new Map<Id,SObject>(ADGeos)).keySet());
                                computeDistance1xn(toBeMatched.Id,toGeos,ADAssociatedWithZipList[0].Id,null,false);
                            }
                        }
                        //new zip
                        else{
                            List<iGeoLocate__c> ADiGeoLocates = new List<iGeoLocate__c>();
                            System.debug('state-->'+toBeMatched.Account__r.PersonMailingState);
                            if(toBeMatched.Account__r.PersonMailingState!=null){                                                                
                                
                                List<contact> conList = [select Id,Title,MailingState from contact where Id IN :setConId AND Title = 'Area Director' and MailingState = :toBeMatched.Account__r.PersonMailingState];
    
                                Map<Id,sObject> mapCon = new Map<Id,sObject>(conList);
                                
                                ADiGeoLocates = [select id,Contact__c from iGeoLocate__c where contact__c!=null AND contact__c in :mapCon.keySet()];
                            }
                            //if there are AD's either from Zip or same State then compute
                            if (ADiGeoLocates.size() > 0){
                                //Already a mass 1:N computation
                                if(!System.isBatch()){
                                    computeDistance_future(toBeMatched.Id,new Map<Id,SObject>(ADiGeoLocates).keySet(),null,true);
                                }
                                else{
                                    computeDistance1xn(toBeMatched.Id,new Map<Id,SObject>(ADiGeoLocates).keySet(),null,null,true);
                                }
                            }
                            else{
                                //do nothing?
                                
                                geoMatch__c noMatch = new geoMatch__c();
                                noMatch.FromiGeoLocate__c = toBeMatched.Id;
                                noMatch.FromGeoAddress__Latitude__s = toBeMatched.GeoAddress__Latitude__s;
                                noMatch.FromGeoAddress__Longitude__s = toBeMatched.GeoAddress__Longitude__s;
                                noMatch.Match_Status__c = 'Geo UnMatched';
                                googleGeoController.iAmAlreadyCalled = true;
                                noMatchRecs.add(noMatch);
                            }
                            
                        }
                    }
                    if (noMatchRecs.size() > 0)
                        insert noMatchRecs;
                    
                    //for batch. inserting after looping through all       
                    System.debug('geoMatchesHistoryMaster----->'+geoMatchesHistoryMaster.size());
                    System.debug('geoMatchesProcessedMaster----->'+geoMatchesProcessedMaster.size());
                    System.debug('geoMatchesProcessedMaster----->'+geoMatchesProcessedMaster);
                    /* //moving to geoAssignmentValidationController
                    if(system.isBatch()){
                        if(geoMatchesHistoryMaster!=null && geoMatchesHistoryMaster.size()>0)
                            insert geoMatchesHistoryMaster;
                        if(geoMatchesProcessedMaster!=null && geoMatchesProcessedMaster.size()>0)
                            insert geoMatchesProcessedMaster;
                    }
                    */
                    
                }
                else{
                    //Prepare for GeoDistance Computation
                    System.debug(iGeoListForBatchGeoDistance);
                    //Get All Associated HF Account records
                    Set<Id> accIds = new Set<Id>();
                    for (iGeoLocate__c toBeMatched : iGeoListForBatchGeoDistance){
                        accIds.add(toBeMatched.Account__c);
                    }
                    //Inflate the HF Accounts with details
                    Map<Id,Account> accDetails = new Map<Id,Account>([select PersonMailingPostalCode from Account where id IN :accIDs]);
                    //Holding List container for records without matches?
                    List<GeoMatch__c> noMatchRecs = new List<GeoMatch__c>();
                    //For each iGeo to be geoMatched
                    for (iGeoLocate__c toBeMatched : iGeoListForBatchGeoDistance){
                        //Check if ZIP CODE is present in the system
                        String zipCode;
                        //Remove hyphen extensions
                        if (accDetails.get(toBeMatched.Account__c).PersonMailingPostalCode.contains('-')){
                            zipCode = accDetails.get(toBeMatched.Account__c).PersonMailingPostalCode.substring(0,accDetails.get(toBeMatched.Account__c).PersonMailingPostalCode.indexOfChar(45));   
                        }
                        else{
                            zipCode = accDetails.get(toBeMatched.Account__c).PersonMailingPostalCode;
                        }
                        
                        List<Zip_Code__c> ADAssociatedWithZip = new List<Zip_Code__c>();
                        System.debug('zipCode-->'+zipCode);
                        //Get the AD associated with the ZipCode
                        if(zipCode!=null){
                            ADAssociatedWithZip = [select Id,area__r.area_director__r.contactid from zip_Code__c where zip_code__c = :zipCode];
                        }
                        //If there is an AD (most likely)
                        if (ADAssociatedWithZip.size() > 0){
                            iGeoLocate__c ADiGeoLocate = new iGeoLocate__c();
                            List<iGeoLocate__c> geoLs = new List<iGeoLocate__c>();
                            //Get that AD's iGeo
                            geoLs = [select id,GeoAddress__latitude__s from iGeoLocate__c where contact__c = :ADAssociatedWithZip[0].area__r.area_director__r.contactid];
                            
                            if(geoLs!=null && geoLs.size()>0){
                                ADiGeoLocate = geoLs[0];
                            }
                            Set<Id> toGeos = new Set<Id>();
                            if(ADiGeoLocate!=null && ADiGeoLocate.Id!=null && ADiGeoLocate.GeoAddress__latitude__s!=null){
                                toGeos.add(ADiGeoLocate.Id);
                                //Not a mass computation yet
                                computeDistance_future(toBeMatched.Id,toGeos,ADAssociatedWithZip[0].Id,false);
                            }
                        }
                        //if not, get all AD's from the same state as the USER
                        else{
                            List<iGeoLocate__c> ADiGeoLocates = new List<iGeoLocate__c>();
                            System.debug('state-->'+toBeMatched.Account__r.PersonMailingState);
                            if(toBeMatched.Account__r.PersonMailingState!=null){
                                
                                Set<Id> setConId = new Set<Id>();
                                List<User> userList = [SELECT ContactId FROM User WHERE Profile.Name='APC AD PC'];
                                for(User u:userList){
                                    setConId.add(u.ContactId);
                                }
                                
                                List<contact> conList = [select Id,Title,MailingState from contact where Id IN :setConId AND Title = 'Area Director' and MailingState = :toBeMatched.Account__r.PersonMailingState];
                                
                                
                                
                                Map<Id,sObject> mapCon = new Map<Id,sObject>(conList);
                                
                                ADiGeoLocates = [select id,Contact__c from iGeoLocate__c where contact__c!=null AND contact__c in :mapCon.keySet()];
                            }
                            //if there are AD's either from Zip or same State then compute
                            if (ADiGeoLocates.size() > 0){
                                //Already a mass 1:N computation
                                computeDistance_future(toBeMatched.Id,new Map<Id,SObject>(ADiGeoLocates).keySet(),null,true);
                            }
                            else{
                                //do nothing?
                                geoMatch__c noMatch = new geoMatch__c();
                                noMatch.FromiGeoLocate__c = toBeMatched.Id;
                                noMatch.FromGeoAddress__Latitude__s = toBeMatched.GeoAddress__Latitude__s;
                                noMatch.FromGeoAddress__Longitude__s = toBeMatched.GeoAddress__Longitude__s;
                                noMatch.Match_Status__c = 'Geo UnMatched';
                                googleGeoController.iAmAlreadyCalled = true;
                                noMatchRecs.add(noMatch);
                            }
                        }
                        //computeDistance_future(toBeMatched.Id,(new Map<Id,SObject>(ADGeos)).keySet());
                    }
                    if (noMatchRecs.size() > 0)
                        insert noMatchRecs;
                    
                    //computeGoogleGeoCode_future((new Map<Id,SObject>(iGeoListForBatchGeoDistance)).keySet());
                }
            }
        }
    }
    
    /*public Boolean isAlreadyAMassComputation(String zipCode){
        List<Zip_Code__c> ADAssociatedWithZip = [select area__r.area_director__r.contactid from zip_Code__c where zip_code__c = :zipCode];
        if (ADAssociatedWithZip.size() > 0){
            return false;
        }
        else{
            return true;
        }
    }*/
   
    public PageReference reAssignHF(){
        //do 1xn and then redirect user to the same visualization page but with computed distances for all ADs
        
        String iGeoMatchId = ApexPages.currentPage().getParameters().get('Id');
        //uniMatch = false;
                 
        List<GeoMatch__c> fromGeoIdOfMatch = [SELECT Id,FromiGeoLocate__c FROM GeoMatch__c WHERE Id=:iGeoMatchId];
        iGeoLocate__c iGeoLocate = [select Applicant_Info__c,GeoAddress__Latitude__s,GeoAddress__Longitude__s,Contact__c,Lead__c,Account__c,Account__r.PersonMailingPostalCode,Account__r.PersonMailingState from iGeoLocate__c where id = :fromGeoIdOfMatch[0].FromiGeoLocate__c];
        
        string zipcode;
        if (iGeoLocate.Account__r.PersonMailingPostalCode.contains('-'))
            zipCode = iGeoLocate.Account__r.PersonMailingPostalCode.substring(0,iGeoLocate.Account__r.PersonMailingPostalCode.indexOfChar(45));
        else
            zipCode = iGeoLocate.Account__r.PersonMailingPostalCode; 
        
        Zip_Code__c ADAssociatedWithZip = new Zip_Code__c();
        List<Zip_Code__c> ADAssociatedWithZipList = [select area__r.area_director__r.contactid from zip_Code__c where zip_code__c = :zipCode];
        
        if(ADAssociatedWithZipList!=null && ADAssociatedWithZipList.size()>0){
            ADAssociatedWithZip = ADAssociatedWithZipList[0];
                
            List<User> RMList = [Select ContactId from User WHERE Id=:userInfo.getUserId()];
            
            //get other ADs in the same state and compute to get the distances
            List<iGeoLocate__c> ADiGeoLocates = [select id from iGeoLocate__c where contact__c in (select Id from contact where MailingState = :iGeoLocate.Account__r.PersonMailingState AND ReportsToId=:RMList[0].ContactId )];
            //computeDistance1xn (Id fromGeoId,set<Id> toiGeoIds,Id associatedZip,googleGeoController geoC,Boolean alreadyAMassComputation)asdads
            computeDistance1xn(fromGeoIdOfMatch[0].FromiGeoLocate__c,new Map<Id,SObject>(ADiGeoLocates).keySet(),ADAssociatedWithZip.Id,null,true);
        }
        //just in case if zip doesn't exist in the system, still compute again.
        else{
            List<User> RMList = [Select ContactId from User WHERE Id=:userInfo.getUserId()];
            List<iGeoLocate__c> ADiGeoLocates = [select id from iGeoLocate__c where contact__c in (select Id from contact where MailingState = :iGeoLocate.Account__r.PersonMailingState AND ReportsToId=:RMList[0].ContactId )];
            computeDistance1xn(fromGeoIdOfMatch[0].FromiGeoLocate__c,new Map<Id,SObject>(ADiGeoLocates).keySet(),null,null,true);
        }
        
        List<GeoMatch__c> geoReMatchId = [SELECT Id,FromiGeoLocate__c FROM GeoMatch__c WHERE FromiGeoLocate__c=:fromGeoIdOfMatch[0].FromiGeoLocate__c AND Match_Status__c='Geo ReMatch' LIMIT 1];
        
        PageReference p = new PageReference('/apex/geoReAssignConfirmation?id='+geoReMatchId[0].Id+'&sType=reAssignHF'+'&OriginalGeoMatchId='+iGeoMatchId);
        p.setRedirect(true);
        return p; 
    }
    
    //Match making
    public PageReference associateAdWithHF(){
        if (matchedToGeoLocateId != null){
            geoMatch.ToiGeoLocate__c = matchedToGeoLocateId;
            iGeoLocate__c matchedToGeoLocate = [select GeoAddress__Latitude__s,GeoAddress__Longitude__s from iGeoLocate__c where Id = :matchedToGeoLocateId];
            geoMatch.ToGeoAddress__Latitude__s = matchedToGeoLocate.GeoAddress__Latitude__s;
            geoMatch.ToGeoAddress__Longitude__s = matchedToGeoLocate.GeoAddress__Longitude__s;            
            geoMatch.Match_Status__c = 'Geo Matched';
            geoMatch.Assignment_Type__c = 'Permanent';
            geoMatch.Assigned_AD__c = 'Zipcode AD';
            geoMatch.Assigned_AD_Status__c = 'Approved';
            geoMatch.Is_In_Range_Of_ZipCode_AD__c = 'Yes';
            geoMatch.Is_Imported_From_Casper__c = false;
        }
        update geoMatch;
        
        List<GeoMatch__c> geoMatchesList = new List<GeoMatch__c>();
        String originalGeoMatchId = ApexPages.currentPage().getParameters().get('OriginalGeoMatchId');
        if(originalGeoMatchId!=null){
        geoMatchesList = [SELECT Id,ToiGeoLocate__c,Match_Status__c FROM GeoMatch__c WHERE Id=:originalGeoMatchId LIMIT 1];      
        if(geoMatchesList!=null && geoMatchesList.size()>0){
          //geoMatchesList[0].ToiGeoLocate__c = mapADiGeoL.get(selectedAD);
          geoMatchesList[0].Match_Status__c = 'Geo Invalidated';
          update geoMatchesList[0];                        
        }
      }
        
        List<geoMatch__c> geoMatches = new List<GeoMatch__c>();
        geoMatches.add(geoMatch);
        GeoReAssign classGeoReAssign= new GeoReAssign();
        classGeoReAssign.changeOwnerForGeoMatchedRelatedObjs(geoMatches);
        
        PageReference geoMatchPage = new PageReference('/apex/googleGeoDistanceVisualizer1xn?id='+geoMatch.Id);
        geoMatchPage.setRedirect(true);
        return geoMatchPage;
    }
    
    //Auto-Match making
    public PageReference autoMatchMaking(){
        loadGeoMatrix1xn();
        List<googleGeoDistanceMatrixElementOneD> probablePairPool = new List<googleGeoDistanceMatrixElementOneD>();
        iGeoLocate__c toGeoMatched;
        Double destLatAddressMatched;
        Double destLongAddressMatched;
        for (Id fromiGeoId : odGroup.KeySet())
            probablePairPool = odGroup.get(fromiGeoId);
            
        Double bestDurationInMins = probablePairPool[0].durationInMins;
        for (googleGeoDistanceMatrixElementOneD aProspect : probablePairPool){
            //find a match
            if (bestDurationInMins >= aProspect.durationInMins){
                bestDurationInMins = aProspect.durationInMins;
                toGeoMatched = aProspect.toGeo;
                destLatAddressMatched = aProspect.destLatAddress;
                destLongAddressMatched = aProspect.destLongAddress;
            }
        }
        geoMatch = [select ToiGeoLocate__c,ToGeoAddress__Latitude__s,ToGeoAddress__Longitude__s,Match_Status__c from GeoMatch__c where Id = :geomatch.Id];
        if (bestDurationInMins <= 60){
            geoMatch.ToiGeoLocate__c = toGeoMatched.Id;
            geoMatch.ToGeoAddress__Latitude__s = destLatAddressMatched;
            geoMatch.ToGeoAddress__Longitude__s = destLongAddressMatched;
            geoMatch.Duration_in_Mins__c = bestDurationInMins;
            geoMatch.Match_Status__c = 'Geo Prospect';
        }
        else{
            geoMatch.Match_Status__c = 'Geo Unmatched';
        }
        
        update geoMatch;
        PageReference geoMatchPage = new ApexPages.StandardController(geoMatch).view();
        geoMatchPage.setRedirect(true);
        return geoMatchPage;
    }        
    
    //Auto-Match making batch
    public void autoMatchMakingBatch(Boolean alreadyAMassComputation){
        //loadGeoMatrix1xn();
        System.debug('alreadyAMassComputation Entered automatch---->'+alreadyAMassComputation);
        List<GeoMatch__c> geoMatchesToBeProcessed = (List<GeoMatch__c>)sObjectList;
        System.debug(sObjectList);
        System.debug(geoMatchesToBeProcessed);
        //Empty containers to be used later
        List<GeoMatch__c> geoMatchesProcessed = new List<GeoMatch__c>();
        List<GeoMatch__c> geoMatchesToBeReProcessed = new List<GeoMatch__c>();
        List<GeoMatch__c> geoMatchesToBeChOwned = new List<GeoMatch__c>();
        //The N probables
        List<googleGeoDistanceMatrixElementOneD> probablePairPool;
        //The 1:N  
        odGroup = new Map<Id,List<googleGeoDistanceMatrixElementOneD>>();
        iGeoLocate__c toGeoMatched;
        Double destLatAddressMatched;
        Double destLongAddressMatched;
        Double bestDurationInMins;
        //geoMatchesToBeProcessed = [select Match_Status__c,Approved_By__c,Approved_Date__c,serializedMatchMatrix__c from geoMatch__c where id in :geoMatchesToBeProcessed];
        System.debug('geoMatchesToBeProcessed------>'+geoMatchesToBeProcessed);
        System.debug('geoMatchesToBeProcessed------>'+geoMatchesToBeProcessed[0].Id);
        //Loop through all To Be Processed 
        for (GeoMatch__c geoMatchToBeProcessed : geoMatchesToBeProcessed){
            //if (geoMatchToBeProcessed.Match_Status__c == 'Geo Unmatched'){
                //Deserialize the  distance computation
                odGroup = (Map<Id,List<googleGeoDistanceMatrixElementOneD>>)JSON.deserialize(geoMatchToBeProcessed.serializedMatchMatrix__c,Map<Id,List<googleGeoDistanceMatrixElementOneD>>.class);
                System.debug('odGroup'+odGroup);
                //Load the computed N's for this geoMatch
                probablePairPool = new List<googleGeoDistanceMatrixElementOneD>();
                for (Id fromiGeoId : odGroup.KeySet())
                    probablePairPool = odGroup.get(fromiGeoId);
                
                System.debug('probablePairPool'+probablePairPool);
                //Find the best match    
                bestDurationInMins = probablePairPool[0].durationInMins;
                /*toGeoMatched = null;
                destLatAddressMatched  = null;
                destLongAddressMatched = null;*/
                toGeoMatched = probablePairPool[0].toGeo;
                destLatAddressMatched  = probablePairPool[0].destLatAddress;
                destLongAddressMatched = probablePairPool[0].destLongAddress;
                for (googleGeoDistanceMatrixElementOneD aProspect : probablePairPool){
                    //find a match
                    if (bestDurationInMins > aProspect.durationInMins){
                        bestDurationInMins = aProspect.durationInMins;
                        toGeoMatched = aProspect.toGeo;
                        destLatAddressMatched = aProspect.destLatAddress;
                        destLongAddressMatched = aProspect.destLongAddress;
                    }
                }
                //geoMatchToBeProcessed = [select ToiGeoLocate__c,ToGeoAddress__Latitude__s,ToGeoAddress__Longitude__s,Match_Status__c from GeoMatch__c where Id = :geoMatchToBeProcessed.Id];
                //if (bestDurationInMins < 120){
                //!!!!!*******HACK*******!!!!!!!!!!
                    geoMatchToBeProcessed.Duration_in_Mins__c = bestDurationInMins;
                //if the best is within an hour
                if (bestDurationInMins <= 60){
                    geoMatchToBeProcessed.ToiGeoLocate__c = toGeoMatched.Id;
                    geoMatchToBeProcessed.ToGeoAddress__Latitude__s = destLatAddressMatched;
                    geoMatchToBeProcessed.ToGeoAddress__Longitude__s = destLongAddressMatched;
                    //Commenting the following line since match is auto right from birth
                    //geoMatchToBeProcessed.Match_Status__c = 'Geo Prospect';
                    geoMatchToBeProcessed.Match_Status__c = 'Geo Matched';
                    //flags
                    System.debug('alreadyAMassComputation in 60---->'+alreadyAMassComputation);
                    if(distanceReComputationType=='YetToBegin'){//1-1: zipcode match for Permenant AD
                        List<Zip_Code__c> AssociatedZipCodeStatus = [select Id,Area__r.Assignment_Type__c from Zip_Code__c where id = :geoMatchToBeProcessed.Associated_Zip_Code__c];
                        if (AssociatedZipCodeStatus.size()>0){
                            //Scenario A
                            if (AssociatedZipCodeStatus[0].Area__r.Assignment_Type__c != 'Temporary'){  
                                geoMatchToBeProcessed.Assigned_AD__c = 'Zipcode AD';
                                geoMatchToBeProcessed.Assigned_AD_Status__c = 'Approved';
                                geoMatchToBeProcessed.Assignment_Type__c = 'Permanent';
                                geoMatchToBeProcessed.Is_Imported_From_Casper__c = false;
                                geoMatchToBeProcessed.Is_In_Range_Of_ZipCode_AD__c = 'Yes';
                            }
                            //Scenario D
                            else{//1-1: zipcode match for Temporary AD
                                geoMatchToBeProcessed.Assigned_AD__c = 'Zipcode AD';
                                geoMatchToBeProcessed.Assigned_AD_Status__c = 'Approved';
                                geoMatchToBeProcessed.Assignment_Type__c = 'Temporary';
                                geoMatchToBeProcessed.Is_Imported_From_Casper__c = false;
                                geoMatchToBeProcessed.Is_In_Range_Of_ZipCode_AD__c = 'Yes';
                                //Short circuiting the computation here as we dont want to sweep through the computation
                                alreadyAMassComputation = true;
                            }
                        }
                        //Scenario - F (Need to check)
                        //No ZipCode in system
                        else{
                            geoMatchToBeProcessed.Assigned_AD__c = 'Other AD';
                            geoMatchToBeProcessed.Assigned_AD_Status__c = 'Approved';
                            geoMatchToBeProcessed.Assignment_Type__c = 'Permanent';
                            geoMatchToBeProcessed.Is_Imported_From_Casper__c = false;
                            geoMatchToBeProcessed.Is_In_Range_Of_ZipCode_AD__c = 'No';
                            //Short circuiting the computation here as we dont want to sweep through the computation
                            alreadyAMassComputation = true;
                        }
                                               
                    }
                    //Scenario B
                    else if(distanceReComputationType=='EndOfComputation'){//1-n: match found
                        geoMatchToBeProcessed.Assigned_AD__c = 'Other AD';
                        geoMatchToBeProcessed.Assigned_AD_Status__c = 'Approved';
                        geoMatchToBeProcessed.Assignment_Type__c = 'Permanent';
                        geoMatchToBeProcessed.Is_Imported_From_Casper__c = false;
                        geoMatchToBeProcessed.Is_In_Range_Of_ZipCode_AD__c = 'No';
                    }
                    geoMatchesProcessed.add(geoMatchToBeProcessed);
                }
                else{
                    System.debug('alreadyAMassComputation else---->'+alreadyAMassComputation);
                    geoMatchToBeProcessed.Match_Status__c = 'Geo Unmatched';
                    //flags        
                    if(distanceReComputationType=='YetToBegin'){//1-1: no match. 
                        List<Zip_Code__c> AssociatedZipCodeStatus = [select Id,Area__r.Assignment_Type__c from Zip_Code__c where id = :geoMatchToBeProcessed.Associated_Zip_Code__c];
                        if (AssociatedZipCodeStatus.size()>0){
                            //History Record - No Scenario
                            if (AssociatedZipCodeStatus[0].Area__r.Assignment_Type__c != 'Temporary'){       
                                geoMatchToBeProcessed.Assigned_AD__c = 'Zipcode AD';
                                geoMatchToBeProcessed.Assigned_AD_Status__c = 'Approved';
                                geoMatchToBeProcessed.Assignment_Type__c = 'Permanent';
                                geoMatchToBeProcessed.Is_Imported_From_Casper__c = false;
                                geoMatchToBeProcessed.Is_In_Range_Of_ZipCode_AD__c = 'No';
                                geoMatchesToBeReProcessed.add(geoMatchToBeProcessed);
                                geoMatchesHistory.add(geoMatchToBeProcessed);
                            }
                            //Scenario E
                            else{//1-1: no match for Temporary AD
                                geoMatchToBeProcessed.Assigned_AD__c = 'Zipcode AD';
                                geoMatchToBeProcessed.Assigned_AD_Status__c = 'Needs Review';
                                geoMatchToBeProcessed.Assignment_Type__c = 'Temporary';
                                geoMatchToBeProcessed.Is_Imported_From_Casper__c = false;
                                geoMatchToBeProcessed.Is_In_Range_Of_ZipCode_AD__c = 'No';
                                //Short circuiting the computation here as we dont want to sweep through the computation
                                alreadyAMassComputation = true;
                                geoMatchesProcessed.add(geoMatchToBeProcessed);
                            }
                        }
                        //Scenario G Not Serviced
                        else{//New Zip, no match
                            geoMatchToBeProcessed.Assigned_AD__c = 'Other AD';
                            geoMatchToBeProcessed.Assigned_AD_Status__c = 'Approved';
                            geoMatchToBeProcessed.Assignment_Type__c = 'Permanent';
                            geoMatchToBeProcessed.Is_Imported_From_Casper__c = false;
                            geoMatchToBeProcessed.Is_In_Range_Of_ZipCode_AD__c = 'No';
                            //Short circuiting the computation here as we dont want to sweep through the computation
                            alreadyAMassComputation = true;
                            geoMatchesProcessed.add(geoMatchToBeProcessed);
                        }
                    }
                    //Scenario C
                    else if(distanceReComputationType=='EndOfComputation'){//1-n: no match. 
                        geoMatchToBeProcessed.Assigned_AD__c = 'Other AD';           
                        geoMatchToBeProcessed.Assigned_AD_Status__c = 'Approved';
                        geoMatchToBeProcessed.Assignment_Type__c = 'Permanent';
                        geoMatchToBeProcessed.Is_Imported_From_Casper__c = false;
                        geoMatchToBeProcessed.Is_In_Range_Of_ZipCode_AD__c = 'No';
                        geoMatchesToBeReProcessed.add(geoMatchToBeProcessed);
                        geoMatchesHistory.add(geoMatchToBeProcessed);
                    }
                    
                }
           // }
            /*else if (geoMatchToBeProcessed.Match_Status__c == 'Geo Prospect'){
                geoMatchToBeProcessed.Match_Status__c = 'Geo Matched';
                geoMatchToBeProcessed.Approved_By__c = UserInfo.getUserId();
                geoMatchToBeProcessed.Approved_Date__c = System.now();
            }*/
            
            //update geoMatch;
        }
        googleGeoController.iAmAlreadyCalled = true;
        //update geoMatchesProcessed;
        /*for (GeoMatch__c processedGeoMatch : geoMatchesProcessed){
            if (processedGeoMatch.Match_Status__c == 'Geo Matched'){
                geoMatchesToBeChOwned.add(processedGeoMatch);
            }
        }
        if (geoMatchesToBeChOwned.size() > 0)
            changeOwnerForGeoMatchedApplications(geoMatchesProcessed);*/
        
        if (!alreadyAMassComputation){
            if (geoMatchesToBeReProcessed.size() > 0 && distanceReComputationType.equals('YetToBegin')){
                findAMatchAgain(geoMatchesToBeReProcessed,'WithinState');   
                           
            }
            /*else if (geoMatchesToBeReProcessed.size() > 0 && distanceReComputationType.equals('ReadyForMass')){
                findAMatchAgain(geoMatchesToBeReProcessed,'Mass1xN');
            }*/
            else{
                findAMatchAgain(geoMatchesToBeReProcessed,'EndOfComputation');
                if (geoMatchesProcessed.size() > 0){  
                    if(!System.isBatch()){
                        insert geoMatchesHistory;
                        insert geoMatchesProcessed;
                    }
                    //batch. add to master list to insert at a later stage
                    else{
                        geoMatchesHistoryMaster.addAll(geoMatchesHistory);
                        geoMatchesProcessedMaster.addAll(geoMatchesProcessed);
                    }                                        
                }
                else{
                    if(!System.isBatch()){
                        insert geoMatchesHistory;
                    }
                    else{
                        geoMatchesHistoryMaster.addAll(geoMatchesHistory);
                    }
                }
            }
        }
        else{
            if (geoMatchesProcessed.size() > 0){
                if(!System.isBatch()){
                    insert geoMatchesHistory;
                    insert geoMatchesProcessed;
                }
                else{
                    geoMatchesHistoryMaster.addAll(geoMatchesHistory);
                    geoMatchesProcessedMaster.addAll(geoMatchesProcessed);
                }                
            }
            else{
                if(!System.isBatch()){
                    insert geoMatchesHistory;
                }
                else{
                    geoMatchesHistoryMaster.addAll(geoMatchesHistory);
                }
            }           
        }
        
        System.debug('geoMatchesHistoryMaster----->'+geoMatchesHistoryMaster.size());
        System.debug('geoMatchesProcessedMaster----->'+geoMatchesProcessedMaster.size());
        System.debug('geoMatchesProcessedMaster----->'+geoMatchesProcessedMaster);
        
    }            
    
    public void findAMatchAgain(List<GeoMatch__c> geoMatchesToBeReProcessed, String compType){
        //Take the from
        //Get a new ToList from the same state
        //Call Compute again
        //We need to call recompute only twice (starting the code with one first)
        
        if (compType.equals('WithinState')){
            //distanceReComputationType = 'ReadyForMass';
            //Shortening the repeated computation at one level as we don't need to look for AD's outside of State
            distanceReComputationType = 'EndOfComputation';
            System.debug('Searching for ADs within the same State');
            for (GeoMatch__c geoMatchToBeReProcessed : geoMatchesToBeReProcessed){
                iGeoLocate__c iGeoLocate = [select Id,Account__r.PersonMailingPostalCode,Account__r.PersonMailingState,GeoAddress__Latitude__s,GeoAddress__Longitude__s from iGeoLocate__c where id = : geoMatchToBeReProcessed.FromiGeoLocate__c];
                //Zip_Code__c ADAssociatedWithZip = [select area__r.area_director__r.contactid from zip_Code__c where zip_code__c = :iGeoLocate.Account__r.BillingPostalCode.substring(0,iGeoLocate.Account__r.BillingPostalCode.indexOfChar(45))];
                List<iGeoLocate__c> ADiGeoLocates = [select id from iGeoLocate__c where contact__c in (select Id from contact where MailingState = :iGeoLocate.Account__r.PersonMailingState)];
                
                //computeDistance1xn(iGeoLocate.Id,new Map<Id,SObject>(ADiGeoLocates).keySet(),null,this,false);
                
                if (ADiGeoLocates.size() > 0){
                    //Already a mass 1:N computation
                    computeDistance1xn(iGeoLocate.Id,new Map<Id,SObject>(ADiGeoLocates).keySet(),null,this,false);
                    
                }
                else{
                    if(geoMatchesHistory.size()>0)
                        insert geoMatchesHistory;
                        
                    //do nothing?
                    geoMatch__c noMatch = new geoMatch__c();
                    noMatch.FromiGeoLocate__c = iGeoLocate.Id;
                    noMatch.FromGeoAddress__Latitude__s = iGeoLocate.GeoAddress__Latitude__s;
                    noMatch.FromGeoAddress__Longitude__s = iGeoLocate.GeoAddress__Longitude__s;
                    noMatch.Match_Status__c = 'Geo UnMatched';
                    noMatch.Is_In_Range_Of_ZipCode_AD__c = 'No';
                    googleGeoController.iAmAlreadyCalled = true;
                    if(!System.isBatch()){
                        insert noMatch;
                    }
                    else{
                        noMatchListMaster.add(noMatch);
                    }
                }                
                
            }
        }
        /*else if (compType.equals('Mass1xN')){
            distanceReComputationType = 'EndOfComputation';
            System.debug('Searching for All ADs, Mass Compute');
            for (GeoMatch__c geoMatchToBeReProcessed : geoMatchesToBeReProcessed){
                iGeoLocate__c iGeoLocate = [select Account__r.PersonMailingPostalCode,Account__r.PersonMailingState from iGeoLocate__c where id = : geoMatchToBeReProcessed.FromiGeoLocate__c];
                List<iGeoLocate__c> ADiGeoLocates = [select id from iGeoLocate__c where contact__c != null and contact__r.Title = 'Area Director'];
                computeDistance1xn(iGeoLocate.Id,new Map<Id,SObject>(ADiGeoLocates).keySet(),null,this,false);
            }
        }*/
        else if (compType.equals('EndOfComputation')){
            System.debug('Returning with no matching AD found');
            return;
        }
    }
    
    
    public void changeOwnerForGeoMatchedApplications(List<sObject> geoMatchesForChOwnParam){
        //geoMatchesForChOwn = [select FromiGeoLocate__r.Lead__r.Id,FromiGeoLocate__r.Account__r.Id,FromiGeoLocate__r.Applicant_Info__r.Id,ToiGeoLocate__r.Contact__r.Id from GeoMatch__C where Id in :geoMatchesForChOwn];
        //List<GeoMatch__c> geoMatchesForChOwn = new List<GeoMatch__c>();           
        //System.debug('ENTERED OWNER CHANGE geoCon Match----->'+geoMatchesForChOwnParam.getSObjectType()); 
            googleGeoController.changeOwnerCalled = true;     
            googleGeoController.iAmAlreadyCalled = true;    
        //if(geoMatchesForChOwnParam!=null && geoMatchesForChOwnParam.getSObjectType() == GeoMatch__c.sObjectType){
        //  System.debug('ENTERED OWNER CHANGE geoMATCH----->');
            List<GeoMatch__c> geoMatchesForChOwn = (List<GeoMatch__c>)geoMatchesForChOwnParam;
            //geoMatchesForChOwn = [select FromiGeoLocate__r.Lead__r.Id,FromiGeoLocate__r.Account__r.Id,FromiGeoLocate__r.Applicant_Info__r.Id,ToiGeoLocate__r.Contact__r.Id from GeoMatch__C where Id in :geoMatchesForChOwnParam];
        //}
        
        if(geoMatchesForChOwn!=null && geoMatchesForChOwn.size()>0){    
            System.debug('ENTERED OWNER CHANGE geoCon Match----->'+geoMatchesForChOwn);
            System.debug('ENTERED OWNER CHANGE geoCon----->'+geoMatchesForChOwn.size());
            Map<Id,Id> contactIdAndOwnerIdMap = new Map<Id,Id>();
            Set<Id> contactIdsOfAds = new Set<Id>(); 
            List<Applicant_Info__c> applicationsToBeChOwned = new List<Applicant_Info__c>();
            List<Lead> leadsToBeChOwned = new List<Lead>();
            List<Account> accountsToBeChOwned = new List<Account>();
            List<Opportunity> oppsToBeChOwned = new List<Opportunity>();
            //Set<Id> iGeoLs = new Set<Id>();
            //List<iGeoLocate__c> iGeoLocates = new List<iGeoLocate__c>();
            //Get All AD's in context
            for (GeoMatch__c geoMatchToBeChOwned : geoMatchesForChOwn){
                //iGeoLs.add(geoMatchToBeChOwned.ToiGeoLocate__c);
                contactIdsOfAds.add(geoMatchToBeChOwned.ToiGeoLocate__r.Contact__r.Id);
            }
            /*
            if(iGeoLs!=null && iGeoLs.size()>0){
                iGeoLocates = [SELECT Id,Contact__c FROM iGeoLocate__c WHERE Id IN: iGeoLs];
                if(iGeoLocates!=null && iGeoLocates.size()>0){
                    for(iGeoLocate__c iGeoL:iGeoLocates){
                        contactIdsOfAds.add(iGeoL.Contact__c);
                    }
                }
            }
            */
            System.debug('ENTERED contactIdsOfAds----->'+contactIdsOfAds);
            //Get the corresponding userid and map it
            List<User> ADUsers = [select Id,ContactId from User where contactId in :contactIdsOfAds ]; 
            for (User ADUser : ADUsers){
                if (!contactIdAndOwnerIdMap.containsKey(ADUser.ContactId))
                    contactIdAndOwnerIdMap.put(ADUser.ContactId,ADUser.Id);
            }
            System.debug('ENTERED contactIdAndOwnerIdMap----->'+contactIdAndOwnerIdMap);
            //Get list of related Applications
            Set<Id> geoMatchesSet = new Map<Id,sObject>(geoMatchesForChOwn).KeySet();
            List<GeoMatch__c> relatedAccounts = [select FromiGeoLocate__r.Account__c from GeoMatch__c where id in :geoMatchesSet];
            Set<Id> relatedAccIds = new Set<Id>();
            for (GeoMatch__c geoMatch : relatedAccounts){
                relatedAccIds.add(geoMatch.FromiGeoLocate__r.Account__c);
            }
            System.debug('ENTERED relatedAccIds----->'+relatedAccIds);
            List<Applicant_Info__c> relatedAppInfos = [select Id,Account__c,ownerid from Applicant_Info__c where Account__c in :relatedAccIds];
            Map<Id,Applicant_Info__c> accAppMap = new Map<Id,Applicant_Info__c>();
            for (Applicant_Info__c appInfo : relatedAppInfos){
                accAppMap.put(appInfo.Account__c,appInfo);
            }
            System.debug('ENTERED accAppMap----->'+accAppMap);
            
            List<Opportunity> relatedOpps = [SELECT Id,AccountId,OwnerId FROM Opportunity WHERE AccountId IN:relatedAccIds];
            Map<Id,Opportunity> accOppMap = new Map<Id,Opportunity>();
            for(Opportunity opp:relatedOpps){
                accOppMap.put(opp.AccountId, opp);
            }
            System.debug('ENTERED accOppMap----->'+accOppMap);
            
            //Change the owner of appropriate objects
            for (GeoMatch__c geoMatchToBeChOwned : geoMatchesForChOwn){
                System.debug('ENTERED geoMatchToBeChOwned----->'+geoMatchToBeChOwned);
                if (geoMatchToBeChOwned.FromiGeoLocate__r.Applicant_Info__r.Id != null){
                    geoMatchToBeChOwned.FromiGeoLocate__r.Applicant_Info__r.OwnerId = contactIdAndOwnerIdMap.get(geoMatchToBeChOwned.ToiGeoLocate__r.Contact__r.Id);
                    applicationsToBeChOwned.add(geoMatchToBeChOwned.FromiGeoLocate__r.Applicant_Info__r);
                }
                else if (geoMatchToBeChOwned.FromiGeoLocate__r.Lead__r.Id != null){
                    geoMatchToBeChOwned.FromiGeoLocate__r.Lead__r.OwnerId = contactIdAndOwnerIdMap.get(geoMatchToBeChOwned.ToiGeoLocate__r.Contact__r.Id);
                    leadsToBeChOwned.add(geoMatchToBeChOwned.FromiGeoLocate__r.Lead__r);
                }
                else if (geoMatchToBeChOwned.FromiGeoLocate__r.Account__r.Id != null){
                    geoMatchToBeChOwned.FromiGeoLocate__r.Account__r.OwnerId = contactIdAndOwnerIdMap.get(geoMatchToBeChOwned.ToiGeoLocate__r.Contact__r.Id);
                    accountsToBeChOwned.add(geoMatchToBeChOwned.FromiGeoLocate__r.Account__r);
                    
                    accAppMap.get(geoMatchToBeChOwned.FromiGeoLocate__r.Account__c).ownerid = contactIdAndOwnerIdMap.get(geoMatchToBeChOwned.ToiGeoLocate__r.Contact__r.Id);
                    applicationsToBeChOwned.add(accAppMap.get(geoMatchToBeChOwned.FromiGeoLocate__r.Account__c));
                    
                    if(accOppMap!=null && accOppMap.size()>0){
                        accOppMap.get(geoMatchToBeChOwned.FromiGeoLocate__r.Account__c).ownerId = contactIdAndOwnerIdMap.get(geoMatchToBeChOwned.ToiGeoLocate__r.Contact__r.Id);
                        oppsToBeChOwned.add(accOppMap.get(geoMatchToBeChOwned.FromiGeoLocate__r.Account__c));
                    }
                }
            }
            try{
                System.debug('ENTERED leadsToBeChOwned----->'+leadsToBeChOwned);
                System.debug('ENTERED applicationsToBeChOwned----->'+applicationsToBeChOwned);
                System.debug('ENTERED accountsToBeChOwned----->'+accountsToBeChOwned);
                System.debug('ENTERED oppsToBeChOwned----->'+oppsToBeChOwned);
                
                update leadsToBeChOwned;
                //update applicationsToBeChOwned;
                applicationsChOwned.addall(applicationsToBeChOwned);
                update accountsToBeChOwned;
                update oppsToBeChOwned;
                                
            }
            catch(exception e){
                system.debug('EXCEPTION----'+e);
            }
        }
    }
    //Getters and Navigators:
        
    public List<List<googleGeoDistanceMatrixElement>> getdistanceMatrix(){
        return distanceMatrix;
    }
    
    public Map<Id,List<googleGeoDistanceMatrixElementOneD>> getodGroup(){
        return odGroup;
    }
    
    public iGeoLocate__c getfromGeo(){
        return fromGeo;
    }
    
    public PageReference justGoBackToMatch(){
        String goBackTo = ApexPages.currentPage().getParameters().get('goBackTo');
        String sTypeParam = ApexPages.currentPage().getParameters().get('stype');
        String origMatchParam = ApexPages.currentPage().getParameters().get('originalGeoMatchId');
        PageReference HFAccPage;
        if(goBackTo!=null && goBackTo=='sGeoMatch'){
            HFAccPage = new ApexPages.StandardController(geoMatch).view();
        }
        else if(goBackTo!=null && goBackTo=='SplitPage'){
            HFAccPage = new PageReference('/apex/geoReAssignConfirmation?id='+geoMatch.Id);
        }
        else if(sTypeParam!=null && sTypeParam=='reAssignHF'){
            HFAccPage = new PageReference('/apex/geoReAssignConfirmation?id='+geoMatch.Id+'&stype=reAssignHF');
            if(origMatchParam!=null){
                HFAccPage = new PageReference('/apex/geoReAssignConfirmation?id='+geoMatch.Id+'&stype=reAssignHF&originalGeoMatchId='+origMatchParam);  
            }
        }
        else{
            Account HFAccount = [select Id from Account where Id = :geoMatch.FromiGeoLocate__r.Account__c];
            HFAccPage = new ApexPages.StandardController(HFAccount).view();
        }
        HFAccPage.setRedirect(true);        
        return HFAccPage;
    }
}