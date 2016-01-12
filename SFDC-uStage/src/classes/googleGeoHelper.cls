public class googleGeoHelper {

    public List<Lead> apcHFLeads {get;set;}
    public Map<Id,iGeoLocate__c> geoLocationStatus {get;set;}
    public Map<Id,GeoMatch__c> geoMatchStatus {get;set;}
    public Integer geoLSize {get;set;}
    public Integer geoMSize {get;set;}
    public iGeoLocate__c iGeoGeneric {get;set;}
    public iGeoLocate__c iGeoForZip {get;set;}
    public iGeoLocate__c iGeoForAD {get;set;}
    public iGeoLocate__c iGeoForHF {get;set;}
    public List<GeoMatch__c> geoMatches {get;set;}
    public Zip_Code__c zipCode {get;set;} 
    public Area__c area {get;set;}
    public Area__c oldArea {get;set;}
    public String newAreaName{get;set;}
    public Account HFAccount {get;set;}
    public String zipCodeBoundaries {get;set;}
    public JSONParser parsedZipBoundaries {get; set;}
    public List<Zip_Code__c> selectedZips {get;set;}
    public List<Area__c> selectedAreas {get;set;}
    public List<Zip_Code__c> allAreaZips {get;set;}
    public List<Area__c> allAreas {get;set;}
    public String areas {get;set;}
    public String areaDirectors {get;set;}   
    public String AssignmentType{get;set;}
    public String ADs {get;set;}
    public List<iGeoLocate__c> iGeoHfs {get;set;}
    public List<iGeoLocate__c> iGeoAllAds {get;set;}
    public List<GeoMatch__c> iGeoHfsInMatch {get;set;}
    public GeoMatch__c placeHolderGeoMatch {get;set;}
    public Map<Id,String> areaADNames {get;set;}
    public Map<String,String> zipCodeToHF {get;set;}
    public Map<String,String> AllzipCodeToHF {get;set;}
    public Map<String,Integer> areaToHF {get;set;}
    public Map<String,String>  noADZip {get;set;}
    //public Map<String,Map<Id,String>> noADZips {get;set;}
    public List<geoNewZipWrapperInner> noADZips{get;set;}    
    
    public List<AggregateResult> listOfAreas{get;set;}
    public List<Area__c> listOfAllAreas{get;set;}
    public List<iGeoLocate__c> iGeoForAllZipsInAnArea{get;set;}
    public Map<String,Id> areaNameIdMap {get;set;}
    public List<GeoMatch__c> iGeoHfsInMatchForArea{get;set;}
    public Zip_Code__c newZipCode {get;set;}
    public Id newZipAssociatedId {get;set;}
    public String newZipCodeValue {get;set{newZipCodeValue=value;}}    
    public String searchZipCode {get;set;}
    public Integer countGreaterThan {get;set;}
    public Zip_Code__c newZipCodeForArea{get;set;}
    public List<String> areaList {get;set;}
    //RM Visualization Variables
    public List<Zip_Code__c> allZipWithADInfo {get;set;}
    public List<Zip_Code__c> allZipWithALLADInfo {get;set;}
    public List<geoZipWrapperInner> allZipWrapper {get;set;}
    public List<pageDetail> paginationBlock {get;set;}
    public List<pageDetail> paginationBlockArea {get;set;}
    
    public Map<Id,geoAreaWrapperInner> areaDetailWrapperMap {get;set;}
    //public Map<Id,geoAreaWrapperInner> areaDetailWrapperMapPaginated {get;set;}
    public List<Id> allAreaIds{get;set;}
    public List<Id> paginatedAreaIds{get;set;}
    public Integer newHFCount {get;set;}
    public Integer existingHFCount {get;set;}
    
    public List<geoNewAreaZipsWrapperClass> newAreaZipList {get;set;}
    public Set<Id> selZipNames {get;set;}
    public Boolean hasSelZip {get;set;}
    public String selectedZipIds{get;set;}
     Map<Id,List<googleGeoDistanceMatrixElementOneD>> odGroup {get;set;}
    public String resetareas {get;set;}
    //Pagination variables
    public Integer noOfPages {get;set;}
    public Integer noOfPagesArea {get;set;}
    public Integer startRow {get;set;}
    public Integer endRow {get;set;}
    public Integer recordsPerPage {get;set;}
    public Integer recordsPerPageArea {get;set;}
    public Map<String,String> areasAndZipCount {get;set;}
    public Map<Id,List<Area__c>> areaDetails {get;set;}
    public List<Contact> allADContacts {get;set;}
    
     public googleGeoHelper(){
        
        listOfAreas = new List<AggregateResult>();
        zipCodeToHF = new Map<String,String>();     
        AllzipCodeToHF = new Map<String,String>();
        areaToHF = new Map<String,Integer>();
        noADZip = new Map<String,String>();
        //noADZips = new Map<String,Map<Id,String>>();
        noADZips = new List<geoNewZipWrapperInner>();        
        
        areaNameIdMap = new Map<String,Id>();
        areaDetailWrapperMap = new Map<Id,geoAreaWrapperInner>();
        paginatedAreaIds = new List<Id>();
        areasAndZipCount = new Map<String,String>();
        areaDetails = new Map<Id,List<Area__c>>();
        populateAreasAndZipCount();
        loadAreaDetails();
        allADContacts = [select Id,Name,MailingState from contact where Id in (select contactid from user where profile.Name = 'APC AD PC')];
        //We dont know the scale yet, after query we will be set
        doAllStatQuerying();
     }
     
     //The Overloaded one for page level calls
     //Button Click objects need to be instantiated here
     public googleGeoHelper(ApexPages.StandardController stdcontroller){
        System.debug('Inside Standard Constructor');
        areaList = new List<String>();
        zipCodeToHF = new Map<String,String>();
        AllzipCodeToHF = new Map<String,String>();
        sObject theObject = stdController.getRecord();
        if (theObject.getSObjectType() == iGeoLocate__c.SObjectType){
            iGeoGeneric = (iGeoLocate__c)stdController.getRecord();
            iGeoGeneric = [select zip_Code__c from iGeoLocate__c where id = :iGeoGeneric.Id];
            if (iGeoGeneric.Zip_Code__c != null){
                iGeoForZip = iGeoGeneric;
            }
        }
        
        if (theObject.getSObjectType() == Zip_Code__c.SObjectType){
            zipCode = (Zip_Code__c)stdController.getRecord();
            zipCode = [select Zip_Code__c,Boundaries__c from Zip_Code__c where id = :zipCode.Id];
            selectedZips = [select Zip_Code__c,Boundaries__c from Zip_Code__c where id = :zipCode.Id];
            if (zipCode.Boundaries__c != null){
                zipCodeBoundaries = (String)JSON.deserialize(zipCode.Boundaries__c, String.Class);
                //parsedZipBoundaries = JSON.createParser(zipCodeBoundaries);
                iGeoForZip = [select GeoAddress__Latitude__s,GeoAddress__Longitude__s from iGeoLocate__c where zip_code__c = :zipCode.Id];
            }
        }
         
        if (theObject.getSObjectType() == Area__c.SObjectType && !(Apexpages.currentPage().getUrl().contains('geoNewAreaCreation'))){
            area = (Area__c)stdController.getRecord();
            area = [select Name,Area_Director__r.Contact.Id,Area_Director__r.Name,Assignment_Type__c from Area__c where Id = :area.Id];
            AssignmentType = area.Assignment_Type__c;
            Set<Id> zipIds = new Set<Id>();
            List<String> zipCodes = new List<String>();
            //Removed query filter and Has_Boundaries__c = true
            selectedZips = [select Zip_Code__c,Boundaries__c from Zip_Code__c where area__c = :area.id];
            for (Zip_Code__c zip : selectedZips){
                zipIds.add(zip.Id);
                zipCodes.add(zip.Zip_Code__c);
            }
            List<iGeoLocate__c> iGeoForZips = [select Zip_Code__r.Zip_Code__c,GeoAddress__Latitude__s,GeoAddress__Longitude__s from iGeoLocate__c where zip_code__c = :selectedZips[0].Id];
            if(iGeoForZips!=null && iGeoForZips.size()>0){
              iGeoForZip = iGeoForZips[0];
            }
            
            iGeoForAllZipsInAnArea = [select Zip_Code__r.Zip_Code__c,GeoAddress__Latitude__s,GeoAddress__Longitude__s from iGeoLocate__c where zip_code__c in :zipIds];
            
            //iGeo For the AREA AD
            List<iGeoLocate__c> iGeoForADs = [select id,Contact__r.Name,GeoAddress__Latitude__s,GeoAddress__Longitude__s from iGeoLocate__c where Contact__c = :area.Area_Director__r.Contact.Id];
            if(iGeoForADs!=null && iGeoForADs.size()>0){
              iGeoForAD = iGeoForADs[0];
            }
            
            //All HF iGeos in a GeoMatch 
            iGeoHfsInMatchForArea =[select id,FromiGeoLocate__r.Account__c,FromiGeoLocate__r.Account__r.Name,FromiGeoLocate__r.Account__r.PersonMailingStreet,
                                        FromiGeoLocate__r.Account__r.PersonMailingCity,FromiGeoLocate__r.Account__r.PersonMailingState,
                                            FromiGeoLocate__r.Account__r.PersonMailingPostalCode, FromiGeoLocate__r.GeoAddress__Latitude__s,
                                                FromiGeoLocate__r.GeoAddress__Longitude__s 
                                                    from GeoMatch__c 
                                                    where 
                                                        FromiGeoLocate__r.Account__r.PersonMailingPostalCode in :zipCodes 
                                                        and 
                                                        ToiGeoLocate__c = :iGeoForAD.Id 
                                                        and 
                                                        Match_Status__c = 'Geo Matched'];
            set<Id> HFIdsInGeoMatch = new Set<Id>();
            for (GeoMatch__c geoMatch : iGeoHfsInMatchForArea){
                HFIdsInGeoMatch.add(geoMatch.FromiGeoLocate__r.Account__c);
            }
            
            Set<Id> HFIdsInMatch = new Set<Id>();
            List<Match__c> APMatches = [select Id,Position_Name__r.Host_Company_Id__c,Participant_Id__c from Match__c where Position_Name__r.Host_Company_Id__c in :HFIdsInGeoMatch];
            for (Match__c apMatch : APMatches){
                HFIdsInMatch.add(apMatch.Participant_Id__c);
            }
            
            existingHFCount = HFIdsInMatch.size();
            newHFCount = iGeoHfsInMatchForArea.size() - HFIdsInMatch.size();
                                                        
            //Get All AD's
            //Need to add *****-- 
            allAreas = [select Name,Area_Director__r.Contact.Id,Area_Director__r.Contact.Name,Assignment_Type__c from Area__c where id != :area.Id and Area_Director__c != :area.Area_Director__c and Area_Director__r.ManagerId = :UserInfo.getUserId() and Area_Director__r.ContactId != null ORDER BY Area_Director__r.Name];
            Set<Id> ADContactIds = new Set<Id>();
            for (Area__c area : allAreas){
                ADContactIds.add(area.Area_Director__r.Contact.Id);
            }
            iGeoAllAds = [select id,Contact__c,Contact__r.Name,GeoAddress__Latitude__s,GeoAddress__Longitude__s from iGeoLocate__c where Contact__c in :ADContactIds];
            areaADNames = new Map<Id,String>();
            for (Area__c anArea : allAreas){
                if (areaADNames.containsKey(anArea.Area_Director__r.Contact.Id)){
                    areaADNames.put(anArea.Area_Director__r.Contact.Id,areaADNames.get(anArea.Area_Director__r.Contact.Id)+'<br/>*) '+anArea.Name);
                }
                else{
                    areaADNames.put(anArea.Area_Director__r.Contact.Id,anArea.Area_Director__r.Contact.Name+' - <br/> <br/><b>Areas Managed:</b> <br/><br/>*) '+anArea.Name);
                }
            }
            System.debug(areaADNames);
            doAllStatQuerying();
                                                                    
        }
        
        //New Area creation page
        if(Apexpages.currentPage().getUrl().contains('geoNewAreaCreation')){
          newAreaName = '';
          oldArea = (Area__c)stdController.getRecord();
            oldArea = [select Name,Area_Director__r.Contact.Id,Area_Director__r.Name,Regional_Manager__r.Name,Region_Name__c,Assignment_Type__c
                   from Area__c where Id = :oldArea.Id];
                   
            selectedZipIds = ApexPages.currentPage().getParameters().get('checkedZips');
        }
        
        if (theObject.getSObjectType() == GeoMatch__c.SObjectType){
            placeHolderGeoMatch = (GeoMatch__c)stdController.getRecord();
            placeHolderGeoMatch = [select   Previous_Zip_Code__r.Zip_Code__c from GeoMatch__c where id = :placeHolderGeoMatch.Id];
        }
        if (theObject.getSObjectType() == Account.SObjectType){
            HFAccount = (Account)stdController.getRecord();
            iGeoForHF = [select Id,GeoAddress__Latitude__s,GeoAddress__Longitude__s from iGeoLocate__c where Account__c = :HFAccount.Id];
            geoMatches = [select ToiGeoLocate__c from GeoMatch__c where FromiGeoLocate__c = :iGeoForHF.Id and Match_Status__c = 'Geo Matched'];
            //iGeoForHF = [select GeoAddress__Latitude__s,GeoAddress__Longitude__s from iGeoLocate__c where Id = :geoMatch.ToiGeoLocate__c];
        }
     }
     
     public googleGeoHelper(ApexPages.StandardSetController stdSetController){
        //get Selected Records in List View
        sObject theObjectType = stdSetController.getRecord();
        selectedZips = new List<Zip_Code__c>();
        selectedAreas = new List<Area__c>();
        areas = '';
        areaDirectors = '';
        if (theObjectType.getSObjectType() == Zip_Code__c.sObjectType){
            selectedZips = (List<Zip_Code__c>) stdSetController.getSelected();
        }
        else{
            selectedAreas = (List<Area__c>) stdSetController.getSelected();
        }
        System.debug(selectedZips);
        System.debug(selectedAreas);
        if (selectedZips.size() == 0 && selectedAreas.size() == 0){
            //Get the Zip Code detail
            zipCode = [select Zip_Code__c,Boundaries__c,Area__r.Name,Area__r.Area_Director__r.Name,Area__r.Area_Director__r.Contact.Id from Zip_Code__c where id = :ApexPages.currentPage().getParameters().get('id')];
            //Get its corresponding iGeoLocate
            List<iGeoLocate__c> iGeoForZipList = [select GeoAddress__Latitude__s,GeoAddress__Longitude__s from iGeoLocate__c where zip_code__c = :zipCode.Id];
            if (iGeoForZipList.size() > 0)
                iGeoForZip = iGeoForZipList[0];
            else
                iGeoForZip = new iGeoLocate__c();
            //iGeo For the ZipCode AD
            iGeoForAD = [select id,Contact__r.Name,GeoAddress__Latitude__s,GeoAddress__Longitude__s from iGeoLocate__c where Contact__c = :zipCode.Area__r.Area_Director__r.Contact.Id];
            
            //Get All HF's iGeos who are associated with this zip Code *****NEEDS REFINEMENT
            iGeoHfs = [select id,Account__r.Name,GeoAddress__Latitude__s,GeoAddress__Longitude__s from iGeoLocate__c where Account__c in (select Id from Account where PersonMailingPostalCode = :zipCode.Zip_Code__c)];
            Set<Id> iGeoIds = (new Map<Id,iGeoLocate__c>(iGeoHfs)).keySet();
            //All HF iGeos in a GeoMatch 
            iGeoHfsInMatch =[select id,FromiGeoLocate__r.Account__c,FromiGeoLocate__r.Account__r.Name,FromiGeoLocate__r.Account__r.PersonMailingStreet,FromiGeoLocate__r.Account__r.PersonMailingCity,FromiGeoLocate__r.Account__r.PersonMailingState,FromiGeoLocate__r.Account__r.PersonMailingPostalCode,FromiGeoLocate__r.GeoAddress__Latitude__s,FromiGeoLocate__r.GeoAddress__Longitude__s from GeoMatch__c where FromiGeoLocate__c in :iGeoIds and ToiGeoLocate__c = :iGeoForAD.Id and Match_Status__c = 'Geo Matched'];
            
            //Get All Areas
            allAreas = [select Name,Area_Director__r.Contact.Id,Area_Director__r.Contact.Name,Assignment_Type__c from Area__c where id != :zipCode.Area__c and Area_Director__c != :zipCode.Area__r.Area_Director__c and Area_Director__r.ManagerId = :UserInfo.getUserId() ORDER BY Area_Director__r.Name];
            Set<Id> ADContactIds = new Set<Id>();
            for (Area__c area : allAreas){
                ADContactIds.add(area.Area_Director__r.Contact.Id);
            }
            iGeoAllAds = [select id,Contact__c,Contact__r.Name,GeoAddress__Latitude__s,GeoAddress__Longitude__s from iGeoLocate__c where Contact__c in :ADContactIds];
            areaADNames = new Map<Id,String>();
            for (Area__c anArea : allAreas){
                if (areaADNames.containsKey(anArea.Area_Director__r.Contact.Id)){
                    areaADNames.put(anArea.Area_Director__r.Contact.Id,areaADNames.get(anArea.Area_Director__r.Contact.Id)+'<br/>*) '+anArea.Name);
                }
                else{
                    areaADNames.put(anArea.Area_Director__r.Contact.Id,anArea.Area_Director__r.Contact.Name+' - <br/> <br/><b>Areas Managed:</b> <br/><br/>*) '+anArea.Name);
                }
            }
            System.debug(areaADNames);
            
            set<Id> HFIdsInGeoMatch = new Set<Id>();
            for (GeoMatch__c geoMatch : iGeoHfsInMatch){
                HFIdsInGeoMatch.add(geoMatch.FromiGeoLocate__r.Account__c);
            }
            
            Set<Id> HFIdsInMatch = new Set<Id>();
            List<Match__c> APMatches = [select Id,Position_Name__r.Host_Company_Id__c,Participant_Id__c from Match__c where Position_Name__r.Host_Company_Id__c in :HFIdsInGeoMatch];
            for (Match__c apMatch : APMatches){
                HFIdsInMatch.add(apMatch.Participant_Id__c);
            }
            
            existingHFCount = HFIdsInMatch.size();
            newHFCount = iGeoHfsInMatch.size() - HFIdsInMatch.size();
                                                        
        }
        else if (selectedZips.size() > 0){
            //selectedZips = [select Zip_Code__c,Boundaries__c from Zip_Code__c where id in :selectedZips];
            iGeoForZip = [select GeoAddress__Latitude__s,GeoAddress__Longitude__s from iGeoLocate__c where zip_code__c = :selectedZips[0].Id];
        }
        else if (selectedAreas.size() > 0){
            allAreaZips = [select Zip_Code__c,Name,Area__r.Name,Boundaries__c from Zip_Code__c where Area__c in :selectedAreas and Has_Boundaries__c =  true];
            iGeoForZip = [select GeoAddress__Latitude__s,GeoAddress__Longitude__s from iGeoLocate__c where zip_code__c = :allAreaZips[0].Id];
        }
        System.debug(allAreaZips);
     }
     
     public List<geoAreaWrapperInner> wrapperList{get;set;}
     
     public void doAllStatQuerying(){
        System.debug('Came in ----->');
        wrapperList = new List<geoAreaWrapperInner>();
        allAreaIds = new List<Id>();
        if (ApexPages.currentPage().getParameters().get('type') == null){
          if (recordsPerPage == null){
              recordsPerPage = 5;
          startRow = 1;
          endRow = 5;
            }
            paginationBlock = new List<pageDetail>();
            paginationBlockArea = new List<pageDetail>();
            
            //allZipWithADInfo = [select Zip_Code__C,Area__r.Id,Area__r.Name,Area__r.Area_Director__r.Contact.Name,Area__r.Area_Director__r.ManagerId from zip_Code__c where Area__c != null and Area__r.Area_Director__c != null and Area__r.Area_Director__r.ManagerId = :UserInfo.getUserId()];
            List<AggregateResult> statQuery = new List<AggregateResult>();
            //resetareas = '';
            if (resetareas == 'Blank'){
              areas = null;
            }
            if ((areas != null || areas != '')){
              areaDetailWrapperMap = new Map<Id,geoAreaWrapperInner>();
            }
            System.debug('searchZipCode----->'+searchZipCode);
            System.debug('countGreaterThan----->'+countGreaterThan);
            if (countGreaterThan == null){
                countGreaterThan = 0;
            }           
            List<String> theZipsInContention = new List<String>();
            
            List<Contact> ADsReportingToThisRM = [select Id from contact where ownerId = :UserInfo.getUserId()];            
            Map<Id,sObject> ADIds = new Map<Id,sObject>(ADsReportingToThisRM);
            
            if (searchZipCode == null || searchZipCode == ''){
                statQuery = [select FromiGeoLocate__r.Account__r.PersonMailingPostalCode zipCode,ToiGeoLocate__r.Contact__c ad,count(id) noofhfs 
                                                from GeoMatch__C 
                                                where  
                                                    Match_Status__c = 'Geo Matched' and 
                                                        FromiGeoLocate__r.Account__r.PersonMailingPostalCode != null and 
                                                            ToiGeoLocate__c != null
                                                            group by FromiGeoLocate__r.Account__r.PersonMailingPostalCode,ToiGeoLocate__r.Contact__c  
                                                            //having count(id) > :countGreaterThan 
                                                            having count(id) > 0
                                                            order by count(id) desc];
                System.debug(statQuery);
                
                for (AggregateResult stats : statQuery){
                    string splitZip = String.Valueof(stats.get('zipCode'));
                    if(splitZip.contains('-'))
                        splitZip = splitZip.substring(0,splitZip.indexOfChar(45));
                    else
                        splitZip = splitZip;
                    
                    theZipsInContention.add(splitZip);
                }
            }
            else{
                statQuery = [select FromiGeoLocate__r.Account__r.PersonMailingPostalCode zipCode,ToiGeoLocate__r.Contact__c ad,count(id) noofhfs 
                                                from GeoMatch__C 
                                                where  
                                                    FromiGeoLocate__r.Account__r.PersonMailingPostalCode like :'%'+searchZipCode+'%'  and 
                                                    Match_Status__c = 'Geo Matched' and 
                                                        FromiGeoLocate__r.Account__r.PersonMailingPostalCode != null and 
                                                            ToiGeoLocate__c != null
                                                            group by FromiGeoLocate__r.Account__r.PersonMailingPostalCode,ToiGeoLocate__r.Contact__c 
                                                            having count(id) > 0 
                                                            order by count(id) desc];
                for (AggregateResult stats : statQuery){
                    string splitZip = String.Valueof(stats.get('zipCode'));
                    if(splitZip.contains('-'))
                    	splitZip = splitZip.substring(0,splitZip.indexOfChar(45));
                	else
                    	splitZip = splitZip;
                    
                    theZipsInContention.add(String.Valueof(stats.get('zipCode')));
                }
            }
            
            String allZipWithALLADInfoQuery = 'select Zip_Code__C,Area__c,Area__r.Id,Area__r.Name,Area__r.Area_Director__r.Contact.Name,Area__r.Area_Director__r.ManagerId,Area__r.Area_Director__r.Manager.Name from zip_Code__c ' + 
                                     'where zip_Code__c in :theZipsInContention and Area__c != null and Area__r.Area_Director__c != null';
            allZipWithALLADInfo = Database.query(allZipWithALLADInfoQuery);
            
            Id currentUserId = UserInfo.getUserId();
            String allZipWithADInfoQuery = 'select Zip_Code__C,Area__c,Area__r.Id,Area__r.Name,Area__r.Area_Director__r.Contact.Name,Area__r.Area_Director__r.ManagerId,Area__r.Area_Director__r.Manager.Name from zip_Code__c ' + 
                                     'where zip_Code__c in :theZipsInContention and Area__c != null and Area__r.Area_Director__c != null and Area__r.Area_Director__r.ManagerId = :currentUserId';            
            /*if ((areas == null || areas == '' || areas == 'None') && (areadirectors == null || areadirectors == '' || areadirectors == 'None')){ 
              allZipWithADInfo = [select Zip_Code__C,Area__c,Area__r.Id,Area__r.Name,Area__r.Area_Director__r.Contact.Name,Area__r.Area_Director__r.ManagerId,Area__r.Area_Director__r.Manager.Name from zip_Code__c 
                                    where zip_Code__c in :theZipsInContention and Area__c != null and Area__r.Area_Director__c != null and Area__r.Area_Director__r.ManagerId = :UserInfo.getUserId()];
            }
            else{
              allZipWithADInfo = [select Zip_Code__C,Area__c,Area__r.Id,Area__r.Name,Area__r.Area_Director__r.Contact.Name,Area__r.Area_Director__r.ManagerId,Area__r.Area_Director__r.Manager.Name from zip_Code__c 
                                    where zip_Code__c in :theZipsInContention and Area__c != null and Area__c = :areas and Area__r.Area_Director__c != null and Area__r.Area_Director__r.ManagerId = :UserInfo.getUserId()];
            }*/
            if (areas != null){
              allZipWithADInfoQuery = allZipWithADInfoQuery + ' and Area__c = :areas';
            }
            if (areadirectors != null && areadirectors != 'None'){
              allZipWithADInfoQuery = allZipWithADInfoQuery + ' and Area__r.Area_Director__r.Name = :areadirectors';
            }
            
            allZipWithADInfoQuery = allZipWithADInfoQuery + ' ORDER BY Area__r.Area_Director__r.Name ASC, Area__r.Name ASC';
            
            System.debug(allZipWithADInfoQuery);
            allZipWithADInfo = Database.query(allZipWithADInfoQuery);
                                                             
            
                                                            
            //Unassigned ZipCodes
            List<AggregateResult> statQueryUnAssignedZipCode = 
            [select toigeolocate__r.contact__c ADId,toigeolocate__r.contact__r.Name ADName, fromiGeoLocate__r.Account__r.PersonMailingPostalCode zipCode,count(id) zipCount 
                from geomatch__c 
                 where match_Status__c = 'Geo Matched' and toigeolocate__r.contact__c != null and toigeolocate__r.contact__c in :ADIds.keySet() 
                  group by toigeolocate__r.contact__c,toigeolocate__r.contact__r.Name,fromiGeoLocate__r.Account__r.PersonMailingPostalCode];
            Map<String,String> interimResult = new Map<String,String>();
            
            for (AggregateResult stats : statQuery){
                string splitZip = String.Valueof(stats.get('zipCode'));
                if(splitZip.contains('-'))
                    splitZip = splitZip.substring(0,splitZip.indexOfChar(45));
                else
                    splitZip = splitZip;
                
                interimResult.put(splitZip+'-'+String.Valueof(stats.get('ad')),String.Valueof(stats.get('noofhfs')));
                System.debug(stats.get('noofhfs'));
            }
            System.debug(interimResult);
            List<String> theZipsWithNonZeroCount = new List<String>();
            //allZipWithADInfo.sort();
            allZipWrapper = new List<geoZipWrapperInner>();
            
            Integer paginationCounter = 1;
            noOfPages = allZipWithADInfo.size() / recordsPerPage;
            
            if (math.mod(allZipWithADInfo.size(),recordsPerPage) > 0){
              noOfPages = noOfPages + 1;
            }
            Integer startRowNum = 1;
            for (Integer page=1; page<=noOfPages;page++){
              pageDetail pd = new pageDetail();
              pd.pageNum = page;
              pd.startRow = startRowNum;
              pd.endRow = startRowNum+recordsPerPage-1;
              paginationBlock.add(pd);
              //paginationBlock.add('startRow='+startRowNum+'&endRow='+((startRowNum+recordsPerPage)-1)+'&recordsPerPage='+recordsPerPage);
              startRowNum = startRowNum+recordsPerPage;
            }
            
            for (Zip_Code__C zip : allZipWithALLADInfo){
                AllzipCodeToHF.put(zip.zip_code__C,zip.zip_code__C+'-'+zip.Area__r.Area_Director__r.Contact.Id);
            }
            
            for (Zip_Code__C zip : allZipWithADInfo){
              system.debug('startRow:'+startRow+'endRow:'+endRow+'paginationCounter:'+paginationCounter);
              if (paginationCounter >= startRow && paginationCounter <= endRow){
                system.debug('Added to List+startRow:'+startRow+'endRow:'+endRow+'paginationCounter:'+paginationCounter);
                geoZipWrapperInner newZipWrapper = new geoZipWrapperInner();
                newZipWrapper.theZip = zip;
                allZipWrapper.add(newZipWrapper);
              }
              paginationCounter++;
                System.debug(zip.zip_code__C+'-'+zip.Area__r.Area_Director__r.Contact.Id);
                if (interimResult.containsKey(zip.zip_code__C+'-'+zip.Area__r.Area_Director__r.Contact.Id)){
                  theZipsWithNonZeroCount.add(zip.zip_code__C);
                    zipCodeToHF.put(zip.zip_code__C,interimResult.get(zip.zip_code__C+'-'+zip.Area__r.Area_Director__r.Contact.Id));     
                    System.debug('areas='+areas+'areadirectors='+areadirectors+'zip.Area__c='+zip.Area__c); 
                    if (((areas != null || areas != '') && zip.Area__c == areas) || (areas == null || areas == '' || areas == 'None')){ 
                      if (((areadirectors != null || areadirectors != '') && areadirectors == zip.Area__r.Area_Director__r.Contact.Name) || (areadirectors == null || areadirectors == '' || areadirectors == 'None')){            
                        if(areaDetailWrapperMap.containsKey(zip.Area__c)){
                            ///areaToHF.put(zip.Area__r.Name,Integer.ValueOf(areaToHF.get(zip.Area__r.Name))+Integer.ValueOf(interimResult.get(zip.zip_code__C+'-'+zip.Area__r.Area_Director__r.Contact.Id)));
                            areaDetailWrapperMap.get(zip.Area__c).noOfHFs = areaDetailWrapperMap.get(zip.Area__c).noOfHFs +  Integer.ValueOf(interimResult.get(zip.zip_code__C+'-'+zip.Area__r.Area_Director__r.Contact.Id));
                            //areaDetailWrapperMap.put(zip.Area__c,Integer.ValueOf(areaToHF.get(zip.Area__r.Name))+Integer.ValueOf(interimResult.get(zip.zip_code__C+'-'+zip.Area__r.Area_Director__r.Contact.Id)));
                        }
                        else{
                            //areaToHF.put(zip.Area__r.Name,Integer.ValueOf(interimResult.get(zip.zip_code__C+'-'+zip.Area__r.Area_Director__r.Contact.Id)));
                            geoAreaWrapperInner newAreaWrapper = new geoAreaWrapperInner(this); 
                            allAreaIds.add(zip.Area__c);
                            newAreaWrapper.areaId = zip.Area__c;
                            newAreaWrapper.noOfHFs = Integer.ValueOf(interimResult.get(zip.zip_code__C+'-'+zip.Area__r.Area_Director__r.Contact.Id));
                            newAreaWrapper.AreaName = zip.Area__r.Name;
                            newAreaWrapper.ADName = zip.Area__r.Area_Director__r.Contact.Name;
                            newAreaWrapper.RM = zip.Area__r.Area_Director__r.Manager.Name;
                            newAreaWrapper.populateNoOfZips();
                            //adding list for sorting
                            
                            wrapperList.add(newAreaWrapper);
                            //wrapperList.sort();
                            areaDetailWrapperMap.put(zip.Area__c,newAreaWrapper);
                        }
                      }
                    }
                }
                else{
                    zipCodeToHF.put(zip.zip_code__C,'0');
                }
                //adding the sorted list to map
                //areaDetailWrapperMap.put(zip.Area__c,newAreaWrapper);
            }

            System.debug(allAreaIds);
            paginatedAreaIds = new List<Id>();
            noOfPagesArea = areaDetailWrapperMap.keySet().size()/recordsPerPage;
            if (math.mod(areaDetailWrapperMap.keySet().size(),recordsPerPage) > 0){
              noOfPagesArea = noOfPagesArea + 1;
            }
            startRowNum = 1;
            for (Integer page=1; page<=noOfPagesArea;page++){
              pageDetail pda = new pageDetail();
              pda.pageNum = page;
              pda.startRow = startRowNum;
              pda.endRow = startRowNum+recordsPerPage-1;
              paginationBlockArea.add(pda);
              //paginationBlock.add('startRow='+startRowNum+'&endRow='+((startRowNum+recordsPerPage)-1)+'&recordsPerPage='+recordsPerPage);
              startRowNum = startRowNum+recordsPerPage;
            }
            paginationCounter = 1;
            for (Id zipCodeId : allAreaIds){
              if (paginationCounter >= startRow && paginationCounter <= endRow){
                paginatedAreaIds.add(zipCodeId);
              }
              paginationCounter++;
            }

            
            System.debug(zipCodeToHF);
            System.debug(areaDetailWrapperMap);
            //listOfAreas = [select toigeolocate__r.contact__c,toigeolocate__r.contact__r.Name ADName,count(id) NoOfHFs from geomatch__c where toigeolocate__r.contact__c != null group by toigeolocate__r.contact__c,toigeolocate__r.contact__r.Name];
            listOfAllAreas = [select Id,Name,Area_Director__r.Name,Assignment_Type__c from Area__c ORDER BY Area_Director__r.Name];
            for (Area__c area : listOfAllAreas){
                areaNameIdMap.put(area.Name,area.Id);
            }
            if (!ApexPages.currentPage().getUrl().contains('geoAreasTab')){
              System.debug('All Zips: zipCodeToHF---->'+zipCodeToHF);
              System.debug('All Zips: zipCodeToHF---->'+zipCodeToHF.size());
              System.debug('From HFs: statQueryUnassignedZipCode---->'+statQueryUnassignedZipCode);
              //Get AreaDirector Areas
              for (AggregateResult noADZipStat : statQueryUnassignedZipCode){                  
                  
                  if(noADZipStat.get('zipCode')!=null){
                      string unAssZip = String.Valueof(noADZipStat.get('zipCode'));
                      if(unAssZip.contains('-'))
                          unAssZip = unAssZip.substring(0,unAssZip.indexOfChar(45));
                      else
                          unAssZip = unAssZip;
                      
                      System.debug('unAssZip---->'+unAssZip);                      
                      //if (!zipCodeToHF.containsKey(unAssZip)){
                      if (!AllzipCodeToHF.containsKey(unAssZip)){
                          noADZip.put(String.Valueof(noADZipStat.get('zipCode')),String.Valueof(noADZipStat.get('zipCount'))+noADZipStat.get('ADName'));
                          //noADZips.put(String.Valueof(noADZipStat.get('zipCode')),new Map<Id,String>());
                          //noADZips.get(String.Valueof(noADZipStat.get('zipCode'))).put((Id)noADZipStat.get('ADId'),String.Valueof(noADZipStat.get('zipCount')));
                          geoNewZipWrapperInner newZipWrapper = new geoNewZipWrapperInner(this);
                          newZipWrapper.newZipCode = unAssZip;
                          newZipWrapper.associatedADId = (Id)noADZipStat.get('ADId');
                          newZipWrapper.HFCount = Integer.valueOf(noADZipStat.get('zipCount'));
                          newZipWrapper.queryAreasAssociatedWithAD();
                          noADZips.add(newZipWrapper);
                          //Area Director's Area
                      }
                  }
              }
            }
            
            if (ApexPages.currentPage().getUrl().contains('geoAreasTab')){
              allAreas =[select Id, Name, Area_Director__r.Contact.Name from Area__c where Id in :areaDetailWrapperMap.keySet() and Area_Director__r.ContactId != null ORDER BY Area_Director__r.Name]; 
            }
            else{
              allAreas =[select Id, Name, Area_Director__r.Contact.Name from Area__c where Id in (select Area__c from zip_code__c where zip_Code__c in :theZipsWithNonZeroCount) and Area_Director__r.ContactId != null ORDER BY Area_Director__r.Name];
            }
      
        }
        else if (ApexPages.currentPage().getParameters().get('type').equals('newZipToArea')){
            newZipCode = [select Id from Zip_Code__C where id = :ApexPages.currentPage().getParameters().get('newZipCode')];
        }
        else if (ApexPages.currentPage().getParameters().get('type').equals('areaVisualizer')){
            List<AggregateResult> statQuery = new List<AggregateResult>();
            List<string> zipCodes = new List<String>();
            List<Zip_Code__c> zipCodeList = [select zip_code__c from Zip_Code__C where Area__c = :area.Id];
            for (zip_code__C zipCode : zipCodeList){
                zipCodes.add(zipCode.Zip_Code__c);
            }
            statQuery = [select FromiGeoLocate__r.Account__r.PersonMailingPostalCode zipCode,ToiGeoLocate__r.Contact__c ad,count(id) noofhfs 
                                                from GeoMatch__C 
                                                where  
                                                    Match_Status__c = 'Geo Matched' and 
                                                        FromiGeoLocate__r.Account__r.PersonMailingPostalCode != null and 
                                                            ToiGeoLocate__c != null   and 
                                                            ToiGeoLocate__r.Contact__c = :area.Area_Director__r.contactid and 
                                                            FromiGeoLocate__r.Account__r.PersonMailingPostalCode in :zipCodes  
                                                            group by FromiGeoLocate__r.Account__r.PersonMailingPostalCode,ToiGeoLocate__r.Contact__c  
                                                            order by count(id) desc];
            allZipWithADInfo = [select Id,Zip_Code__C,Area__c,Area__r.Id,Area__r.Name,Area__r.Area_Director__r.Contact.Name,Area__r.Area_Director__r.ManagerId,Area__r.Area_Director__r.Manager.Name, Area__r.Area_Director__r.Name from zip_Code__c 
                            where zip_Code__c in :zipCodes and Area__c != null and Area__r.Area_Director__c != null and Area__c = :area.Id and Area__r.Area_Director__r.ManagerId = :UserInfo.getUserId() ORDER BY Area__r.Area_Director__r.Name ASC, Area__r.Name ASC];
            
            Map<String,String> interimResult = new Map<String,String>();
            
            for (AggregateResult stats : statQuery){
                interimResult.put(String.Valueof(stats.get('zipCode'))+'-'+String.Valueof(stats.get('ad')),String.Valueof(stats.get('noofhfs')));
                System.debug(stats.get('noofhfs'));
            }
            System.debug(interimResult);
            
            for (Zip_Code__C zip : allZipWithADInfo){
                System.debug(zip.zip_code__C+'-'+zip.Area__r.Area_Director__r.Contact.Id);
                if (interimResult.containsKey(zip.zip_code__C+'-'+zip.Area__r.Area_Director__r.Contact.Id)){
                    zipCodeToHF.put(zip.zip_code__C,interimResult.get(zip.zip_code__C+'-'+zip.Area__r.Area_Director__r.Contact.Id));
                }
                else{
                    zipCodeToHF.put(zip.zip_code__C,'0');
                }
            }       
            
            
          newAreaZipList = new List<geoNewAreaZipsWrapperClass>();
          selZipNames = new Set<Id>();

          for(Zip_Code__c a : allZipWithADInfo){
               newAreaZipList.add(new geoNewAreaZipsWrapperClass(a));
          }
          
                                       
        }       
     }
     
     public void displaySelectedZipCodes(){
          selZipNames.clear();
          hasSelZip = false;
          for(geoNewAreaZipsWrapperClass cWrapper : newAreaZipList){
               if(cWrapper.isSelected){
                    hasSelZip = true;
                    selZipNames.add(cWrapper.cZipCode.Id);
               }
          }
     }
     
     public PageReference createNewAreaFromSelectedZipCodes(){
          selZipNames.clear();
          hasSelZip = false;
          for(geoNewAreaZipsWrapperClass cWrapper : newAreaZipList){
               if(cWrapper.isSelected){
                    hasSelZip = true;
                    selZipNames.add(cWrapper.cZipCode.Id);
               }
          }
          PageReference p = new PageReference('/apex/geoNewAreaCreation?Id='+area.Id+'&checkedZips='+selZipNames);
          p.setRedirect(true);
          return p;
     }
     
     public PageReference SaveNewArea(){
       Area__c newArea = new Area__c();
       if(newAreaName!=null && newAreaName!='' && OldArea!=null){         
         newArea.Name = newAreaName;         
         if(OldArea.Area_Director__c!=null)
           newArea.Area_Director__c = OldArea.Area_Director__c;
         if(OldArea.Regional_Manager__c!=null)
           newArea.Regional_Manager__c = OldArea.Regional_Manager__c;
         if(OldArea.Region_Name__c!=null)
           newArea.Region_Name__c = OldArea.Region_Name__c;
         if(OldArea.Assignment_Type__c!=null)
           newArea.Assignment_Type__c = OldArea.Assignment_Type__c;
         try{
           insert newArea;
           System.debug('NEW AREA---->'+newArea.Id);
           System.debug('NEW AREA selectedZipIds---->'+selectedZipIds);
           //update the zips to the new area. selectedZipIds
           if(selectedZipIds!=null){
             selectedZipIds = selectedZipIds.replace('{',' ');
             selectedZipIds = selectedZipIds.replace('}',' ');
             
             System.debug('NEW AREA selectedZipIds replaced---->'+selectedZipIds);
             string[] split = selectedZipIds.split(',');
             set<Id> zipIds = new Set<Id>();
             for(string s:split){
               s = s.trim();
               zipIds.add(s);               
             }
             System.debug('NEW AREA selectedZipIds split---->'+split);             
             System.debug('NEW AREA selectedZipIds zipIds---->'+zipIds);
             
             List<Zip_Code__c> zipCodesList = [SELECT Id,Area__c FROM Zip_Code__c WHERE Id IN:zipIds];
             System.debug('NEW AREA selectedZipIds zipCodesList size---->'+zipCodesList.size());
             if(zipCodesList!=null && zipCodesList.size()>0){
               for(Zip_Code__c zip : zipCodesList){
                 zip.Area__c = newArea.Id;
               }
           update zipCodesList;
             }
           }
         }
         catch(exception e){
           System.debug('EXCEPTION CREATING NEW AREA---->'+e);
         }
       }
       PageReference p;
       if(newArea.Id!=null)
         p = new PageReference('/apex/googleAreaVisualizer?id='+newArea.Id+'&type=areaVisualizer');
       p.setRedirect(true);
       return p;
     }
     
     public List<SelectOption> getAreaValues(){
        List<SelectOption> options = new List<SelectOption>();
        //if(allAreas!=null)
        options.add(new SelectOption('','None'));
        for (Area__c area : allAreas){
            //options.add(new SelectOption(area.Id,area.Name+'-'+area.Area_Director__r.Contact.Name));
            options.add(new SelectOption(area.Id,area.Name));
        }
        return options;
     }
     
     public String getAreas(){
        return areas;
     }
     public void setAreas(String areas){
        this.areas = areas;
     }
     
     public List<SelectOption> getAreaDirectorValues(){
        List<SelectOption> options = new List<SelectOption>();
        //if(allAreas!=null)
        options.add(new SelectOption('','None'));
        Map<String,String> areaDirectorName = new Map<String,String>();
        for (Area__c area : allAreas){
          if (!areaDirectorName.containsKey(area.Area_Director__r.Contact.Name)){
              options.add(new SelectOption(area.Area_Director__r.Contact.Name,area.Area_Director__r.Contact.Name));
              areaDirectorName.put(area.Area_Director__r.Contact.Name,'test');
          }
            //options.add(new SelectOption(area.Id,area.Area_Director__r.Contact.Name));
        }
        return options;
     }
     
     public String getAreaDirectors(){
        return areadirectors;
     }
     public void setAreaDirectors(String areadirectors){
        this.areadirectors = areadirectors;
     }
     
     public List<SelectOption> getAssignmentTypeValues(){
       List<SelectOption> options = new List<SelectOption>();
       options.add(new SelectOption('','None'));
       options.add(new SelectOption('Permanent','Permanent'));
       options.add(new SelectOption('Temporary','Temporary'));
       return options;
     }
     
     public String getAssignmentType(){
       return AssignmentType;
     }
     
     public void setAssignmentType(String AssignmentType){
       this.AssignmentType = AssignmentType;
     }
     
     public List<SelectOption> getADValues(){
        List<SelectOption> options = new List<SelectOption>();      
        
        //ADIds map(id,sobject)
        List<Contact> ADsList = [select Id,Name from contact where ownerId = :UserInfo.getUserId() AND Id !=: area.Area_Director__r.Contact.Id];
        
        for(Contact AD: ADsList){
            options.add(new SelectOption(AD.Id,AD.Name));
        }
             
        return options;
     }
     
     
     public String getADs(){
        return ADs;
     }
     public void setADs(String ADs){
        this.ADs = ADs;
     }
     
     public PageReference getZipCodeBoundaries(){
        Http h = new Http();
        HttpResponse res = new HttpResponse();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('http://api.reaperfire.com/reaperfire/rest/v1/public/boundary?zipcode='+zipCode.Zip_Code__c+'&format=geojson');
        req.setMethod('GET'); 
        //req.setBody('');
        String responseJson;
        
        try{
            res = h.send(req);
            responseJson = res.getBody();
            JSONParser parser = JSON.createParser(responseJson);
            //zipCode.Boundaries__c = JSON.serialize(responseJson);
            zipCode.Boundaries__c = responseJson;
            zipCode.Has_Boundaries__c = true;
        }
        catch (Exception e){
            zipCode.Boundaries__c = 'Error getting Boundary data'+e.getMessage();
        }
        
        update zipCode;
        PageReference zipCodePage = new ApexPages.StandardController(zipCode).view();
        zipCodePage.setRedirect(true);
        return zipCodePage;
     }
     /*
     public PageReference assignZipToNewArea(){
        System.debug(areas);
        Area__c newArea = new Area__c();
        List<Area__c> areasList = [select id,Area_Director__c from Area__c where id = :areas LIMIT 1];
        if(areasList!=null && areasList.size()>0){
            newArea = areasList[0];
        }
        //Query all the Host Families under this zip code/Area
        List<iGeoLocate__c> iGeoHfs = new List<iGeoLocate__c>();
        if(zipCode != null){
            iGeoHfs = [select Id,Account__c from iGeoLocate__c where Account__c in (select Id from Account where PersonMailingPostalCode = :zipCode.Zip_Code__c)];
        }
        else{
            //iGeo For the AREA AD
            iGeoForAD = [select id,Contact__r.Name,GeoAddress__Latitude__s,GeoAddress__Longitude__s from iGeoLocate__c where Contact__c = :area.Area_Director__r.Contact.Id];
             //Removed query filter and Has_Boundaries__c = true
            selectedZips = [select Zip_Code__c,Boundaries__c from Zip_Code__c where area__c = :area.id];
            List<String> zipCodes = new List<String>();
            Set<Id> hfAccIds = new Set<Id>();
            for (Zip_Code__c zip : selectedZips){
                zipCodes.add(zip.Zip_Code__c);
            }
            //All HF iGeos in a GeoMatch 
            //All GeoMatches for this AD and get their AccountID's
            List<GeoMatch__c> geoMatches = [select FromiGeoLocate__r.Account__c
                                                    from GeoMatch__c 
                                                    where 
                                                        FromiGeoLocate__r.Account__r.PersonMailingPostalCode in :zipCodes 
                                                        and 
                                                        ToiGeoLocate__c = :iGeoForAD.Id 
                                                        and 
                                                        Match_Status__c = 'Geo Matched'];
            for (GeoMatch__c geoMatch : geoMatches){
                hfAccIds.add(geoMatch.FromiGeoLocate__r.Account__c);
            }
            iGeoHfs =[select Id,Account__c from iGeoLocate__c where Account__c in :hfAccIds];
        }
        iGeoLocate__c newAdiGeo = [select Id from iGeoLocate__c where contact__c in (select contactid from user where id = :newArea.Area_Director__c )];
        System.debug(iGeoHfs);
        Set<Id> HfIds = new Map<Id,sObject>(iGeoHfs).KeySet();
        List<GeoMatch__c> HFsInGeoMatch = [select id,FromiGeoLocate__c from GeoMatch__c where FromiGeoLocate__c in :HfIds];
        Set<Id> HfIdsToBeRecomputed = new Set<Id>();
        for (GeoMatch__c HFInGeoMatch : HFsInGeoMatch){
            HfIdsToBeRecomputed.add(HFInGeoMatch.FromiGeoLocate__c);
        }
        googleGeoController.computeDistance1xn(newAdiGeo.Id,HfIdsToBeRecomputed,null,false);
        GeoMatch__c newGeoPreMatch = [select Id from GeoMatch__c where FromiGeoLocate__c = :newAdiGeo.Id and Match_Status__c = 'Geo PreMatch' order by createdDate desc limit 1];
        if(zipCode != null){
            newGeoPreMatch.Previous_Zip_Code__c = zipCode.Id;
        }
        else{
            newGeoPreMatch.Previous_Area__c = area.Id;
        }
        newGeoPreMatch.New_Area__c = newArea.Id;
        update newGeoPreMatch;
        
        
        //redirect to split page
        //PageReference newGeoPreMatchPage = new ApexPages.StandardController(newGeoPreMatch).view();
        PageReference newGeoPreMatchPage = new PageReference('/apex/geoReAssignConfirmation?id='+newGeoPreMatch.Id);
        //newGeoPreMatchPage.placeHolderGeoMatch = newGeoPreMatch;
        newGeoPreMatchPage.setRedirect(true);
        return newGeoPreMatchPage;
     }
     */
     //new method
     public PageReference assignZipToNewArea(){
        System.debug('selected area-->'+areas);
        System.debug('selected area director-->'+ADs);
        //new area is for zip reassignment only. not for area reassignment.
        
        //Query all the Host Families under this zip code/Area
        List<iGeoLocate__c> iGeoHfs = new List<iGeoLocate__c>();
        Area__c newArea = new Area__c();
        iGeoLocate__c newAdiGeo;
        
        if(zipCode != null){
            iGeoHfs = [select Id,Account__c from iGeoLocate__c where Account__c in (select Id from Account where PersonMailingPostalCode = :zipCode.Zip_Code__c)];          
            List<Area__c> areasList = [select id,Area_Director__c from Area__c where id = :areas LIMIT 1];
            if(areasList!=null && areasList.size()>0){
                newArea = areasList[0];
            }
            newAdiGeo = [select Id from iGeoLocate__c where contact__c in (select contactid from user where id = :newArea.Area_Director__c )];
        }
        else{
            //for Area reassignment. Just change the Area's AD to new AD!
            //iGeo For the AREA AD
            iGeoForAD = [select id,Contact__r.Name,GeoAddress__Latitude__s,GeoAddress__Longitude__s from iGeoLocate__c where Contact__c = :area.Area_Director__r.Contact.Id];
             //Removed query filter and Has_Boundaries__c = true
            selectedZips = [select Zip_Code__c,Boundaries__c from Zip_Code__c where area__c = :area.id];
            List<String> zipCodes = new List<String>();
            Set<Id> hfAccIds = new Set<Id>();
            for (Zip_Code__c zip : selectedZips){
                zipCodes.add(zip.Zip_Code__c);
            }
            //All HF iGeos in a GeoMatch 
            //All GeoMatches for this AD and get their AccountID's
            List<GeoMatch__c> geoMatches = [select FromiGeoLocate__r.Account__c
                                                    from GeoMatch__c 
                                                    where 
                                                        FromiGeoLocate__r.Account__r.PersonMailingPostalCode in :zipCodes 
                                                        and 
                                                        ToiGeoLocate__c = :iGeoForAD.Id 
                                                        and 
                                                        Match_Status__c = 'Geo Matched'];
            for (GeoMatch__c geoMatch : geoMatches){
                hfAccIds.add(geoMatch.FromiGeoLocate__r.Account__c);
            }
            iGeoHfs =[select Id,Account__c from iGeoLocate__c where Account__c in :hfAccIds];
            newAdiGeo = [select Id from iGeoLocate__c where contact__c =: ADs];
        }
        //iGeoLocate__c newAdiGeo = [select Id from iGeoLocate__c where contact__c in (select contactid from user where id = :newArea.Area_Director__c )];
        System.debug(iGeoHfs);
        Set<Id> HfIds = new Map<Id,sObject>(iGeoHfs).KeySet();
        List<GeoMatch__c> HFsInGeoMatch = [select id,FromiGeoLocate__c from GeoMatch__c where FromiGeoLocate__c in :HfIds];
        Set<Id> HfIdsToBeRecomputed = new Set<Id>();
        for (GeoMatch__c HFInGeoMatch : HFsInGeoMatch){
            HfIdsToBeRecomputed.add(HFInGeoMatch.FromiGeoLocate__c);
        }
        googleGeoController.computeDistance1xn(newAdiGeo.Id,HfIdsToBeRecomputed,null,null,false);
        GeoMatch__c newGeoPreMatch = [select Id from GeoMatch__c where FromiGeoLocate__c = :newAdiGeo.Id and Match_Status__c = 'Geo PreMatch' order by createdDate desc limit 1];
        if(zipCode != null){
            newGeoPreMatch.Previous_Zip_Code__c = zipCode.Id;
            newGeoPreMatch.New_Area__c = newArea.Id;
        }
        else{
            newGeoPreMatch.Previous_Area__c = area.Id;
            newGeoPreMatch.New_AD__c = ADs;
            newGeoPreMatch.Assignment_Type__c = assignmentType;
        }
        
        update newGeoPreMatch;
        
        /*ApexPages.currentPage().setRedirect(true);
        return ApexPages.currentPage();*/
        
        //redirect to split page
        //PageReference newGeoPreMatchPage = new ApexPages.StandardController(newGeoPreMatch).view();
        PageReference newGeoPreMatchPage = new PageReference('/apex/geoReAssignConfirmation?id='+newGeoPreMatch.Id);
        //newGeoPreMatchPage.placeHolderGeoMatch = newGeoPreMatch;
        newGeoPreMatchPage.setRedirect(true);
        return newGeoPreMatchPage;
     }
     
     public PageReference createNewZipForAreaAssociation(){
        System.debug('ENTERED NEW ZIP CREATION SINGLE----->');
        if (newZipCodeValue != null){
          System.debug('ENTERED NEW ZIP CREATION SINGLE----->'+newZipCodeValue);
            Zip_Code__c newZipCode = new Zip_Code__c();
            newZipCode.zip_code__c = newZipCodeValue;
            System.debug('newZipCodeValue'+newZipCodeValue);                        
            for (geoNewZipWrapperInner noADZip : noADZips){
                System.debug(noADZip);
                if (noADZip.newZipCode == newZipCodeValue){
                    newZipCode.Area__c = noADZip.areas;
                    newZipCode.State__c = noADZip.ADState;
                }
            }
            newZipCode.Name = 'Z-'+newZipCodeValue;
            //newZipCode.State__c = 'CA';
            System.debug('Zip Code(s) to be inserted'+newZipCode);
            insert newZipCode;
            iGeoLocate__c iGeoForZipCodeNew = new iGeoLocate__c();
            iGeoForZipCodeNew.Zip_Code__c = newZipCode.Id;
            insert iGeoForZipCodeNew;
        }
        /*else{
          System.debug('ENTERED NEW ZIP CREATION MULTIPLE----->');
            List<Zip_Code__c> newzipCodeList = new List<Zip_Code__c>();
            List<iGeoLocate__c> iGeoForZipCodeNewList = new List<iGeoLocate__c>();
            
            for (geoNewZipWrapperInner noADZip : noADZips){
                Zip_Code__c newZipCode = new Zip_Code__c();
                newZipCode.zip_code__c = noADZip.newZipCode;
                newZipCode.Area__c = noADZip.areas;
                newZipCode.State__c = noADZip.ADState;
                newZipCode.Name = 'Z-'+noADZip.newZipCode;
                newzipCodeList.add(newZipCode);
            }
            System.debug('Zip Code(s) to be inserted'+newzipCodeList);
            insert newzipCodeList;
            for (Zip_Code__c newZipCode : newzipCodeList){
                iGeoLocate__c iGeoForZipCodeNew = new iGeoLocate__c();
                iGeoForZipCodeNew.Zip_Code__c = newZipCode.Id;
                iGeoForZipCodeNewList.add(iGeoForZipCodeNew);
            }
            insert iGeoForZipCodeNewList;
        }
        */
        PageReference geoZipCodesTabPage = Page.geoZipCodesTab;
        geoZipCodesTabPage.setRedirect(true);
        return geoZipCodesTabPage;
     }

     
     //Not Needed for V1 launch
     public PageReference doReassignments(){
        googleGeoController geoC = new googleGeoController();
        //geoC.
        List<GeoMatch__c> reAssignedHFsWithNewZipAD = new List<GeoMatch__c>();
        Integer spawnedGeoMatches = 0;
        placeHolderGeoMatch = [select Previous_Zip_Code__c,Previous_Zip_Code__r.Zip_Code__c,serializedMatchMatrix__c,New_Area__c from geoMatch__c where id = :ApexPages.currentPage().getParameters().get('Id')];   
        odGroup = (Map<Id,List<googleGeoDistanceMatrixElementOneD>>)JSON.deserialize(placeHolderGeoMatch.serializedMatchMatrix__c,Map<Id,List<googleGeoDistanceMatrixElementOneD>>.class);
        for (Id fromiGeoId : odGroup.KeySet()){
            spawnedGeoMatches = 0;
            for (googleGeoDistanceMatrixElementOneD gOneD : odGroup.get(fromiGeoId)){
                if (gOneD.pairingStatus == 'Compatible'){
                    //If a reassignment is compatible, create a new GeoMatch
                    GeoMatch__c aNewADHFAssignment = new GeoMatch__c();
                    aNewADHFAssignment.ToiGeoLocate__c = fromiGeoId;
                    aNewADHFAssignment.FromiGeoLocate__c = gOneD.toGeo.Id;
                    aNewADHFAssignment.Placeholder_GeoMatch__c = placeHolderGeoMatch.Id;
                    Map<Id,List<googleGeoDistanceMatrixElementOneD>> onePairMatrix = new Map<Id,List<googleGeoDistanceMatrixElementOneD>>();
                    onePairMatrix.put(fromiGeoId,new List<googleGeoDistanceMatrixElementOneD>());
                    onePairMatrix.get(fromiGeoId).add(gOneD);
                    aNewADHFAssignment.serializedMatchMatrix__c = JSON.serialize(onePairMatrix);
                    aNewADHFAssignment.Match_Status__c = 'Geo Matched';
                    reAssignedHFsWithNewZipAD.add(aNewADHFAssignment);
                    //Gather the old matches - The GeoMatch with the earlier ZipCode's AD
                    gOneD.pairingStatus = 'Compatible-Spawned';
                }
                else if (gOneD.pairingStatus == 'Compatible-Spawned'){
                    spawnedGeoMatches++;
                }
            }
            if (odGroup.get(fromiGeoId).size() == spawnedGeoMatches){
                ApexPages.Message alreadySpawned = new ApexPages.Message(ApexPages.severity.ERROR, 'Already Spawned');
                ApexPages.addMessage(alreadySpawned);
                return null;
            }
        }
        placeHolderGeoMatch.serializedMatchMatrix__c = JSON.serialize(odGroup);
        
        System.debug(reAssignedHFsWithNewZipAD);
        List<GeoMatch__c> oldMatchesOfHFs;
        System.debug(placeHolderGeoMatch.Previous_Zip_Code__r.Zip_Code__c);
        List<Account> HFAccounts = [select Id from Account where PersonMailingPostalCode = :placeHolderGeoMatch.Previous_Zip_Code__r.Zip_Code__c];
        Set<Id> HFAccs = (new Map<Id,Account>(HFAccounts)).keySet();
        
        oldMatchesOfHFs = [select id from GeoMatch__c where FromiGeoLocate__c in (select id from iGeoLocate__c where Account__c in :HFAccs)];
        System.debug(oldMatchesOfHFs);
        for (GeoMatch__c oldHFGeoMatch : oldMatchesOfHFs){
            oldHFGeoMatch.Match_Status__c = 'Geo Invalidated';
        }
        update oldMatchesOfHFs;
        insert reAssignedHFsWithNewZipAD;
        update placeHolderGeoMatch;
        Area__c newArea = [select Id from Area__c where Id=:placeHolderGeoMatch.New_Area__c];
        Zip_Code__c zipCode = [select Id,Area__c from Zip_Code__c where Id = :placeHolderGeoMatch.Previous_Zip_Code__c];
        zipCode.Area__c = newArea.Id;
        update zipCode;
        //PageReference newAreaPage = new ApexPages.StandardController(newArea).view();
        PageReference newAreaPage = Page.googleZipVisualizer;
        newAreaPage.getParameters().put('id',placeHolderGeoMatch.Previous_Zip_Code__c);
        newAreaPage.setRedirect(true);
        return newAreaPage;
     }
     
     public PageReference returnBackToPreGeoMatch(){
        PageReference goBackToGeoPreMatch = new ApexPages.StandardController(placeHolderGeoMatch).view();
        goBackToGeoPreMatch.setRedirect(true);
        return goBackToGeoPreMatch;
     }
     
     public PageReference redirectTo1xn(){
        PageReference matchPage = Page.googleGeoDistanceVisualizer1xn;
        //matchPage.getParameters().put('goBackTo','sGeoMatch');
        if (geoMatches!=null && geoMatches.size() > 0){
            matchPage.getParameters().put('id', geoMatches[0].Id);
            return matchPage;
        }
        else{
            return null;
        }
        
     }
     
     public PageReference justGoBackToHFAccount(){
        PageReference HFAccountPage = new ApexPages.StandardController(HFAccount).view();
        HFAccountPage.setRedirect(true);
        return HFAccountPage;
    }
    
    public void filterResults(){
        doAllStatQuerying();
        //noADZip.put(searchZipCode,'0');
    }
    
    public void resetAndFilter(){
      endRow = recordsPerPage;
        doAllStatQuerying();
    }
    
    public void populateAreasAndZipCount(){
      List<AggregateResult> allAreasZipsCount = [select Area__r.Name areaName,count(zip_code__c) noOfZips from zip_Code__c group by Area__r.Name];
      for (AggregateResult areaZipsCount : allAreasZipsCount){
        areasAndZipCount.put(String.Valueof(areaZipsCount.get('areaName')),String.Valueof(areaZipsCount.get('noOfZips')));
      }
    }
   
public class geoAreaWrapperInner {//implements Comparable{
    public Area__c area {get;set;}  
    public Id areaId{get;set;}
    public Integer noOfHFs{get;set;}
    public Integer noOfZips{get;set;}
    public String AreaName{get;set;}
    public String ADName{get;set;}
    public String RM{get;set;}
    public googleGeoHelper myMaster{get;set;}
    
    public geoAreaWrapperInner(googleGeoHelper theMaster){
        area = null;
        areaId = null;
        noOfHFs = 0;
        AreaName = '';
        ADName = '';
        RM = '';
        noOfZips = 0;
        myMaster = theMaster;
    }
    
    
    public void populateNoOfZips(){
        //List<Zip_Code__c> zips = [select Id from Zip_Code__c where Area__c = :areaId];
        //noOfZips = zips.size();
        noOfZips = Integer.valueOf(myMaster.areasAndZipCount.get(AreaName));
    }    
    
    /*public Integer compareTo(Object objToCompare) {
      //Sort by ADName Alphabetically
        //return ADName.compareTo(((geoAreaWrapperInner)objToCompare).ADName);
        
        geoAreaWrapperInner that = (geoAreaWrapperInner)objToCompare;
      Integer c = this.ADName.compareTo(that.ADName);
      if (c != 0) {
          return c;
      } else {
          return this.AreaName.compareTo(that.AreaName);
      }
    }*/
      
}

public class geoZipWrapperInner {
  public zip_Code__c theZip {get;set;}
  
  public geoZipWrapperInner(){
    theZip = null;
  }
}

public class pageDetail{
  public Integer pageNum{get;set;}
  public Integer startRow{get;set;}
  public Integer endRow{get;set;}
  
  public pageDetail(){
    pageNum = 1;
    startRow = 1;
    endRow = 5;
  }
}

public void loadAreaDetails(){
  List<Area__c> allAreas = [select Area_Director__r.ContactId, Name, Area_Director__r.Contact.MailingState, Area_Director__r.Contact.Name from Area__c where Area_Director__c in (select Id from user where profile.Name = 'APC AD PC')];
  for (Area__c area : allAreas){
    if (!areaDetails.containsKey(area.Area_Director__r.ContactId)){
      areaDetails.put(area.Area_Director__r.ContactId,new List<Area__c>());
      areaDetails.get(area.Area_Director__r.ContactId).add(area);
    }
    else{
      areaDetails.get(area.Area_Director__r.ContactId).add(area);
    }
    System.debug(areaDetails);
  }
}

public class geoNewZipWrapperInner {
    
    public String newZipCode {get;set;}
    public Id associatedADId {get;set;}
    public Contact associatedAD {get;set;}
    public List<Area__c> associatedAreas {get;set;}
    public Zip_Code__c newZipCodeRec {get;set;}
    public Integer HFCount {get;set;}
    public String areas {get;set;}
    public String ADState {get;set;}
    public googleGeoHelper myMaster{get;set;}
    
    public geoNewZipWrapperInner(googleGeoHelper theMaster){
        newZipCode = '';
        associatedAD = null;
        associatedAreas = new List<Area__c>();
        newZipCodeRec = null;
        HFCount = 0;
        associatedADId = null;
        areas = '';
        ADState = '';
        myMaster = theMaster;
    }
    
    public void queryAreasAssociatedWithAD(){
      System.debug('Getting details for AD:'+associatedADId);
      for (Contact adContact : myMaster.allADContacts){
        if (adContact.Id == associatedADId){
          associatedAD = adContact;
          ADState = associatedAD.MailingState;
        }
      }
        //associatedAD = [select Id,Name,MailingState from contact where Id = :associatedADId];
        //ADState = associatedAD.MailingState;
        //User ADUser = [select Id from User where contactid = :associatedADId];
        //associatedAreas = [select Id,Name,Area_Director__r.Contact.Name from Area__c where Area_Director__c = :ADUser.Id];
        associatedAreas = myMaster.areaDetails.get(associatedADId);
        System.debug('Associated Areas'+associatedAreas);
    }  
    
    public List<SelectOption> getAreaValues(){
        List<SelectOption> options = new List<SelectOption>();
        if (associatedAreas!=null){
          for (Area__c area : associatedAreas){
              options.add(new SelectOption(area.Id,area.Name));
          }
        }
        return options;
     }
     
     public String getAreas(){
        return areas;
     }
     public void setAreas(String areas){
        this.areas = areas;
     }  
     
}
}