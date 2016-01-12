public without sharing class AyusaAssignValidatorController {
Position__c position;
Position__c pos;
public Match__c match{get;set;}
public Match__c objmatch{get;set;}
List<Contact> lstProbableContacts;
Contact Validator;
iGeolocate__c objiGeolocate;
iGeolocate__c FrmObjiGeolocate;
List<iGeolocate__c> ToObjiGeolocate;
List<iGeolocate__c> ToNewObjiGeolocate;
List<iGeoLocate__c> lstiGeolocateComReps = new List<iGeoLocate__c>();
List<GeoMatch__c> lstGeoMatch = new List<GeoMatch__c>();
List<GeoMatch__c> lstExistingGeoMatch = new List<GeoMatch__c>();
public List<GeoMatch__c> lstTopGeoMatches;
 public List<GeoMatchWrapper> lstGeoMatchWrapper;
public string AccountName;
public List<GeoMatch__c> lstNearestGeoMatches = new List<GeoMatch__c>();
iGeolocate__c ObjCallingService;
String SOQLQuery;
public static boolean isTest=false;
  public string  selected{get;set{
        selected = value;
        }
    }

      public AyusaAssignValidatorController(ApexPages.StandardController controller) {
        
                 //Get match Id
            objmatch = (Match__c)controller.getRecord();
            match = [Select  m.Validator__c,m.validator__r.name, m.Status__c,m.Position_Name__c, m.Participant_Opportunity_Id__c, m.Name, m.Match_Type__c From Match__c m where m.Id =:objmatch.Id  limit 1];
             system.debug('***match*****'+match);
          
       }
       public pagereference FetchValidators()
       {
            if(isTest)
        iGeoLocateTriggerHelper.isTest=true;
        FindGelocates();      
        return null;
       }
    
        public void FindGelocates()
       {
        SOQLQuery = 'select i.Position__c, i.OwnerId, i.Id, i.GeoAddress__Longitude__s, i.GeoAddress__Latitude__s, '
                        + ' i.Contact__r.Status__c, i.Contact__r.Intrax_Programs__c, i.Contact__r.OwnerId,i.Position__r.name, ' +
                        + ' i.Contact__c, i.Account__r.PersonMailingCountry, i.Account__r.PersonMailingPostalCode, i.Account__r.PersonMailingState, i.Account__r.PersonMailingCity, i.Account__r.PersonMailingStreet, i.Account__r.Type, i.Account__r.Name, i.Account__c From iGeoLocate__c i ' +
                        + ' where  i.Position__c = ' + '\'' + match.Position_Name__c  + '\' Limit 1' ;
         pos= [Select p.sAccount__c, p.Street__c, p.State__c, p.Regional_Location__c,p.Owner.Id, p.RecordTypeId, p.Postal_Code__c, p.Position_Types__c, p.Name, p.LastModifiedDate, p.Id, p.Description__c, p.CurrencyIsoCode, p.Country__c, p.Countries_of_Interest__c, p.Compensation_Type__c, p.City__c From Position__c p where id=:match.Position_Name__c ];
      
       
        FrmObjiGeolocate = Database.query(SOQLQuery);   
         system.debug('***FrmObjiGeolocate *****'+FrmObjiGeolocate );          
        
        
        List<User> UsrContact = new list<User>();
        set<id> UserContactId= new set<id>();
       
        SOQLQuery = 'Select u.Id, u.ContactId From User u where id='  + '\'' + pos.Owner.Id  + '\' Limit 1';
        UsrContact = Database.query(SOQLQuery);
        If(UsrContact!=null && UsrContact.size()>0)
        {
            UserContactId.add(UsrContact[0].ContactId);
            system.debug('***ContactId****'+UserContactId );
        }
        
        //Added by Saroj (Start)
        list<GeoMatch__c> selexistContact = [SELECT ToiGeoLocate__r.contact__c FROM GeoMatch__c WHERE FromiGeoLocate__c =: FrmObjiGeolocate.Id];
        set<id> lstExistingContacthIds = new set<id>();
        
        if(selexistContact != NULL && selexistContact.size() >0)
        {
        	for(GeoMatch__c singlegeoMatch :selexistContact)
        	{
        		lstExistingContacthIds.add(singlegeoMatch.ToiGeoLocate__r.contact__c);
        	}
        }
        
        if(lstExistingContacthIds != NULL && lstExistingContacthIds.size()>0)
        {            
        	SOQLQuery = 'select i.Position__c, i.OwnerId, i.Id, i.GeoAddress__Longitude__s, i.GeoAddress__Latitude__s, '
                        + ' i.Contact__r.Status__c, i.Account__r.PersonMailingCountry, i.Account__r.PersonMailingPostalCode, i.Account__r.PersonMailingState, i.Account__r.PersonMailingCity, i.Account__r.PersonMailingStreet, i.Account__r.Type, i.Account__r.Name, i.Account__c, i.Contact__r.Intrax_Programs__c, i.Contact__r.OwnerId, ' +
                        + ' i.Contact__c, i.Contact__r.Name From iGeoLocate__c i ' +
                         + ' where  i.Contact__c !=null and i.Contact__c not in :UserContactId ' +
                         + ' and Contact__r.Title = ' + '\'' + 'Community Representative' + '\'' +
                         + ' and i.Contact__c NOT IN :lstExistingContacthIds';
        }
        else
        {
        	SOQLQuery = 'select i.Position__c, i.OwnerId, i.Id, i.GeoAddress__Longitude__s, i.GeoAddress__Latitude__s, '
                        + ' i.Contact__r.Status__c, i.Account__r.PersonMailingCountry, i.Account__r.PersonMailingPostalCode, i.Account__r.PersonMailingState, i.Account__r.PersonMailingCity, i.Account__r.PersonMailingStreet, i.Account__r.Type, i.Account__r.Name, i.Account__c, i.Contact__r.Intrax_Programs__c, i.Contact__r.OwnerId, ' +
                        + ' i.Contact__c, i.Contact__r.Name From iGeoLocate__c i ' +
                         + ' where  i.Contact__c !=null and i.Contact__c not in :UserContactId ' +
                         + ' and Contact__r.Title = ' + '\'' + 'Community Representative' + '\'' ;
        }
        //Added by Saroj (End)                      
                               
        ToObjiGeolocate = Database.query(SOQLQuery);
          system.debug('***ToObjiGeolocate *****'+ToObjiGeolocate ); 
        set<id> ToiGeolocateIds = new set<id>();
      
            if(ToObjiGeolocate!=null && ToObjiGeolocate.size()>0)
            {
            for(iGeoLocate__c tempgeoloc : ToObjiGeolocate)
            {            
            ToiGeolocateIds.add(tempgeoloc.Contact__c);
            }
            }
        system.debug('****ToiGeolocateIds******'+ToiGeolocateIds);
        system.debug('****ToiGeolocateIds size******'+ToiGeolocateIds.size());
         
        
        if(ToObjiGeolocate!=null && FrmObjiGeolocate!=null)
        {
        	//Commented by Saroj (Start)
           /* SOQLQuery = 'select g.ToiGeoLocate__c,g.ToiGeoLocate__r.contact__c, g.ToGeoAddress__Longitude__s, g.ToGeoAddress__Latitude__s, g.SystemModstamp, g.Status__c, g.OwnerId, g.Name, g.LinearDistanceInMiles__c, g.LinearDistanceInKms__c, g.LastModifiedDate, g.LastModifiedById, g.LastActivityDate, g.IsDeleted, g.Id, g.FromiGeoLocate__c, g.FromGeoAddress__Longitude__s, g.FromGeoAddress__Latitude__s,' +
            +' g.CurrencyIsoCode, g.CreatedDate, g.CreatedById, g.ConnectionSentId, g.ConnectionReceivedId From GeoMatch__c g ' +
            + ' where g.FromiGeoLocate__c = ' + '\'' + FrmObjiGeolocate.Id  + '\' ';
           
          lstExistingGeoMatch = Database.query(SOQLQuery);  
           system.debug('***lstExistingGeoMatch *****'+lstExistingGeoMatch ); 
        
           set<id> lstExistingGeoMatchIds = new set<id>();
           set<id> lstNotExistingGeoMatchIds = new set<id>();
          
      
            if(lstExistingGeoMatch!=null && lstExistingGeoMatch.size()>0)
            {
                 for(GeoMatch__c tempgeomat : lstExistingGeoMatch)
                {                
                    for(Id tempigeo : ToiGeolocateIds)  
                    {
                    if(tempgeomat.ToiGeoLocate__r.contact__c == tempigeo)  
                    {                    
                    lstExistingGeoMatchIds.add(tempgeomat.ToiGeoLocate__r.contact__c);
                    }            
                    }
                }
                  system.debug('***ToiGeolocateIds*****'+ToiGeolocateIds); 
            system.debug('***lstExistingGeoMatchIds*****'+lstExistingGeoMatchIds); 
               for(Id tempigeo : ToiGeolocateIds)
                {  
                boolean ContExists = false;               
                    for(GeoMatch__c tempgeomat : lstExistingGeoMatch)  
                    {                    
                    system.debug('***tempigeo *****'+tempigeo ); 
                    if(tempgeomat.ToiGeoLocate__r.contact__c == tempigeo && tempgeomat.ToiGeoLocate__r.Contact__c!=null)  
                    {
                    ContExists = true; 
                    system.debug('***tempgeomat.ToiGeoLocate__r.contact__c*****'+tempgeomat.ToiGeoLocate__r.contact__c);                  
                   // lstNotExistingGeoMatchIds.add(tempgeomat.ToiGeoLocate__r.Contact__c);
                  
                    }            
                    }
                    if(!ContExists) 
                    lstNotExistingGeoMatchIds.add(tempigeo);
                }
         system.debug('***ToiGeolocateIds*****'+ToiGeolocateIds); 
            system.debug('***lstNotExistingGeoMatchIds*****'+lstNotExistingGeoMatchIds); 
                SOQLQuery = 'select i.Position__c, i.OwnerId, i.Id, i.GeoAddress__Longitude__s, i.GeoAddress__Latitude__s, '
                          + ' i.Contact__r.Status__c, i.Account__r.PersonMailingCountry, i.Account__r.PersonMailingPostalCode, i.Account__r.PersonMailingState, i.Account__r.PersonMailingCity, i.Account__r.PersonMailingStreet, i.Account__r.Type, i.Account__r.Name, i.Account__c, i.Contact__r.Intrax_Programs__c, i.Contact__r.OwnerId, ' +
                          + ' i.Contact__c, i.Contact__r.Name From iGeoLocate__c i ' +
                          + ' where  i.Contact__c in :lstNotExistingGeoMatchIds ' ;                              
                                       
                ToNewObjiGeolocate = Database.query(SOQLQuery);
                
                 system.debug('***ToNewObjiGeolocate *****'+ToNewObjiGeolocate ); 
            
             if(ToNewObjiGeolocate!=null && ToNewObjiGeolocate.size()>0)
            {  
                For(iGeoLocate__c objGeoLoc : ToNewObjiGeolocate)
                {  
                GeoMatch__c objGeoMatch = new GeoMatch__c();
                objGeoMatch.FromGeoAddress__Latitude__s = FrmObjiGeolocate.GeoAddress__Latitude__s;
                objGeoMatch.FromGeoAddress__Longitude__s = FrmObjiGeolocate.GeoAddress__Longitude__s;     
                objGeoMatch.ToGeoAddress__Latitude__s = objGeoLoc.GeoAddress__Latitude__s;
                objGeoMatch.ToGeoAddress__Longitude__s = objGeoLoc.GeoAddress__Longitude__s;
                objGeoMatch.FromiGeoLocate__c = FrmObjiGeolocate.Id;
                objGeoMatch.ToiGeoLocate__c = objGeoLoc.Id;
                objGeoMatch.Name =  FrmObjiGeolocate.Position__r.name + ' to ' + objGeoLoc.Contact__r.Name + '_Match';
                lstGeoMatch.add(objGeoMatch);
                }
            }
            }
           else         
            {
                 For(iGeoLocate__c objGeoLoc : ToObjiGeolocate)
                {  
                GeoMatch__c objGeoMatch = new GeoMatch__c();
                objGeoMatch.FromGeoAddress__Latitude__s = FrmObjiGeolocate.GeoAddress__Latitude__s;
                objGeoMatch.FromGeoAddress__Longitude__s = FrmObjiGeolocate.GeoAddress__Longitude__s;     
                objGeoMatch.ToGeoAddress__Latitude__s = objGeoLoc.GeoAddress__Latitude__s;
                objGeoMatch.ToGeoAddress__Longitude__s = objGeoLoc.GeoAddress__Longitude__s;
                objGeoMatch.FromiGeoLocate__c = FrmObjiGeolocate.Id;
                objGeoMatch.ToiGeoLocate__c = objGeoLoc.Id;
                objGeoMatch.Name =  FrmObjiGeolocate.Position__r.name + ' to ' + objGeoLoc.Contact__r.Name + '_Match';
                lstGeoMatch.add(objGeoMatch);   
                }   
            }
            */
            //Commented by Saroj (End)
            For(iGeoLocate__c objGeoLoc : ToObjiGeolocate)
            {  
                GeoMatch__c objGeoMatch = new GeoMatch__c();
                objGeoMatch.FromGeoAddress__Latitude__s = FrmObjiGeolocate.GeoAddress__Latitude__s;
                objGeoMatch.FromGeoAddress__Longitude__s = FrmObjiGeolocate.GeoAddress__Longitude__s;     
                objGeoMatch.ToGeoAddress__Latitude__s = objGeoLoc.GeoAddress__Latitude__s;
                objGeoMatch.ToGeoAddress__Longitude__s = objGeoLoc.GeoAddress__Longitude__s;
                objGeoMatch.FromiGeoLocate__c = FrmObjiGeolocate.Id;
                objGeoMatch.ToiGeoLocate__c = objGeoLoc.Id;
                objGeoMatch.Name =  FrmObjiGeolocate.Position__r.name + ' to ' + objGeoLoc.Contact__r.Name + '_Match';
                lstGeoMatch.add(objGeoMatch);   
            }  
        }
        if(lstGeoMatch.size()>0)
          insert lstGeoMatch;
            system.debug('***lstGeoMatch*****'+lstGeoMatch);
       }
       
        public List<GeoMatchWrapper> getlstGeoMatchWrapper() 
       {
       		//AY2 776 - Added Contact status check in WHERE condition
            SOQLQuery = 'Select g.ToGeoAddress__Longitude__s, g.ToiGeoLocate__r.Contact__c,g.ToGeoAddress__Latitude__s, g.Status__c, g.LinearDistanceInMiles__c,g.DistanceInMiles__c, g.DistanceInKms__c, g.LinearDistanceInKms__c, g.LastModifiedDate,' +
                        + ' g.Id, g.FromGeoAddress__Longitude__s, g.FromGeoAddress__Latitude__s, g.CreatedDate From GeoMatch__c g where g.FromiGeoLocate__c = ' + '\'' + FrmObjiGeolocate.Id  + '\' and g.DistanceInMiles__c !=null and g.DistanceInKms__c!=null and g.ToiGeoLocate__r.Contact__r.Status__c != ' + '\'' + 'Inactive' + '\' order by g.DistanceInMiles__c asc limit 5 ';
            lstNearestGeoMatches = Database.query(SOQLQuery);
            lstGeoMatchWrapper = new List<GeoMatchWrapper>();
            if(lstNearestGeoMatches.Size()>0)
             {           
                 for (GeoMatch__c objGeoMatch : lstNearestGeoMatches)
                 {
                    GeoMatchWrapper ObjGeoMatchWrapper = new GeoMatchWrapper(objGeoMatch);
                    ObjGeoMatchWrapper.GeoMatchId = objGeoMatch.Id; 
                      ObjGeoMatchWrapper.ValidatorId = objGeoMatch.ToiGeoLocate__r.Contact__c; 
                    ObjGeoMatchWrapper.strValidatorName = GetContactName(objGeoMatch.ToiGeoLocate__r.Contact__c);
                    ObjGeoMatchWrapper.DistanceInMiles =  objGeoMatch.DistanceInMiles__c;
                    system.debug('******MatchWrapper******8');
                      ObjGeoMatchWrapper.meet=objGeoMatch;
                      Id selectedId=GetSelectedValidator();
                       system.debug('******** selectedId********'+ selectedId);
                    if(selectedId!=null && selectedId ==  ObjGeoMatchWrapper.ValidatorId)
                      ObjGeoMatchWrapper.SelectedValidator=true;
                      system.debug('********* ObjGeoMatchWrapper.SelectedValidator=true;********'+ ObjGeoMatchWrapper.SelectedValidator);
                    system.debug('********  ObjGeoMatchWrapper.ValidatorId********'+  ObjGeoMatchWrapper.ValidatorId);
                    lstGeoMatchWrapper.add(ObjGeoMatchWrapper);
                    
                   // intCount = ObjMatchWrapper.Counter;
                 }
             }
         
           
            return lstGeoMatchWrapper;
       }
       public string GetContactName(Id ContactId)
       {
        List<Contact> lstContact;
        String contactName;
        If(ContactId!=null)
        {
        lstContact =[Select name from contact where id=:ContactId limit 1];
        contactName = lstContact[0].Name;
        }
        return contactName;
       }
        public Id GetSelectedValidator()
       {
        List<Contact> lstContact;
        Id contactId=null;
        system.debug('*****match.validator__c********'+match.validator__c);
        If(match.validator__c!=null)
        {
        lstContact =[Select id,name from contact where id=:match.validator__c limit 1];
       system.debug('*****lstContact********'+lstContact);
        contactId = lstContact[0].Id;
         system.debug('*****contactId********'+contactId);
        }
        return contactId;
       }
       public PageReference Assign()
       {
         if(ApexPages.currentPage().getParameters().get('selected') != null)
         {
            string Id  =ApexPages.currentPage().getParameters().get('selected');  
            
                 system.debug('*********Id********'+Id); 
            SOQLQuery = 'Select c.Program_Role__c,  c.Owner.User_Interests__c, c.Owner.Name,' + 
                    + ' c.Owner.Username, c.Owner.Id, c.OwnerId, c.Name, c.MailingStreet, c.MailingState, c.MailingPostalCode, c.MailingCountry, c.MailingCity,' +
                    + ' c.LastName, c.Intrax_Programs__c, c.Id from contact c where c.id= ' + '\'' + Id  + '\' limit 1' ;
            Validator = Database.Query(SOQLQuery) ; 
             system.debug('*********Validator********'+Validator); 
            match.Validator__c = Validator.Id;
            update match;
           
                
         }
     
        return new PageReference('/' + match.Id);
       }
       public pagereference Cancel()
       {
         return new PageReference('/' + match.Id);
       }
      
    
       
      
     
     
}