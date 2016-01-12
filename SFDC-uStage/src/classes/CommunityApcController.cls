public without sharing class CommunityApcController {

//public variables in VFpages
public static Boolean isTestMode = false;
public Boolean docusignRefresh{get;set;}
public User user{get; set;}
public User userLog{get; set;}
public User_Profile__c userProf{get; set;}

public Account acc{get; set;}
public Contact con{get; set;}
public Area_Profile__c newareaProf{get; set;}
public User_Profile__c newUserProfile{get; set;}

public Area_Profile__c area{get; set;}
public list<User_Profile__c> ListUserProf{get; set;}

public map<String, String> MapDocuSign{get; set;}
public list<dsfs__DocuSign_Status__c> docusList;
public dsfs__DocuSign_Status__c docusUser{get; set;}
public list<dsfs__DocuSign_Status__c> docusListUser;
public list<dsfs__DocuSign_Recipient_Status__c> docusRecipientList;
public dsfs__DocuSign_Recipient_Status__c docusUserRec2AD{get; set;}
public list<String> IdList;
public String retParam {get;set;}
public String fileUploadUrl{get;set;}
public String returnURL {get;set;}
public String docType {get; set
    {
        docType = value;
    }
} 
// Scorm Variable
public list<Scorm__c> scormMultiCoursetList{get; set;}
public list<Scorm__c> CoursetList{get; set;}
public list<Scorm__c> scormlst{get; set;}
public Scorm__c singleScormobj{get; set;}
public Scorm__c scormId{get; set;}
public Scorm__c ParentScormId{get; set;}
public string getRegistrationID{get; set;}
public String responseXML{get; set;}
public Id sId{get;set;}
public Boolean isScorm{get;set;} 
public string utype{get; set;}
public string ProfileName{get; set;}
public list<User> Userlst = new list<User>();
public map<String,String> address_Result{get; set;}
public String region {get;set;}
public External_System_Outage__c externalSystemOutage{get;set;}

//List of RM Region
public List<SelectOption> Region_List {
      get {
        //List to hold the options
        List<SelectOption> InstOptions = new List<SelectOption>();
            InstOptions.add(new SelectOption('California Sud','California Sud'));
            InstOptions.add(new SelectOption('Eastern Seaboard','Eastern Seaboard'));
            InstOptions.add(new SelectOption('LoneStar Garden State','LoneStar Garden State'));
            InstOptions.add(new SelectOption('Midwest','Midwest'));
            InstOptions.add(new SelectOption('New York','New York'));
            InstOptions.add(new SelectOption('Northeast','Northeast'));
            InstOptions.add(new SelectOption('Northern California','Northern California'));
            InstOptions.add(new SelectOption('Southeast','Southeast'));
            InstOptions.add(new SelectOption('Western','Western'));
            
            return InstOptions;
          }
}

	//get List of USA States 
 public List<SelectOption> getUSAStatesList {
        get{
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', '--Select One--'));        

        // Find all the states in the custom setting
        Map<String, US_States__c> states = US_States__c.getAll();
        
        // Sort them by name
        List<String> stateNames = new List<String>();
        stateNames.addAll(states.keySet());
        stateNames.sort();
        
        // Create the Select Options.
        for (String stateName : stateNames) {
            US_States__c state = states.get(stateName);
            options.add(new SelectOption(state.Name, state.Name));
        }
        return options;
        }
    }
 
    public CommunityApcController(){
		docusignRefresh = true;
        //New Hire page
        con= new Contact();
        newareaProf= new Area_Profile__c();
        newUserProfile= new User_Profile__c();
        
        fileUploadUrl=Constants.fileUploadUrl2;
        //init public variables in VFpages
        userProf = new User_Profile__c();
        acc = new Account();
        area = new Area_Profile__c();
        ListUserProf = new list<User_Profile__c>();
        MapDocuSign = new map<String, String>();
        IdList = new list<String>();
        docusUserRec2AD = new dsfs__DocuSign_Recipient_Status__c();
        
        Id uid;
        list<User_Profile__c> userProfList;
        list<Account> accList;
        list<Area_Profile__c> areaList;
        
        //Get login user
        userlog = [Select Username, Profile.Name,Name,Profile.id,Id From User where Id =: UserInfo.getUserId()];
        utype=userlog.Profile.Name;
        system.debug('debug:::::::::::::::::');
        If(UserInfo.getProfileId()==constants.APCADProfileId){
        ProfileName='APC AD PC';
        }
        else if(UserInfo.getProfileId()==constants.APCRMProfileId){
        ProfileName='APC RM PC';
        }
        else{
        ProfileName=UserInfo.getProfileId();
        } 
        system.debug('debug::constants.APCADProfileId'+constants.APCADProfileId);
        system.debug('debug::Profile---ID'+userlog.Profile.id);
        
        //Get List of User Profile record own by the Regional Manager that is log in
        
        ListUserProf = [Select Name,User__r.FirstName, User__r.LastName, Monthly_Stipend__c, Employment_Term_Length__c, User__r.LastLoginDate, Area_Profile__c, OwnerId, Id, User__c, Area_Profile__r.Name,(Select Name,Course_Id__c,Course_Name__c, Complete_Status__c,result__c,Passed_Date__c,Failed_Date__c, Score__c,Attempt_Count__c,Step_Number__c,HasLatestResult__c From Scorms__r where Is_Parent__c=True order by Step_Number__c asc) scorm From User_Profile__c where OwnerId =: userlog.Id and Employment_Status__c!='InActive'];
        
        System.debug('@@@@@ ListUserProf: '+ListUserProf);
        
        //building the DocuSing Map
        buildMapDS();
        
        //we can get the user ID from the System Var or passing a URL parameter to the page Your Profile
        if(ApexPages.currentPage().getParameters().get('uId') != null){
            uid = ApexPages.currentPage().getParameters().get('uId');
        }else{
            uid = UserInfo.getUserId(); 
        }
        
        system.debug('@@@@@ uid: ' + uid);
    
        // getting the current User
        user = [Select Username, User_Interests__c, UserType, UserRoleId, Type__c, Street, State, ProfileId, Profile.Name,
               PostalCode, PortalRole, Phone, Name, MobilePhone, ManagerId, IsActive, Intrax_Id__c, Id, FirstName, LastName, Email,
               Division, Department, Country, ContactId, CompanyName, City, Account__c, Contact.AccountId,Contact.Phone,Contact.Phone_Type__c,
               Contact.OtherPhone,Contact.Other_Phone_Type__c, Contact.Skype_ID__c,Contact.MailingStreet,Contact.MailingCity,Contact.MailingPostalCode,
               Contact.MailingCountry,Contact.MailingState,Contact.Territory__c, Title,Contact.Intrax_HR_Number__c
               From User where Id =: uid];
        
        // getting the related User_Profile
        userProfList = [Select W_4_Signed__c, W4_Signed_Date__c, User__c, Training_Course_Instruction__c, SystemModstamp,
                        Survey_Update__c, Start_Date__c, Skype__c, Resume_Received__c, Resume_Received_Date__c, Employment_Term_Length__c,
                        References_Checked__c, References_Checked_Date__c, RM_Training__c, Profile_Update__c, Profile_Update_Date__c,
                        Profile_Bio__c, Paperwork_Submitted_to_HR__c, OwnerId, Outlook_Distribution__c, New_Hire_Form_Completed__c, Name,
                        Monthly_Stipend__c, Marketing_Materials__c, LastModifiedDate, LastModifiedById,
                        LastActivityDate, Is_Active__c, IsDeleted, Id, I_9_Completed__c, Employment_Status__c, Direct_Line_Service_Update__c, 
                        Direct_Deposit_Setup__c, Database_Walkthrough__c, DB_Walkthrough__c, CurrencyIsoCode, CreatedDate, CreatedById,
                        Cover_Letter_Received__c, Cover_Letter_Received_Date__c, Contract_Signed_Date__c, ConnectionSentId, ConnectionReceivedId,
                        Candidate_Assessment__c, Candidate_Assessment_Date__c, End_Date__c, Exit_interview_Date__c, Exit_Interview_Notes__c,
                        Business_Cards__c, Area_Profile__c,(Select Step_Number__c,Course_Name__c, Complete_Status__c,result__c,HasLatestResult__c From Scorms__r) scorm 
                        From User_Profile__c u where User__c =: user.Id];
        
        system.debug('@@@@@ userProfList: ' + userProfList);
                        
        //getting the photo from AWS and creating a DS varible to control if the AD DS is done in apc_fs_ad_profile.page
        if(userProfList != null && userProfList.size() > 0){
            userProf = userProfList[0];
            //init "docusUserRec2AD"
            buildDSflag();
            returnURL=getApcManagerPhoto(String.valueOf(userProf.Id));
                
        }
        
        if (userProf != NULL && userProf.Id != NULL)
        {
        //load Scorm Record on the Page
         scormMultiCoursetList = [Select Name,Complete_Status__c,Step_Number__c,Is_this_a_quiz__c,Is_Parent__c,result__c,Course_Description__c,Multi_Step_Course__c,Course_Id__c,Score__c,Learner_Id__c,Registration_Id__c,
         LearnerFirstName__c,LearnerLastName__c,Course_Name__c,Scorm_Application_ID__c,User_Profile__r.User__r.email,Total_Time__c,Last_Scorm_Access__c,Failed_Date__c,
         Passed_Date__c ,Attempt_Count__c, Has_Certificate__c, HasLatestResult__c, (select id,Attempt_Count__c,Step_Number__c,Multi_Step_Course__c,Total_Time__c,Is_this_a_quiz__c,name,Score__c,Course_Name__c,Complete_Status__c,Course_Description__c,Passed_Date__c,Failed_Date__c,Result__c,HasLatestResult__c from scorm__r order by Step_Number__c asc) scorm 
         From Scorm__c WHERE  User_Profile__c=: userProf.id order by Course_Name__c asc];
         
         system.debug('debug::scormMultiCoursetList==='+scormMultiCoursetList);
        }
        
        // Getting the AD area profile record
        if(userProfList != null && userProfList.size() > 0 && userProf.Area_Profile__c != null){
            areaList = [Select SystemModstamp, School_Website__c, Recommended_Websites__c, OwnerId, Name,
                        LastModifiedDate, LastModifiedById, LastActivityDate, IsDeleted, Id, Educational_Institution_3__c,
                        Educational_Institution_3_URL__c, Educational_Institution_2__c, Educational_Institution_2_URL__c, Educational_Institution_1__c,
                        Educational_Institution_1_URL__c, Description__c, CurrencyIsoCode, CreatedDate, CreatedById, ConnectionSentId,
                        ConnectionReceivedId, Climate__c, Cities_Cervised__c,APC_Field_Region__c
                        From Area_Profile__c where Id =: userProf.Area_Profile__c];
        }
        
        //Getting the related Area_Profile record
        if(areaList != null && areaList.size()>0){
            area = areaList[0];
        }
        
        
        //Getting the related business Account
        if(user.Contact.AccountId != null){
            accList=[Select Name,Phone, Phone_Type__c, Other_Phone__c, Other_Phone_Type__c, Skype__c, Id, BillingStreet, BillingState, BillingPostalCode, BillingLongitude, BillingLatitude, BillingCountry, BillingCity
                    From Account where Id =: user.Contact.AccountId];
            //acc=accList[0];
        }else if (user.Id != null){
            
            accList=[Select Name, Phone , Phone_Type__c, Other_Phone__c,Other_Phone_Type__c, Skype__c, Id, Field_Support_Role__c, BillingStreet, BillingState, BillingPostalCode, BillingLongitude, BillingLatitude, BillingCountry, BillingCity
                    From Account where OwnerId =: user.Id AND Field_Support_Role__c = 'RM' Limit 1];
        }
        
        if(accList != null && accList.size()>0){
            acc = accList[0];
        }
        //AA Populate Encoded Retparam
        if(userProf !=null){
                  //Fetch Upload Docs List
                  //getting the return URL for the SFDC enviorment (RM)
                /*if(ApexPages.currentPage().getUrl().contains('/apex/apc_fs_rm_profile')){
                retParam='https://' + ApexPages.currentPage().getHeaders().get('Host') + ApexPages.currentPage().getUrl();
                System.debug('@@@@@ ApexPages.currentPage().getHeaders() :' + ApexPages.currentPage().getHeaders().get('Host') );
                System.debug('@@@@@ ApexPages.currentPage().getUrl():' + ApexPages.currentPage().getUrl());
                System.debug('@@@@@ retParam:' + retParam);
                retParam = EncodingUtil.urlEncode(EncodingUtil.base64Encode(Blob.valueOf(retParam)),'UTF-8');
                System.debug('@@@@@ retParam: ' + retParam);  
                
                //getting the return URL for the Communities (AD)
                }else if(ApexPages.currentPage().getUrl().contains('/apex/apc_fs_ad_profile')){*/
                retParam=Site.getBaseUrl() + ApexPages.currentPage().getUrl();
                System.debug('@@@@@ Site.getBaseUrl():' + Site.getBaseUrl());
                System.debug('@@@@@ ApexPages.currentPage().getUrl():' + ApexPages.currentPage().getUrl());
                System.debug('@@@@@ retParam:' + retParam);
                retParam = EncodingUtil.urlEncode(EncodingUtil.base64Encode(Blob.valueOf(retParam)),'UTF-8');
                System.debug('@@@@@ retParam: ' + retParam);  
               // }  
        }
    }//End of constructor
    
    //Open New Hire Page
     public PageReference newHire(){
	     If(ProfileName=='APC RM PC'){
	     PageReference newpage = new PageReference('/apcfield/apex/apc_fs_new_hire');
	     return newpage;
	     }
	     else{
	     PageReference newpage = new PageReference('/apex/apc_fs_new_hire');
	     newpage.setRedirect(true);
	     return newpage;
	     }
     }
    
     //Cancel Return to Your Team Page
     public PageReference btCancel(){
     //PageReference newpage = new PageReference('/apcfield/apex/apc_fs_rm_team');
	     If(ProfileName=='APC RM PC'){
	     PageReference newpage = new PageReference('/apcfield/apex/apc_fs_rm_team');
	     return newpage;
	     }
	     else{
	     PageReference newpage = new PageReference('/apex/apc_fs_rm_team');
	     newpage.setRedirect(true);
	     return newpage;
     	 }
     //return newpage;
     }
    //Create Area Director Profile
    public PageReference createPartnerAcc(){
    	system.debug('debug:::con.Email'+con.Email);
    	Userlst=[Select name,LastName,Email,Username From User where UserName=:con.Email];
        system.debug('debug::Existing AD UsertList'+Userlst);
        
        If(Userlst.size()>0){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Area Director Profile is already exists Email/UserName: '+Userlst[0].UserName));
        }else{
        //Find user Regional Manager
        list<User> RMUserlst=[select id,Profile.Name,UserRole.name,Contact.AccountId from user where Profile.Name='APC RM PC' AND UserRole.name like :'%'+region+'%' limit 1];
        	
			If(RMUserlst.size()>0 && RMUserlst[0].Contact.AccountId != null){  
	        system.debug('debug::Contact Data=='+con);
	        con.Title='Area Director';
	        //con.Accountid=acc.id;
	        system.debug('debug::addconfirmed'+addconfirmed);
	        If(addconfirmed=='confirmed'){
	        con.MailingStreet=avProcessor.potentialMatchesList.get(addressid).get('address1')+' '+avProcessor.potentialMatchesList.get(addressid).get('address2') ;
	    	//applicantInfo.Home_Street_2__c=avProcessor.potentialMatchesList.get(addressid).get('address2');
		    con.MailingCity=avProcessor.potentialMatchesList.get(addressid).get('city');
		    con.MailingState=avProcessor.potentialMatchesList.get(addressid).get('state');
	    	con.MailingPostalCode=avProcessor.potentialMatchesList.get(addressid).get('postalCode');
	        }
	        
	        con.Accountid=RMUserlst[0].Contact.AccountId;
	        con.Intrax_Programs__c='AuPairCare';
	        con.MailingCountry='United States';
	        con.OtherCountry='United States';
	        con.ownerId=RMUserlst[0].id;
	        con.ReportsToId=RMUserlst[0].ContactId;
	        upsert con;
	        system.debug('debug::Contact=='+con);
	        
	        
	        //Create user
			Profile portalProfile = [SELECT Id FROM Profile WHERE Name LIKE '%APC AD PC%' Limit 1];
			
			User user1 = new User(
				Username = con.email,
				ContactId = con.Id,
				ProfileId = portalProfile.Id,
				Alias = (con.firstName).substring(0,2)+(con.LastName).substring(0,2),
				Email = con.Email,
				Phone=	con.Phone,
				EmailEncodingKey = 'UTF-8',
				FirstName=con.firstName,
				LastName = con.LastName,
				CommunityNickname = 'AD'+'_'+con.firstName+con.LastName,
				TimeZoneSidKey = 'America/Los_Angeles',
				LocaleSidKey = 'en_US',
				LanguageLocaleKey = 'en_US',
				ManagerId=RMUserlst[0].id,
				//ManagerId=userlog.id,
				Title=con.Title
			);
			
				try{
				Database.insert(user1);
				system.debug('debug::user1=='+user1);
				system.debug('debug::region=='+region);
				newareaProf.APC_Field_Region__c=region;
		        upsert newareaProf;
		        
		        system.debug('debug::userProfile=='+newUserProfile);
				newUserProfile.Name=con.FirstName+' '+con.LastName;
				newUserProfile.User__c=user1.id;
				newUserProfile.Is_Active__c=True;
				newUserProfile.Area_Profile__c=newareaProf.id;
				newUserProfile.ownerId=RMUserlst[0].id;
		        upsert newUserProfile;
				
				}catch(Exception e){
				system.debug('debug:: Error'+e);
				}
	        system.debug('debug::userProfile=='+newareaProf);
	        PageReference newpage;
	        
	        If(ProfileName=='APC RM PC'){
	        newpage = new PageReference('/apcfield/apex/apc_fs_rm_team');
	        newpage.setRedirect(true);
	        }
	        
	        else{
	        newpage = new PageReference('/apex/apc_fs_rm_team');
	        newpage.setRedirect(true);
	        }
	        
	        system.debug('debug::ProfileName=='+ProfileName);
	        return newpage;
			}
	        else{
	        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Region+ ' '+' Region Account Not Found'));	
	        }
        
        }
        return Null;
    }
    
    //############## Address Validation ###################
    //#####################################################
     
    public string Country{get;set;}
    public map<Integer,String> potentialMatchesList {get; set;}
    public AddressValidation_Processor avProcessor{get; set;}
    public integer addressid {get; set;}
    //public boolean hidePopup {get; set;}
    public string addconfirmed {get; set;}
    
     //Address Validation
    public void AddressValidation_controller(){
    	
    	system.debug('debug:::con.Email'+con.Email);
    	Userlst=[Select name,LastName,Email,Username From User where UserName=:con.Email];
        system.debug('debug::Existing AD UsertList'+Userlst);
        If(Userlst.size()>0){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Area Director Profile is already exists Email/UserName: '+Userlst[0].UserName));
        }
    	else{
        system.debug('debug:::::clist Street='+con.MailingStreet+'& City='+con.MailingCity+' &State= '+con.MailingState+' &PostalCode='+con.MailingPostalCode);
        avProcessor = new AddressValidation_Processor();
        avProcessor.address1 = con.MailingStreet;
        avProcessor.address2 = '';
        avProcessor.address3 = '';
        avProcessor.address4 = '';
        avProcessor.city = con.MailingCity;
        avProcessor.state =con.MailingState;
        avProcessor.postalCode = con.MailingPostalCode;
        avProcessor.country = '';//c.Country;
        
        avProcessor.verifyAddress();
        system.debug('debug:::::potentialMatchesList'+avProcessor.potentialMatchesList);
        /*
        if(avProcessor.potentialMatchesList.size() > 0){
            potentialMatchesList = new map<Integer,String>();
            for(integer i=0;i< avProcessor.potentialMatchesList.size();i++){
                potentialMatchesList.put(i,avProcessor.potentialMatchesList.get(i).get('address1')+' '+avProcessor.potentialMatchesList.get(i).get('address2')+' '+avProcessor.potentialMatchesList.get(i).get('city')+' '+avProcessor.potentialMatchesList.get(i).get('state')+' '+avProcessor.potentialMatchesList.get(i).get('postalCode'));
            }
        }*/
        system.debug('debug::Status'+avProcessor.status);
        system.debug('debug::additionalInformation'+avProcessor.addInfo);
        } 
    }
    /*
     public void stopPoller() {
        hidePopup = false;
        //system.debug('debug::Inside StopPoller');
        //return createPartnerAcc();
    }*/
    
    
      //Update Address Validation
    public void AddressValidation_UpdateController(){
    	system.debug('debug:::con.Email');
        system.debug('debug:::::clist Street='+user.Contact.MailingStreet+'& City='+user.Contact.MailingCity+' &State= '+user.Contact.MailingState+' &PostalCode='+user.Contact.MailingPostalCode);
        avProcessor = new AddressValidation_Processor();
        avProcessor.address1 = user.Contact.MailingStreet;
        avProcessor.address2 = '';
        avProcessor.address3 = '';
        avProcessor.address4 = '';
        avProcessor.city = user.Contact.MailingCity;
        avProcessor.state =user.Contact.MailingState;
        avProcessor.postalCode = user.Contact.MailingPostalCode;
        avProcessor.country = '';//c.Country;
        
        avProcessor.verifyAddress();
        system.debug('debug:::::potentialMatchesList'+avProcessor.potentialMatchesList);
        system.debug('debug::Status'+avProcessor.status);
        system.debug('debug::additionalInformation'+avProcessor.addInfo);
    }
    
    public List<Intrax_Program_Upload__c> getDocList(){
        docType = 'Participant-Photo';
            if(docType == 'Participant-Photo'){
            return [Select d.document_name__c,d.Document_Type__c, d.description__c, d.Keywords__c,d.document_guid__c from Intrax_Program_Upload__c d
            where d.User_Profile__c =: userProf.Id and d.Document_Type__C IN ('Participant-Photo') ];
            }
            else{
                return null;
            }
    }
    
    //building Map to compare User Profile Id and last DocuSign Status related
    public void buildMapDS(){
    
    list<dsfs__DocuSign_Recipient_Status__c> docusUserRec2RMList = new list<dsfs__DocuSign_Recipient_Status__c>();
    
    if(ListUserProf != null && ListUserProf.size() > 0){
    
        for(User_Profile__c up:ListUserProf){
            IdList.add(up.Id);
        }
        
        Global_Constants__c AgreementYear = Global_Constants__c.getInstance();
        
        docusList=[select Id, dsfs__Envelope_Status__c, dsfs__DocuSign_Envelope_ID__c, CreatedDate, UserProfile__c from dsfs__DocuSign_Status__c 
        			where (UserProfile__c IN: (IdList)) AND Signing_Document_Year__c =: AgreementYear.APC_RM_and_AD_Agreement_Year__c order by CreatedDate ASC ];
        
        system.debug('@@@@@ docusList: ' + docusList);
        
        for(String s:IdList){
                MapDocuSign.put(s, ' ');
            }
        
        if(docusList!=null && docusList.size()>0){
            for(dsfs__DocuSign_Status__c ds:docusList){
                if(ds.dsfs__Envelope_Status__c == null){
                    MapDocuSign.put(ds.UserProfile__c, ' ');
                }else{
                    docusUserRec2RMList = [Select d.id, d.dsfs__Envelope_Id__c, d.dsfs__Recipient_Status__c, d.dsfs__DocuSign_Routing_Order__c 
                                 From dsfs__DocuSign_Recipient_Status__c d
                                 WHERE d.dsfs__DocuSign_Routing_Order__c = 2 AND  d.dsfs__Envelope_Id__c =: ds.dsfs__DocuSign_Envelope_ID__c];
                    if(docusUserRec2RMList!= null && docusUserRec2RMList.size()>0){
                        MapDocuSign.put(ds.UserProfile__c, docusUserRec2RMList[0].dsfs__Recipient_Status__c);
                        
                         If(docusUserRec2RMList[0].dsfs__Recipient_Status__c =='Completed')
                	     docusignRefresh = False;
                        
                    }else{
                        MapDocuSign.put(ds.UserProfile__c, ' ');
                    }
                    
                }
            }
        }
        
        system.debug('@@@@@ MapDocuSign: ' + MapDocuSign);
    }       
    
    }
    
    //marker to control DocuSign OutputText that depend on DS Status in apc_fs_ad_profile
    public void buildDSflag(){
        
        Global_Constants__c AgreementYear = Global_Constants__c.getInstance();
        docusListUser=[select Id, dsfs__Envelope_Status__c, dsfs__DocuSign_Envelope_ID__c, CreatedDate, UserProfile__c
                      from dsfs__DocuSign_Status__c where UserProfile__c=: userProf.Id 
                      AND Signing_Document_Year__c =: AgreementYear.APC_RM_and_AD_Agreement_Year__c order by CreatedDate DESC Limit 1];
        if(docusListUser != null && docusListUser.size() > 0){
            docusUser=docusListUser[0];
            
            system.debug('@@@@@ docusRecipientList01: ' + docusRecipientList);
            docusRecipientList = [Select d.id, d.dsfs__Envelope_Id__c, d.dsfs__Recipient_Status__c, d.dsfs__DocuSign_Routing_Order__c 
                                 From dsfs__DocuSign_Recipient_Status__c d
                                 WHERE d.dsfs__DocuSign_Routing_Order__c = 2 AND  d.dsfs__Envelope_Id__c =: docusUser.dsfs__DocuSign_Envelope_ID__c limit 1];
            
            if(docusRecipientList!=null && docusRecipientList.size()>0){
                docusUserRec2AD=docusRecipientList[0];
                
                If(docusUserRec2AD.dsfs__Recipient_Status__c =='Completed'){
                docusignRefresh = False;}
                
                else{
                docusignRefresh = True;}
                
            }
            system.debug('@@@@@ docusUserRec2AD: ' + docusUserRec2AD);
            
        }else{
            docusUser = new dsfs__DocuSign_Status__c();
            docusignRefresh = False;
        }
        
        list<User_Profile__c> userProfList = [Select W_4_Signed__c, W4_Signed_Date__c, User__c, Training_Course_Instruction__c, SystemModstamp,
                        Survey_Update__c, Start_Date__c, Skype__c, Resume_Received__c, Resume_Received_Date__c, Employment_Term_Length__c,
                        References_Checked__c, References_Checked_Date__c, RM_Training__c, Profile_Update__c, Profile_Update_Date__c,
                        Profile_Bio__c, Paperwork_Submitted_to_HR__c, OwnerId, Outlook_Distribution__c, New_Hire_Form_Completed__c, Name,
                        Monthly_Stipend__c, Marketing_Materials__c, LastModifiedDate, LastModifiedById,
                        LastActivityDate, Is_Active__c, IsDeleted, Id, I_9_Completed__c, Employment_Status__c, Direct_Line_Service_Update__c, 
                        Direct_Deposit_Setup__c, Database_Walkthrough__c, DB_Walkthrough__c, CurrencyIsoCode, CreatedDate, CreatedById,
                        Cover_Letter_Received__c, Cover_Letter_Received_Date__c, Contract_Signed_Date__c, ConnectionSentId, ConnectionReceivedId,
                        Candidate_Assessment__c, Candidate_Assessment_Date__c, Business_Cards__c, Area_Profile__c, End_Date__c, Exit_interview_Date__c, Exit_Interview_Notes__c
                        From User_Profile__c u where User__c =: user.Id];
        
        system.debug('@@@@@ userProfList: ' + userProfList);
        if(userProfList != null && userProfList.size() > 0){
            userProf = userProfList[0];
        }
    }
  
  //AA Scorm Integration
  
   public PageReference callScormService(){
       
       ScormWebService Scormobj= new ScormWebService();
       Scormobj.appId=scormId.Scorm_Application_ID__c;
       Scormobj.courseId=scormId.Course_Id__c;
       Scormobj.learnerFirstName=scormId.LearnerFirstName__c;
       Scormobj.learnerLastName=scormId.LearnerLastName__c;
       Scormobj.learnerId=scormId.Learner_Id__c;
       system.debug('debug::LearnerID===='+scormId.Learner_Id__c);
       system.debug('debug::call Registration method');
         If(scormId.Registration_Id__c==null || scormId.Registration_Id__c==''){
         //Callin Regsitration Method
           getRegistrationID =Scormobj.CreateRegistration();
           PageReference returnUrl=Scormobj.getLaunchUrl(getRegistrationID,scormId.Id,false,scormId.Scorm_Application_ID__c);
           scormId.Registration_Id__c=getRegistrationID;
           System.debug('Registration id'+scormId.Registration_Id__c);
           scormId.HasLatestResult__c = False;
           scormId.Last_Scorm_Access__c=system.now();
           update scormId;
           return returnUrl;
         }
         else if(scormId.Complete_Status__c=='completed' && scormId.result__c=='passed')
         {
            PageReference returnUrl=Scormobj.getLaunchUrl(scormId.Registration_Id__c,scormId.Id,true,scormId.Scorm_Application_ID__c);
            scormId.Last_Scorm_Access__c=system.now();
            update scormId;
            return returnurl;
         }
         else{
         system.debug('debug::calling getLaunchUrl method');
         //Callin getLaunchUrl Method
         PageReference returnUrl=Scormobj.getLaunchUrl(scormId.Registration_Id__c,scormId.Id,false,scormId.Scorm_Application_ID__c);
         scormId.Last_Scorm_Access__c=system.now();
         scormId.HasLatestResult__c = False;
         update scormId;
         return returnurl;
         }
    }
    
      public void Ischeck(){
         sId = ApexPages.currentPage().getParameters().get('getUpdatedResult');
         system.debug('debug:::::::::::::::'+sId);
         scormMultiCoursetList = [Select Name,Complete_Status__c,Step_Number__c,Is_this_a_quiz__c,Is_Parent__c,result__c,Course_Description__c,Multi_Step_Course__c,Course_Id__c,Score__c,Learner_Id__c,Registration_Id__c,
         LearnerFirstName__c,LearnerLastName__c,Course_Name__c,Scorm_Application_ID__c,User_Profile__r.User__r.email,Total_Time__c,Last_Scorm_Access__c,Failed_Date__c,
         Passed_Date__c ,Attempt_Count__c,Has_Certificate__c,HasLatestResult__c, (select id,Attempt_Count__c,Total_Time__c,Is_this_a_quiz__c,name,Score__c,Course_Name__c,Complete_Status__c,Course_Description__c,Passed_Date__c,Failed_Date__c,Result__c,Step_Number__c,HasLatestResult__c from scorm__r order by Step_Number__c asc) scorm 
         From Scorm__c WHERE  User_Profile__c=: userProf.id order by Course_Name__c asc];
         system.debug('debug::scormMultiCoursetList==='+scormMultiCoursetList);
       }
     
	 public Scorm__c getLatestScormResults(Scorm__c scormChild)
	 { 
		  Scorm__c parentScorm = null; 	
          system.debug('debug::scormObj==='+scormChild);
          
          if(scormChild.Parent_Course_Name__c != null){         
	          parentScorm=[Select Id,Name,Complete_Status__c,Scorm_Application_ID__c,Multi_Step_Course__c,result__c,Course_Id__c,Is_this_a_quiz__c,Score__c,Course_Name__c,Total_Time__c,
	          Last_Scorm_Access__c,Failed_Date__c,Passed_Date__c ,Attempt_Count__c, Step_Number__c,HasLatestResult__c, (select Id,Step_Number__c From Scorm__r) ScormCount From Scorm__c where Is_Parent__c= true and id=:scormChild.Parent_Course_Name__c limit 1];
	          if(parentScorm != null)
	          {
	          	system.debug('debug::ParentScormId==='+parentScorm);
	          	system.debug('debug::ParentScormId==='+parentScorm.Scorm__r.Size());
	          }
	          
	        } 

            ScormWebService getUpdatedResult= new ScormWebService();
            String registration =scormChild.Registration_Id__c;
            String appid=scormChild.Scorm_Application_Id__c;
            ScormWebService.Courselaunch CourseObj=getUpdatedResult.getregistrationResult(registration,appid);
            system.debug('debug::getUpdatedResult'+CourseObj);
            system.debug('debug::Parent_Course_Name'+scormChild.Parent_Course_Name__r.score__c);
            if(CourseObj.score!='unknown'){
            scormChild.Score__c=Decimal.valueOf(CourseObj.score);

                if(scormChild.Is_this_a_quiz__c==True && scormChild.Multi_Step_Course__c==True)
                parentScorm.score__c=Decimal.valueOf(CourseObj.score);
            }
            if(CourseObj.score=='unknown'){
            scormChild.Score__c=null;
            }
            scormChild.Total_Time__c=CourseObj.totaltime;
            
            if(scormChild.Is_this_a_quiz__c==True && scormChild.Multi_Step_Course__c==True)
            parentScorm.Total_Time__c=CourseObj.totaltime;
            
            If((CourseObj.complete=='unknown' && CourseObj.success=='unknown')||(CourseObj.complete=='incomplete')){
            scormChild.Complete_Status__c='In Progress';
            
                if(parentScorm != null && parentScorm.Complete_Status__c =='Not Started')
                parentScorm.Complete_Status__c='In Progress';
            
            scormChild.Result__c='';
            }
            if(CourseObj.success=='Passed' && CourseObj.complete=='complete' && scormChild.Result__c !='Passed'){
            scormChild.Result__c='Passed';
            scormChild.Passed_Date__c=system.today();
            scormChild.Complete_Status__c='Completed';
            system.debug('debug:::Attempt_Count__c'+scormChild.Attempt_Count__c);
            scormChild.Attempt_Count__c=scormChild.Attempt_Count__c+1;
            
            if(parentScorm !=null)
            {
                if(parentScorm.Complete_Status__c =='Not Started')
            		parentScorm.Complete_Status__c='In Progress';
            	
            	parentScorm.Step_Number__c=parentScorm.Step_Number__c+1;
            	
                if(parentScorm.Scorm__r.Size()==parentScorm.Step_Number__c){
                parentScorm.Result__c='Passed';
                parentScorm.Attempt_Count__c=parentScorm.Attempt_Count__c+1;
                parentScorm.Complete_Status__c='Completed';
                parentScorm.Passed_Date__c=system.today();
                }
            }
            
            }
            
            if(CourseObj.success=='failed' && CourseObj.complete=='complete'){
            scormChild.Result__c='Failed';
            scormChild.Failed_Date__c=system.today();
            scormChild.Complete_Status__c='Completed';
            scormChild.Attempt_Count__c=scormChild.Attempt_Count__c+1;
            
            if(parentScorm != null)
            {
            	if(parentScorm.Complete_Status__c =='Not Started')
            	parentScorm.Complete_Status__c='In Progress';
            	
            	if(scormChild.Is_this_a_quiz__c==True && scormChild.Multi_Step_Course__c==True){
                	parentScorm.Result__c='Failed';
                	parentScorm.Failed_Date__c=system.today();
                	parentScorm.Complete_Status__c='Completed';
                	parentScorm.Attempt_Count__c=parentScorm.Attempt_Count__c+1;
                }
            }
            
            }
		
	    	scormChild.HasLatestResult__c = true;
			scormChild.Last_Scorm_Access__c = system.now();
	   
	   		return parentScorm;
	 }
	 
     public Pagereference generateResult(){
        Pagereference outagePage = new pageReference('/apex/apc_Scorm_Outage');
        outagePage.setRedirect(false);
        
         Boolean isScormOutage = false;
         externalSystemOutage = IUtilities.scormOutage();
         
         if(externalSystemOutage != null)
         isScormOutage = true;
         
        If(ApexPages.currentPage().getParameters().get('ScormID')!=null){
         if(isScormOutage)
         {
             System.debug('Outage is true. outage details ' +externalSystemOutage);
             return outagePage;
         }
          sId = ApexPages.currentPage().getParameters().get('ScormID');
          scormlst = [Select Name,Complete_Status__c,result__c,Course_Id__c,Multi_Step_Course__c,Score__c,Learner_Id__c,Registration_Id__c,LearnerFirstName__c,LearnerLastName__c,Course_Name__c,Scorm_Application_ID__c,User_Profile__r.User__r.email,Total_Time__c,Last_Scorm_Access__c,Failed_Date__c,Passed_Date__c ,Attempt_Count__c,Step_Number__c,Parent_Course_Name__c,Parent_Course_Name__r.Complete_Status__c,HasLatestResult__c From Scorm__c WHERE  User_Profile__c=: userProf.id and id=: sId order by CreatedDate desc];
          system.debug('debug::scormlst==='+scormlst);
             if(scormlst.size()>0){
             scormId=scormlst[0];
             }
        return callScormService();
        }
     
       if(ApexPages.currentPage().getParameters().get('getUpdatedResult') != null) {
           if(isScormOutage)
         {
             System.debug('Outage is true. outage details ' +externalSystemOutage);
             return outagePage;
         }
       	  String scrmId = ApexPages.currentPage().getParameters().get('getUpdatedResult');
          //call the method getLatestScormResults passing the scorm object id for which we need to get the latest results.
		  //getLatestScormResults(ApexPages.currentPage().getParameters().get('getUpdatedResult'));
		  list<Scorm__c> scrmLst = [Select Name,Complete_Status__c,result__c,Multi_Step_Course__c,Course_Id__c,Is_this_a_quiz__c,Score__c,Learner_Id__c,Registration_Id__c,LearnerFirstName__c,LearnerLastName__c,Course_Name__c,Scorm_Application_ID__c,User_Profile__r.User__r.email,Total_Time__c,Last_Scorm_Access__c,Failed_Date__c,Passed_Date__c ,Attempt_Count__c,Parent_Course_Name__c,Parent_Course_Name__r.score__c,Parent_Course_Name__r.Is_this_a_quiz__c,Step_Number__c,HasLatestResult__c From Scorm__c WHERE  
		  User_Profile__c=: userProf.id and id=: scrmId 
		  and Registration_Id__c !='' order by CreatedDate desc];
          if(scrmLst.size()>0)
          {
          	Scorm__c childScorm = scrmLst[0];
          	Scorm__c parentScorm= getLatestScormResults(childScorm);
          	update childScorm;
          	
          	if(parentScorm != null)
          		update parentScorm;
          }
           IsCheck();
		  return null;
       }
	   
	   //ok now we also need to loop through all the scorm objects under this userprofile which does have latest results and update them.
	   list<Scorm__c> scrmLst  = [Select Id,Name,Complete_Status__c,result__c,Multi_Step_Course__c,Course_Id__c,Is_this_a_quiz__c,Score__c,Learner_Id__c,Registration_Id__c,LearnerFirstName__c,LearnerLastName__c,Course_Name__c,Scorm_Application_ID__c,User_Profile__r.User__r.email,Total_Time__c,Last_Scorm_Access__c,Failed_Date__c,Passed_Date__c ,Attempt_Count__c,Parent_Course_Name__c,Parent_Course_Name__r.score__c,Parent_Course_Name__r.Is_this_a_quiz__c,Step_Number__c,HasLatestResult__c From Scorm__c WHERE  
	   								User_Profile__c=: userProf.id and 
	   								HasLatestResult__c=false and 
	   								Registration_Id__c !='' and
	   								Is_Parent__c=false order by CreatedDate desc ];
	   
	   Map<Id, Scorm__C> scormResultLst = new Map<Id, Scorm__C>();
	   //list<Scorm__C> scormResultLst = new list<Scorm__C>();
	   if(scrmLst!=null && scrmLst.size()>0)
       {
           if(isScormOutage)
         {
             System.debug('Outage is true. outage details ' +externalSystemOutage);
             return outagePage;
         }
       }
         
	   for(Scorm__c sc :scrmLst) 
	   {
			Scorm__c parentScorm = getLatestScormResults(sc);
			scormResultLst.put(sc.Id, sc);
			if(parentScorm != null)
			{
				if(scormResultLst.containsKey(parentScorm.Id))
				{
					scormResultLst.remove(parentScorm.Id);
					//scormResultLst.put(parentScorm.Id, parentScorm);
				}
				//else
				  scormResultLst.put(parentScorm.Id, parentScorm);
				
			}
			
	   }
	   
	   if(scormResultLst.size() > 0)
	   update scormResultLst.values();
	   
	   //Call the IsCheck() to get the latest list of scorm objects.
	   IsCheck();
       
	   return null;
     }
    
    /*
          public void SendResultNotification(){
                     List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
                     Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

                     //create an email list
                     String emailUser= scormId.Learner_Id__c;
                     String[] toAddresses = new String[]{emailUser};         
                     mail.setSaveAsActivity(false);
                     mail.setToAddresses(toAddresses);
                     
                     //mail.setSubject('Course Result');
                     //mail.setPlainTextBody('User: '+ user.FirstName + ' ' + user.LastName + '. User ID: ' + userId + '. User Profile: ' + UserInfo.getProfileId() + '. Environment ' + Userinfo.getOrganizationId() + '. Method: registerUser(). Class: SiteRegisterController.cls. ' +  e.getMessage());
                     
                     
                     String EmailRegistrationId;
                     List<Application_Constants__c> appconstants = Application_Constants__c.getall().values();
                     Application_Constants__c appconstant = Application_Constants__c.getInstance('New_User_VF_AppEngine');
                     EmailRegistrationId=appconstant.Value__c;
            
                     mail.setTemplateId('00X18000000Lx5I');
                     mail.setTargetObjectId(scormId.id); 
                     
                     emails.add(mail);
                     Messaging.sendEmail(emails); 
          }*/
    
    @TestVisible private static string convertMonthNumberText(integer matrixMonth){
      if(matrixMonth == 1){
          return 'January';   
      }else if(matrixMonth == 2){
          return 'February';   
      }else if(matrixMonth == 3){
          return 'March';   
      }else if(matrixMonth == 4){
          return 'April';   
      }else if(matrixMonth == 5){
          return 'May';       
      }else if(matrixMonth == 6){            
          return 'June';   
      }else if(matrixMonth == 7){
          return 'July';   
      }else if(matrixMonth == 8){
          return 'August';   
      }else if(matrixMonth == 9){
          return 'September';   
      }else if(matrixMonth == 10){
          return 'October';  
      }else if(matrixMonth == 11){
          return 'November';  
      }else{
          return 'December';
      }
  }
   public PageReference generateScormCertificate(){
   	List<Intrax_Program_Upload__c> scormCertificates;
    Id ScomIdCert=ApexPages.currentPage().getParameters().get('ScomIdCertificate');
    scormlst = [Select Name,Is_Parent__c,Parent_Course_Name__c,Multi_Step_Course__c,Is_this_a_quiz__c,Complete_Status__c,result__c,Course_Id__c,Score__c,Learner_Id__c,Registration_Id__c,
    LearnerFirstName__c,LearnerLastName__c,Course_Name__c,Scorm_Application_ID__c,User_Profile__r.User__r.email,Total_Time__c,Last_Scorm_Access__c,Failed_Date__c,
    Passed_Date__c ,Attempt_Count__c,Step_Number__c,Has_Certificate__c,HasLatestResult__c From Scorm__c WHERE  User_Profile__c=: userProf.id and id=: ScomIdCert order by CreatedDate desc limit 1];
    system.debug('debug:::scorm record'+scormlst);
    
    List<Scorm_Settings__c> ScormSettings =  [select id,Certificate_Template_Link__c,Has_Certificate__c,Course_Name__c from Scorm_Settings__c where Course_Name__c =:scormlst[0].Course_Name__c limit 1];
    //Scorm_Settings__c ScormSettings = Scorm_Settings__c.getInstance(scormlst[0].Course_Name__c);
    system.debug('debug:::Certificate Template'+ScormSettings);
    
    Http h = new Http();
    HttpRequest req = new HttpRequest();
    HttpResponse res = new HttpResponse();
    Dom.Document docRes = new Dom.Document();
    Intrax_Program_Upload__c scormIPU;
    pageReference p;
    
    req.setMethod('POST'); 
    req.setHeader('Accept', 'application/xml');
    req.setHeader('Authorization','Basic '+EncodingUtil.base64Encode(Blob.valueof(Constants.ldapCredentials)));
    req.setEndpoint(Constants.documentService+'CreateCertificate');
    String body = '';
    
    body = 'authToken='+Constants.serviceAuthToken+'&programId=scorm/certificates/apc/fstraining&';
    //body = body+'scormTemplateGUID=scorm/certificates/templates/apc/AD_TRAINING_CERTIFICATE&';
    body = body+'scormTemplateGUID='+ScormSettings[0].Certificate_Template_Link__c;
    body = body+'firstName='+UserInfo.getFirstName();
    body = body+'&lastName='+UserInfo.getLastName();
    system.debug('debug:::'+(scormlst[0].Passed_Date__c).day()+'-'+convertMonthNumberText((scormlst[0].Passed_Date__c).month())+'-'+(scormlst[0].Passed_Date__c).year());
    body = body+'&dateCompleted='+(scormlst[0].Passed_Date__c).day()+'-'+convertMonthNumberText((scormlst[0].Passed_Date__c).month())+'-'+(scormlst[0].Passed_Date__c).year();
    req.setBody(body);
    
    scormCertificates = [select Id, Document_Guid__c from Intrax_Program_Upload__c where user_profile__c = :userProf.Id and Scorm__c=:ScomIdCert];
    
    String scormCertificateGuid = null;
       if (!isTestMode){
         if (scormCertificates.size() == 0){
        res = h.send(req);
        
        responseXML = res.getBody();
        
        docRes.load(responseXML);
        List<dom.XmlNode> resnodelist = docRes.getRootElement().getChildElements();
        
        System.debug(res.getBody());      
        
        for (dom.XmlNode node : resnodelist){
                    
          if (node.getName() == 'documentResult'){
            
            List<dom.XmlNode> resnodelist1 = node.getChildren();
            for (dom.XmlNode node1 : resnodelist1){
                    
              if (node1.getName() == 'result'){
                    scormCertificateGuid = node1.getText();
                          RecordType RecType = [Select Id From RecordType  Where SobjectType = 'Intrax_Program_Upload__c' and DeveloperName = 'SCORM'];
                          scormIPU = new Intrax_Program_Upload__c();
                          scormIPU.Name= 'AD Training Certificate '+system.today().format();
                          scormIPU.Document_GUID__c=scormCertificateGuid;
                          system.debug('Debud:::ScormPassedId'+scormlst[0].Passed_Date__c);
                          scormIPU.Printed_Date__c=scormlst[0].Passed_Date__c;
                          scormIPU.RecordTypeId=RecType.id;
                          scormIPU.Document_Type__c='Certificate';
                          scormIPU.Document_Service__c='DS';
                          scormIPU.User_Profile__c = userProf.Id;
                          if(scormlst[0].Multi_Step_Course__c==True && scormlst[0].Is_this_a_quiz__c==True){
                          system.debug('debug::Parent_Course_Name__c');
                          scormIPU.scorm__c=scormlst[0].Parent_Course_Name__c;
                          }
                          else{
                          system.debug('debug::child');
                          scormIPU.scorm__c = scormlst[0].Id;
                          }
                          Insert scormIPU;
              }
            }                
          }
        }
        p = new pageReference('/apex/DocViewer?docGuid='+scormIPU.Document_GUID__c);
        p.setRedirect(true);
         }
         else{
        p = new pageReference('/apex/DocViewer?docGuid='+scormCertificates[0].Document_GUID__c);
        p.setRedirect(true);
         }
         return p;
       }
       else{
         //do nothing for now
         return null;
       }      
    }
  
    //test for sendinf registration email using Custom email template (problem- we can not retrieve {Community_Url}  merge field)
    //See https://help.salesforce.com/apex/HTViewHelpDoc?id=merge_fields_communities.htm&language=en_US
    
    public pageReference cancel(){
       return null;
    }
 
    public pageReference saveProf(){
    	system.debug('debug:::::Saveprof--potentialMatchesList'+avProcessor.potentialMatchesList);
        system.debug('debug:::::Before_AddressService Response=='+user.Contact.MailingStreet+'& City='+user.Contact.MailingCity+' &State= '+user.Contact.MailingState+' &PostalCode='+user.Contact.MailingPostalCode);
        If(addconfirmed=='confirmed'){
	        user.Contact.MailingStreet=avProcessor.potentialMatchesList.get(addressid).get('address1')+' '+avProcessor.potentialMatchesList.get(addressid).get('address2') ;
		    user.Contact.MailingCity=avProcessor.potentialMatchesList.get(addressid).get('city');
		    user.Contact.MailingState=avProcessor.potentialMatchesList.get(addressid).get('state');
	    	user.Contact.MailingPostalCode=avProcessor.potentialMatchesList.get(addressid).get('postalCode');
        }
        system.debug('debug:::::AddressService Response=='+user.Contact.MailingStreet+'& City='+user.Contact.MailingCity+' &State= '+user.Contact.MailingState+' &PostalCode='+user.Contact.MailingPostalCode);
        try{
            update user;
            update user.Contact;
            upsert acc;
            update userProf; 
            
        }catch(Exception e){
            //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,e.getMessage());
            //ApexPages.addMessage(myMsg);
            system.debug('****** Impossible to get Save profile Info: ' + e);
        }
        //return null;
        PageReference newpage;
        if(ApexPages.currentPage().getParameters().get('uId') != null){
            newpage = new PageReference('/apex/apc_fs_ad_profile?uId='+ListUserProf[0].User__c);
        }else{
          newpage = new PageReference('/apex/apc_fs_ad_profile');
        }
	    newpage.setRedirect(true);
	    return newpage;
    }
  
    public pageReference saveArea(){
        try{
            update area;
         }catch(Exception e){
            //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,e.getMessage());
            //ApexPages.addMessage(myMsg);
            system.debug('****** Impossible to get Save area Info: ' + e);
        }   
        return null;
    }
  
    public pageReference redirectUser(){
    	string Contactid=ApexPages.currentPage().getParameters().get('Id');
        String param = ApexPages.currentPage().getParameters().get('uId');
        PageReference p;
        if(ApexPages.currentPage().getParameters().get('areaParam') == 'true'){
            p = Page.apc_fs_ad_area;
        }else if(ApexPages.currentPage().getParameters().get('teamParam') == 'true'){
            p = Page.apc_fs_rm_team;
            p.getParameters().put('sfdc.tabName','01r180000008WRI');
            
        }
        /*
        else if(ApexPages.currentPage().getParameters().get('AddressParam') == 'true'){
            p = Page.apc_fs_address_validation;
            p.getParameters().put('sfdc.tabName','01r180000008WRI');
            p.getParameters().put('id',Contactid);
        }*/else{
            p = Page.apc_fs_ad_profile;
        }
        p.getParameters().put('uId',param); 
        p.setRedirect(true);
        return p; 
    }
    
    public static String getApcManagerPhoto(String UserPrID){
        
        system.debug('@@@@@ Inside getApcManagerPhoto');
        system.debug('@@@@@ UserPrID: ' + UserPrID);
        
        string responseXML;
        string returnURL = '';
        string DocumentGuid = '';       
        
        
        if (!IUtilities.isTest){
            // Instantiate a new http object 
            Http h = new Http();
            HttpResponse res = new HttpResponse();
            List<Intrax_Program_Upload__c> loadDoc = new List<Intrax_Program_Upload__c>();
            
                try{
                    // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint     
                    loadDoc = [Select Id, Document_Guid__c, Description__c, Document_service__c, Document_Type__c, User_Profile__c, CreatedDate 
                                from Intrax_Program_Upload__c where User_Profile__c =: UserPrID and document_type__c = 'Participant-Photo' order by CreatedDate DESC limit 1];
                    
                    
                    if (loadDoc != null && loadDoc.size() > 0){
                    DocumentGuid =  loadDoc[0].Document_Guid__c;
                    
                    
                    HttpRequest req = new HttpRequest();
                    req.setMethod('POST'); 
                    req.setHeader('Authorization','Basic '+EncodingUtil.base64Encode(Blob.valueof(Constants.ldapCredentials)));
                    String body = '';
                    
                    req.setEndpoint(Constants.imageService+'GetImagesFromDGUIDS');
                    
                    body = 'authToken='+Constants.serviceAuthToken+'&documentGUIDS=';
                    
                    String DocGuid = DocumentGuid;
                    
                    body = body + DocGuid + '&size=medium';
                    //body = body + DocGuid + '&size=thumbnail';
                    
                    
                    system.debug('***** BODY: ' + body);
                    req.setBody(body);

                    Dom.Document docRes = new Dom.Document();

                     if (!Test.isRunningTest())  {
                        res = h.send(req);
                        System.debug('RESPONSE'+res.getBody());
                        responseXML = res.getBody();
                     
                        docRes.load(responseXML);
                        System.debug('docRes'+docRes);
                        list<dom.XmlNode> resnodelist = docRes.getRootElement().getChildElements();

                        for (dom.XmlNode node : resnodelist){
                            System.debug('nodeName:'+node.getName());
                            if ( node.getName() == 'result'){
                                list<dom.XmlNode> childNodes = node.getChildElements();
                                  for (dom.XmlNode childnode : childNodes){
                                    system.debug('***** childNode: ' + childNode);
                                    if ( childnode.getName() == 'result'){
                                        returnURL = childnode.getText();
                                        System.debug('@@@@@## returnURL: '+ returnURL);
                                    }
                                  }
                            }
                        }
                     }
                   
                 }//End IF (loadDoc != null && loadDoc.size() > 0)
                 }catch(Exception e){
                    system.debug('****** Impossible to get Manager photo: ' + e);
                 }                        
            
        }
        system.debug('@@@@@## returnURL_END_Method: ' + returnURL);
        return returnURL;
    }

    
}