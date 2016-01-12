//@isTest(seeAllData=true)
public class Test_Sevis {


static testmethod void sevisTester2(){ 
    
    
    User sysAdmin = [select Id from User where userName = :Constants.SYS_ADMIN ];
    
    Date dob = date.newInstance(1997,01,10);
    iGeoLocateTriggerHelper.isTest = true;
    
    //Insert PT Account
    Account ptAccount = new Account(LASTNAME='TestJordanov C',FIRSTNAME='Martin',TYPE='Participant',RECORDTYPEID=getRecordType('Participant','Account'),OWNERSHIP=sysAdmin.Id,CURRENCYISOCODE='USD',OWNERID=sysAdmin.Id,CREATEDDATE=datetime.now(),CREATEDBYID=sysAdmin.Id,LASTMODIFIEDDATE=datetime.now(),LASTMODIFIEDBYID=sysAdmin.Id,PERSONMAILINGSTREET='Prvi maj 17',PERSONMAILINGCITY='Kochani',PERSONMAILINGPOSTALCODE='2300',PERSONMAILINGCOUNTRY='SG',PERSONMOBILEPHONE='78612678',PERSONOTHERPHONE='(38933) 276297',PERSONEMAIL='martinjordanov@ymail.com.ayii',PERSONBIRTHDATE=date.newInstance(1997,01,10),PERSONHASOPTEDOUTOFEMAIL=FALSE,PERSONHASOPTEDOUTOFFAX=FALSE,PERSONDONOTCALL=FALSE,INTRAX_PROGRAMS__C='Ayusa',STATUS__C='Contracted',INTRAX_REGION__C='United States',INTRAX_PROGRAM_OPTIONS__C='YES;Ayusa High School',J1_EXPERIENCE__C=FALSE,GENDER__PC='Male',CITIZENSHIP__PC='Lithuania',ENGLISH_LEVEL__PC='Advanced',BIRTH_COUNTRY__PC='Lithuania',BIRTH_CITY__PC='Kochahi',LEGAL_RESIDENCE__PC='Lithuania',NATIONALITY__PC='Lithuanian');
    insert ptAccount;
    //Insert PT Opportunity
    Opportunity ptOpp = new Opportunity (Name = 'TestMartin JordanovPT-AY2014', ACCOUNTID=PTAccount.Id,RECORDTYPEID=getRecordType('Ayusa PT','Opportunity'),STAGENAME='Closed Won',PROBABILITY=100,CLOSEDATE=date.NewInstance(2013,8,22),TYPE='Participant',LEADSOURCE='',CURRENCYISOCODE='USD',OWNERID='00530000004X9a6AAC',PROGRAM_YEAR__C='',INTRAX_PROGRAMS__C='Ayusa',COUNTRIES_OF_INTEREST__C='',LEAD_SOURCE_TAG__C='',PAX__C=1,INTRAX_PROGRAM_OPTIONS__C='YES;Ayusa High School',AGREEMENT_STATUS__C='No Agreement',JOB_DESC_STATUS__C='Not Started',INTRAX_REGION__C='United States',BILL_ORGANIZER__C=TRUE,INFO_SESSION_TYPE__C='Skype',STUDENT_GENDER_PREFERENCE__C='No Preference',SYS_ADMIN_TAG__C='AYII PT Migration Test');
    insert ptOpp;
    Id ptRtId = getRecordType('Participant','Account');
    
    
    //Engagement__c eng = new Engagement__c(Name='test',ACCOUNT_ID__C=ptAccount.Id);
    Engagement__c eng = new Engagement__c(name='TestEng',OWNERID=sysAdmin.Id,CURRENCYISOCODE='USD',RECORDTYPEID=getRecordType('Ayusa PT','Engagement__c'),CREATEDBYID=sysAdmin.Id,ACCOUNT_ID__C=ptAccount.Id,ENGAGEMENT_END__C=date.newInstance(2014,12,23),ENGAGEMENT_START__C=date.newInstance(2013,12,25),INTRAX_PROGRAM_OPTIONS__C='Ayusa High School;YES',INTRAX_PROGRAM__C='Ayusa',INTRAX_REGION__C='United States',STATUS__C='Program Ready',TERMS_ACCEPTED__C=FALSE,TYPE__C='Participant',FLEXIBLE_DATES__C=FALSE,FLEXIBLE_LOCATION__C=FALSE,INTERESTS_TOP__C='Basketball;Music;Soccer',LIVE_WITH_PETS__C='Yes',LIVE_WITH_SMOKER__C='No',PROGRAM_DURATION__C='Academic Year',CENTER_DISCLOSURE_ACCEPTED__C=FALSE,INT_ORG_FUNDING__C=FALSE,OTHER_FINANCIAL_SUPPORT__C=TRUE,OTHER_ORG_FUNDING__C=FALSE,PERSONAL_FUNDS__C=999,PROGRAM_SPONSOR_FUNDS__C=FALSE,RECEIVED_US_GOVT_FUNDS__C=FALSE,SEVIS_POSITION__C='223-SECONDARY SCHOOL STUDENT',SEVIS_PROGRAM__C='1a-STUDENT SECONDARY',SEVIS_SUBJECT_CATEGORY__C='Interdisciplinary Studies',SEVIS_SUBJECT_CODE__C='Intercultural/Multicultural and Diversity Studies 30.2301',PROGRAM_READY_DATE__C=date.newInstance(2013,12,24));
    insert eng;
    
    //Insert HF Account
    Account HFAccount = new Account(LASTNAME='Adams',FIRSTNAME='Patrick',TYPE='Host Family',RECORDTYPEID=getRecordType('Participant','Account'),OWNERSHIP=sysAdmin.Id,CURRENCYISOCODE='USD',OWNERID=sysAdmin.Id,CREATEDBYID=sysAdmin.Id,LASTMODIFIEDBYID=sysAdmin.Id,PERSONMAILINGSTREET='59179 423rd Ave',PERSONMAILINGCITY='Mazeppa',PERSONMAILINGPOSTALCODE='55956',PERSONMAILINGCOUNTRY='United States',PERSONMOBILEPHONE='',PERSONOTHERPHONE='',PERSONEMAIL='smada1@yahoo.com.ayii',PERSONBIRTHDATE=date.newInstance(1997,01,10),PERSONHASOPTEDOUTOFEMAIL=FALSE,PERSONHASOPTEDOUTOFFAX=FALSE,PERSONDONOTCALL=FALSE,INTRAX_PROGRAMS__C='Ayusa',STATUS__C='Active',INTRAX_REGION__C='United States',INTRAX_PROGRAM_OPTIONS__C='Ayusa High School',J1_EXPERIENCE__C=FALSE,GENDER__PC='Unknown',CITIZENSHIP__PC='United States',ENGLISH_LEVEL__PC='',BIRTH_COUNTRY__PC='',BIRTH_CITY__PC='',LEGAL_RESIDENCE__PC='',NATIONALITY__PC='');
    insert HFAccount;
    //Insert HFOpportunity
    Opportunity HFOpp = new Opportunity(Name='TestPatrick AdamsHF_AY2014',ACCOUNTID=HFAccount.Id,RECORDTYPEID=getRecordType('Host Family','Opportunity'),STAGENAME='Closed Won',PROBABILITY=100,CLOSEDATE=date.NewInstance(2013,8,22),TYPE='Host Family',LEADSOURCE='Partner',FORECASTCATEGORYNAME='Closed',CURRENCYISOCODE='USD',OWNERID='00530000004X9a6AAC',PROGRAM_YEAR__C='2014',INTRAX_PROGRAMS__C='Ayusa',COUNTRIES_OF_INTEREST__C='United States',LEAD_SOURCE_TAG__C='Nemo Migration',PAX__C=1,INTRAX_PROGRAM_OPTIONS__C='Ayusa High School',AGREEMENT_STATUS__C='No Agreement',JOB_DESC_STATUS__C='Not Started',INTRAX_REGION__C='United States',BILL_ORGANIZER__C=TRUE,INFO_SESSION_TYPE__C='Skype',STUDENT_GENDER_PREFERENCE__C='No Preference',SYS_ADMIN_TAG__C='Nemo Match Convert');
    Insert HFOpp;
    //Insert Members
    Member__c member1 = new Member__c(NAME='Patrick Adams',CURRENCYISOCODE='USD',CREATEDBYID=SysAdmin.Id,ACCOUNT_NAME__C=HFAccount.Id,DATE_OF_BIRTH__C=date.newInstance(1967,10,29),EMAIL__C='smada1@yahoo.com',EMPLOYER_NAME__C='Rochester Outdoor Living',FIRST_NAME__C='Patrick',GENDER__C='Male',INTRAX_LEGACY_ID__C='',LAST_NAME__C='Adams',MIDDLE_NAME__C='H.',MOBILE__C='(507) 208-1325',PROFESSION__C='Foreman/installer',RESIDENCY_STATUS__C='Full-Time',ROLE__C='Host',TITLE__C='Foreman',FAMILY_MEMBER__C=FALSE);
    insert member1;
    Member__c member2 =  new Member__c(NAME='Samuel Adams',CURRENCYISOCODE='USD',CREATEDBYID=SysAdmin.Id,ACCOUNT_NAME__C=HFAccount.Id,DATE_OF_BIRTH__C=date.newInstance(1999,1,10),EMAIL__C='',EMPLOYER_NAME__C='',FIRST_NAME__C='Samuel',GENDER__C='Male',INTRAX_LEGACY_ID__C='41910',LAST_NAME__C='Adams',MIDDLE_NAME__C='',MOBILE__C='',PROFESSION__C='Student',RESIDENCY_STATUS__C='',ROLE__C='Child',TITLE__C='',FAMILY_MEMBER__C=FALSE);
    insert member2;
    Member__c member3 =  new Member__c(NAME='Sara Adams',CURRENCYISOCODE='USD',CREATEDBYID=SysAdmin.Id,ACCOUNT_NAME__C=HFAccount.Id,DATE_OF_BIRTH__C=date.newInstance(1964,11,9),EMAIL__C='',EMPLOYER_NAME__C='',FIRST_NAME__C='Sara',GENDER__C='Female',INTRAX_LEGACY_ID__C='778987',LAST_NAME__C='Adams',MIDDLE_NAME__C='M.',MOBILE__C='',PROFESSION__C='Database Administration',RESIDENCY_STATUS__C='Full-Time',ROLE__C='Spouse or Partner',TITLE__C='',FAMILY_MEMBER__C=FALSE);
    insert member3;
    Member__c member4 =  new Member__c(NAME='Aaron Adams',CURRENCYISOCODE='USD',CREATEDBYID=SysAdmin.Id,ACCOUNT_NAME__C=HFAccount.Id,DATE_OF_BIRTH__C=date.newInstance(1997,4,10),EMAIL__C='',EMPLOYER_NAME__C='',FIRST_NAME__C='Aaron',GENDER__C='Male',INTRAX_LEGACY_ID__C='41909',LAST_NAME__C='Adams',MIDDLE_NAME__C='',MOBILE__C='',PROFESSION__C='Student',RESIDENCY_STATUS__C='',ROLE__C='Child',TITLE__C='',FAMILY_MEMBER__C=FALSE);
    insert member4;
    //Insert Position
    Position__c position = new Position__c(OWNERID=SysAdmin.Id,NAME='Patrick Adams',CURRENCYISOCODE='USD',RECORDTYPEID=getRecordType('Ayusa HF','Position__c'),ENGAGEMENT_START__C=date.newInstance(2013,8,21),ENGAGEMENT_END__C=date.newInstance(2014,6,2),STREET__C='1 High Street',CITY__C='San Francisco',STATE__C='CA',POSTAL_CODE__C='94108',COUNTRY__C='United States',HOST_COMPANY_ID__C=HFAccount.Id,INTRAX_PROGRAM__C='Ayusa',INTRAX_REGION__C='United States',STATUS__C='Closed - Filled',INTRAX_PROGRAM_OPTIONS__C='Ayusa High School',SYS_ADMIN_TAG__C='Nemo Match Convert',FLEXIBLE_DATES__C=FALSE,GENDER_PREFERENCE__C='No Preference',SCHOOL_CATEGORY__C='Public',TYPE__C='Host Family',PRIMARY_ACTIVITY_SITE__C=FALSE,SEVIS_UEV_SOA_EDIT__C=TRUE,ACCEPTS_COUPLES__C=FALSE,ACCEPTS_GROUPS__C=FALSE,REQUIRES_INTERVIEW__C=FALSE,OVERTIME_AVAILABLE__C=FALSE);
    insert position;
    Account school = new Account(NAME='Athens High School',TYPE='Institution',INSTITUTION_TYPE__C='Secondary',GS_DISTRICT_NAME__C='Athens City',RECORDTYPEID=getRecordType('Institution','Account'),OWNERSHIP=sysAdmin.Id,CURRENCYISOCODE='USD',OWNERID=sysAdmin.Id,CREATEDBYID=sysAdmin.Id,LASTMODIFIEDBYID=sysAdmin.Id,PERSONMAILINGSTREET='',PERSONMAILINGCITY='',PERSONMAILINGPOSTALCODE='',PERSONMAILINGCOUNTRY='',PERSONMOBILEPHONE='',PERSONOTHERPHONE='',PERSONEMAIL='',PERSONHASOPTEDOUTOFEMAIL=FALSE,PERSONHASOPTEDOUTOFFAX=FALSE,PERSONDONOTCALL=FALSE,INTRAX_PROGRAMS__C='Ayusa',STATUS__C='Prospect',INTRAX_REGION__C='United States',INTRAX_PROGRAM_OPTIONS__C='Ayusa High School',J1_EXPERIENCE__C=FALSE);
    insert school;
    
    Match__c match = new Match__c(Participant_Opportunity_Id__c = ptOpp.Id ,CURRENCYISOCODE='USD',RECORDTYPEID=getRecordType('Ayusa','Match__c'),POSITION_NAME__C=Position.Id,PARTICIPANT_ID__C=PTAccount.Id,STATUS__C='Confirmed',MATCH_DATE__C=date.newInstance(2013,4,24),SYS_ADMIN_TAG__C='Ayusa Migration Test',START_DATE__C=date.newInstance(2013,12,25),END_DATE__C=date.newInstance(2014,7,1),ENGAGEMENT__C=eng.Id,MATCH_TYPE__C='Permanent',DOUBLE_PLACEMENT_INDICATED__C=FALSE,SNK_INDICATED__C=FALSE,SEVIS_UEV_SOA_ADD__C=FALSE,SINGLE_NO_CHILDREN_INDICATED__C=FALSE,IS_PRIMARY_SOA__C=FALSE,DIRECT_PLACEMENT__C=FALSE,VALIDATION_VISIT_DUE_DATE__C=date.newInstance(2013,10,14),CONSIDER_OTHER_POSITIONS__C=FALSE,SCHOOL_ID__C=School.Id,MCASSEXISTS__C=FALSE);
    insert match;
    update match;
    System.debug('MatchRecord:'+match);
    List<Match__c> matchcheck = [Select m.Position_Name__c, m.Participant_Id__c, m.Engagement__c, m.Is_Primary_SOA__c,m.School_Id__c From Match__c m where Engagement__c = :eng.Id and m.Status__c = 'Confirmed' and SEVIS_UEV_SOA_Add__c = false order by LastModifiedDate asc];
    System.debug('MatchRecordcheck:'+matchcheck);
   Engagement__c updatedEng = [select Sevis__c from Engagement__c where Id = :eng.Id];
    System.debug('updatedEng'+updatedEng);
    list<Sevis__c> sevis = [select Id,SEVIS_When_Downloaded__c from Sevis__c where Id = :updatedEng.Sevis__c ];
    
    
    Test.startTest();
    ApexPages.StandardController scnomatch = new ApexPages.StandardController(eng);
    SevisWrapper.isTest=true;
    SevisWrapper swnomatch = new SevisWrapper(scnomatch);
    swnomatch.packageData();
    
    
      //Insert PT Account
    Account ptAccountS = new Account(LASTNAME='TestJordanovS C',FIRSTNAME='Martin',TYPE='Participant',RECORDTYPEID=getRecordType('Participant','Account'),OWNERSHIP=sysAdmin.Id,CURRENCYISOCODE='USD',OWNERID=sysAdmin.Id,CREATEDDATE=datetime.now(),CREATEDBYID=sysAdmin.Id,LASTMODIFIEDDATE=datetime.now(),LASTMODIFIEDBYID=sysAdmin.Id,PERSONMAILINGSTREET='Prvi maj 17',PERSONMAILINGCITY='Kochani',PERSONMAILINGPOSTALCODE='2300',PERSONMAILINGCOUNTRY='SG',PERSONMOBILEPHONE='78612678',PERSONOTHERPHONE='(38933) 276297',PERSONEMAIL='martinjordanov@ymail.com.ayii',PERSONBIRTHDATE=date.newInstance(1997,01,10),PERSONHASOPTEDOUTOFEMAIL=FALSE,PERSONHASOPTEDOUTOFFAX=FALSE,PERSONDONOTCALL=FALSE,INTRAX_PROGRAMS__C='Ayusa',STATUS__C='Contracted',INTRAX_REGION__C='United States',INTRAX_PROGRAM_OPTIONS__C='YES;Ayusa High School',J1_EXPERIENCE__C=FALSE,GENDER__PC='Male',CITIZENSHIP__PC='Lithuania',ENGLISH_LEVEL__PC='Advanced',BIRTH_COUNTRY__PC='Lithuania',BIRTH_CITY__PC='Kochahi',LEGAL_RESIDENCE__PC='Lithuania',NATIONALITY__PC='Lithuanian');
    insert ptAccountS;
    //Insert PT Opportunity
    Opportunity ptOppS = new Opportunity (Name = 'TestMartinS JordanovPT-AY2014', ACCOUNTID=PTAccount.Id,RECORDTYPEID=getRecordType('Ayusa PT','Opportunity'),STAGENAME='Closed Won',PROBABILITY=100,CLOSEDATE=date.NewInstance(2013,8,22),TYPE='Participant',LEADSOURCE='',CURRENCYISOCODE='USD',OWNERID='00530000004X9a6AAC',PROGRAM_YEAR__C='',INTRAX_PROGRAMS__C='Ayusa',COUNTRIES_OF_INTEREST__C='',LEAD_SOURCE_TAG__C='',PAX__C=1,INTRAX_PROGRAM_OPTIONS__C='YES;Ayusa High School',AGREEMENT_STATUS__C='No Agreement',JOB_DESC_STATUS__C='Not Started',INTRAX_REGION__C='United States',BILL_ORGANIZER__C=TRUE,INFO_SESSION_TYPE__C='Skype',STUDENT_GENDER_PREFERENCE__C='No Preference',SYS_ADMIN_TAG__C='AYII PT Migration Test');
    insert ptOppS;
    Id ptRtIdS = getRecordType('Participant','Account');
    
    
    //Engagement__c eng = new Engagement__c(Name='test',ACCOUNT_ID__C=ptAccount.Id);
    Engagement__c engS = new Engagement__c(name='TestEngS',OWNERID=sysAdmin.Id,CURRENCYISOCODE='USD',RECORDTYPEID=getRecordType('Ayusa PT','Engagement__c'),CREATEDBYID=sysAdmin.Id,ACCOUNT_ID__C=ptAccount.Id,ENGAGEMENT_END__C=date.newInstance(2014,12,23),ENGAGEMENT_START__C=date.newInstance(2013,12,25),INTRAX_PROGRAM_OPTIONS__C='Ayusa High School;YES',INTRAX_PROGRAM__C='Ayusa',INTRAX_REGION__C='United States',STATUS__C='Program Ready',TERMS_ACCEPTED__C=FALSE,TYPE__C='Participant',FLEXIBLE_DATES__C=FALSE,FLEXIBLE_LOCATION__C=FALSE,INTERESTS_TOP__C='Basketball;Music;Soccer',LIVE_WITH_PETS__C='Yes',LIVE_WITH_SMOKER__C='No',PROGRAM_DURATION__C='Academic Year',CENTER_DISCLOSURE_ACCEPTED__C=FALSE,INT_ORG_FUNDING__C=FALSE,OTHER_FINANCIAL_SUPPORT__C=TRUE,OTHER_ORG_FUNDING__C=FALSE,PERSONAL_FUNDS__C=999,PROGRAM_SPONSOR_FUNDS__C=FALSE,RECEIVED_US_GOVT_FUNDS__C=FALSE,SEVIS_POSITION__C='223-SECONDARY SCHOOL STUDENT',SEVIS_PROGRAM__C='1a-STUDENT SECONDARY',SEVIS_SUBJECT_CATEGORY__C='Interdisciplinary Studies',SEVIS_SUBJECT_CODE__C='Intercultural/Multicultural and Diversity Studies 30.2301',PROGRAM_READY_DATE__C=date.newInstance(2013,12,24));
    insert engS;
    ApexPages.StandardController scnomatchS = new ApexPages.StandardController(eng);
    SevisWrapper.isTest=true;
    SevisWrapper swnomatchS = new SevisWrapper(scnomatchS);
    swnomatchS.packageData();
       
    
    ApexPages.StandardController sc2 = new ApexPages.StandardController(eng);
    SevisWrapper.isTest=true;
    SevisWrapper sw2 = new SevisWrapper(sc2);
    //sw2.packageData();
    
   
    
    
    
    iSevisWebServiceWrapper.Dependent testDep = new iSevisWebServiceWrapper.Dependent();

    //Assume response is received - Record should be unlocked
    if(sevis.size() > 0)
    {
        System.runAs(sysAdmin){
            sevis[0].SEVIS_When_Downloaded__c = System.now();
            sevis[0].SEVIS_Ack_Received_At__c = System.now();
            sevis[0].SEVIS_ID__c = '123';
            update sevis[0];
        }
    }

    ptAccount.Sevis_UEV_Bio__c = true;
    update ptAccount;
    
    school.Sevis_UEV_SOA_Edit__c = true;
    update school;
    
    position.Sevis_UEV_SOA_Edit__c = true;
    update position;
    
    eng.Sevis_UEV_Bio__c = true;
    eng.Sevis_UEV_Pro_Amend__c = true;
    eng.Sevis_UEV_SOA_Edit__c = true;
    eng.Sevis_UEV_Val_USAdd__c = true;
    eng.Sevis_UEV_U_USAdd__c = true;
    //eng.Sevis_UEV_SOA_Add__c = true;
    
    update eng;
    
    //Try sending again but need to do some updates above with SEVIS ID
    ApexPages.StandardController sc3 = new ApexPages.StandardController(eng);
    SevisWrapper.isTest=true;
    SevisWrapper sw3 = new SevisWrapper(sc3);
    sw3.packageData();
    
    ApexPages.StandardController sc33 = new ApexPages.StandardController(engS);
    SevisWrapper.isTest=true;
    SevisWrapper sw33 = new SevisWrapper(sc33);
    sw33.packageData();
   /* 
    Accommodation_Site__c accosite = new Accommodation_Site__c(Name='test',Street__c='123 abc',State__c='CA',Postal_Code__c='94945',City__c='abc',Sevis_UEV_Val_USAdd__c=true,Country__c='United States');
    insert accosite;
    Accommodation__c acco = new Accommodation__c(Accommodation_Site__c=accosite.Id,Engagement__c=eng.Id);
    insert acco;*/
    //update accosite;
    Test.stopTest();
}


static testmethod void sevisTester3(){ 
    
    
    User sysAdmin = [select Id from User where userName = :Constants.SYS_ADMIN ];
    
    Date dob = date.newInstance(1997,01,10);
    iGeoLocateTriggerHelper.isTest = true;
    
    //Insert PT Account
    Account ptAccount = new Account(LASTNAME='TestJordanov C',FIRSTNAME='Martin',TYPE='Participant',RECORDTYPEID=getRecordType('Participant','Account'),OWNERSHIP=sysAdmin.Id,CURRENCYISOCODE='USD',OWNERID=sysAdmin.Id,CREATEDDATE=datetime.now(),CREATEDBYID=sysAdmin.Id,LASTMODIFIEDDATE=datetime.now(),LASTMODIFIEDBYID=sysAdmin.Id,PERSONMAILINGSTREET='Prvi maj 17',PERSONMAILINGCITY='Kochani',PERSONMAILINGPOSTALCODE='2300',PERSONMAILINGCOUNTRY='SG',PERSONMOBILEPHONE='78612678',PERSONOTHERPHONE='(38933) 276297',PERSONEMAIL='martinjordanov@ymail.com.ayii',PERSONBIRTHDATE=date.newInstance(1997,01,10),PERSONHASOPTEDOUTOFEMAIL=FALSE,PERSONHASOPTEDOUTOFFAX=FALSE,PERSONDONOTCALL=FALSE,INTRAX_PROGRAMS__C='Ayusa',STATUS__C='Contracted',INTRAX_REGION__C='United States',INTRAX_PROGRAM_OPTIONS__C='YES;Ayusa High School',J1_EXPERIENCE__C=FALSE,GENDER__PC='Male',CITIZENSHIP__PC='Lithuania',ENGLISH_LEVEL__PC='Advanced',BIRTH_COUNTRY__PC='Lithuania',BIRTH_CITY__PC='Kochahi',LEGAL_RESIDENCE__PC='Lithuania',NATIONALITY__PC='Lithuanian');
    insert ptAccount;
    //Insert PT Opportunity
    Opportunity ptOpp = new Opportunity (Name = 'TestMartin JordanovPT-AY2014', ACCOUNTID=PTAccount.Id,RECORDTYPEID=getRecordType('Ayusa PT','Opportunity'),STAGENAME='Closed Won',PROBABILITY=100,CLOSEDATE=date.NewInstance(2013,8,22),TYPE='Participant',LEADSOURCE='',CURRENCYISOCODE='USD',OWNERID='00530000004X9a6AAC',PROGRAM_YEAR__C='',INTRAX_PROGRAMS__C='Ayusa',COUNTRIES_OF_INTEREST__C='',LEAD_SOURCE_TAG__C='',PAX__C=1,INTRAX_PROGRAM_OPTIONS__C='YES;Ayusa High School',AGREEMENT_STATUS__C='No Agreement',JOB_DESC_STATUS__C='Not Started',INTRAX_REGION__C='United States',BILL_ORGANIZER__C=TRUE,INFO_SESSION_TYPE__C='Skype',STUDENT_GENDER_PREFERENCE__C='No Preference',SYS_ADMIN_TAG__C='AYII PT Migration Test');
    insert ptOpp;
    Id ptRtId = getRecordType('Participant','Account');
    
    
    //Engagement__c eng = new Engagement__c(Name='test',ACCOUNT_ID__C=ptAccount.Id);
    Engagement__c eng = new Engagement__c(name='TestEng',OWNERID=sysAdmin.Id,CURRENCYISOCODE='USD',RECORDTYPEID=getRecordType('Ayusa PT','Engagement__c'),CREATEDBYID=sysAdmin.Id,ACCOUNT_ID__C=ptAccount.Id,ENGAGEMENT_END__C=date.newInstance(2014,12,23),ENGAGEMENT_START__C=date.newInstance(2013,12,25),INTRAX_PROGRAM_OPTIONS__C='Ayusa High School;YES',INTRAX_PROGRAM__C='Ayusa',INTRAX_REGION__C='United States',STATUS__C='Program Ready',TERMS_ACCEPTED__C=FALSE,TYPE__C='Participant',FLEXIBLE_DATES__C=FALSE,FLEXIBLE_LOCATION__C=FALSE,INTERESTS_TOP__C='Basketball;Music;Soccer',LIVE_WITH_PETS__C='Yes',LIVE_WITH_SMOKER__C='No',PROGRAM_DURATION__C='Academic Year',CENTER_DISCLOSURE_ACCEPTED__C=FALSE,INT_ORG_FUNDING__C=FALSE,OTHER_FINANCIAL_SUPPORT__C=TRUE,OTHER_ORG_FUNDING__C=FALSE,PERSONAL_FUNDS__C=999,PROGRAM_SPONSOR_FUNDS__C=FALSE,RECEIVED_US_GOVT_FUNDS__C=FALSE,SEVIS_POSITION__C='223-SECONDARY SCHOOL STUDENT',SEVIS_PROGRAM__C='1a-STUDENT SECONDARY',SEVIS_SUBJECT_CATEGORY__C='Interdisciplinary Studies',SEVIS_SUBJECT_CODE__C='Intercultural/Multicultural and Diversity Studies 30.2301',PROGRAM_READY_DATE__C=date.newInstance(2013,12,24));
    insert eng;
    
    
    
      //Insert PT Account
    Account ptAccountS = new Account(LASTNAME='TestJordanovS C',FIRSTNAME='Martin',TYPE='Participant',RECORDTYPEID=getRecordType('Participant','Account'),OWNERSHIP=sysAdmin.Id,CURRENCYISOCODE='USD',OWNERID=sysAdmin.Id,CREATEDDATE=datetime.now(),CREATEDBYID=sysAdmin.Id,LASTMODIFIEDDATE=datetime.now(),LASTMODIFIEDBYID=sysAdmin.Id,PERSONMAILINGSTREET='Prvi maj 17',PERSONMAILINGCITY='Kochani',PERSONMAILINGPOSTALCODE='2300',PERSONMAILINGCOUNTRY='SG',PERSONMOBILEPHONE='78612678',PERSONOTHERPHONE='(38933) 276297',PERSONEMAIL='martinjordanov@ymail.com.ayii',PERSONBIRTHDATE=date.newInstance(1997,01,10),PERSONHASOPTEDOUTOFEMAIL=FALSE,PERSONHASOPTEDOUTOFFAX=FALSE,PERSONDONOTCALL=FALSE,INTRAX_PROGRAMS__C='Ayusa',STATUS__C='Contracted',INTRAX_REGION__C='United States',INTRAX_PROGRAM_OPTIONS__C='YES;Ayusa High School',J1_EXPERIENCE__C=FALSE,GENDER__PC='Male',CITIZENSHIP__PC='Lithuania',ENGLISH_LEVEL__PC='Advanced',BIRTH_COUNTRY__PC='Lithuania',BIRTH_CITY__PC='Kochahi',LEGAL_RESIDENCE__PC='Lithuania',NATIONALITY__PC='Lithuanian');
    insert ptAccountS;
    //Insert PT Opportunity
    Opportunity ptOppS = new Opportunity (Name = 'TestMartinS JordanovPT-AY2014', ACCOUNTID=PTAccount.Id,RECORDTYPEID=getRecordType('Ayusa PT','Opportunity'),STAGENAME='Closed Won',PROBABILITY=100,CLOSEDATE=date.NewInstance(2013,8,22),TYPE='Participant',LEADSOURCE='',CURRENCYISOCODE='USD',OWNERID='00530000004X9a6AAC',PROGRAM_YEAR__C='',INTRAX_PROGRAMS__C='Ayusa',COUNTRIES_OF_INTEREST__C='',LEAD_SOURCE_TAG__C='',PAX__C=1,INTRAX_PROGRAM_OPTIONS__C='YES;Ayusa High School',AGREEMENT_STATUS__C='No Agreement',JOB_DESC_STATUS__C='Not Started',INTRAX_REGION__C='United States',BILL_ORGANIZER__C=TRUE,INFO_SESSION_TYPE__C='Skype',STUDENT_GENDER_PREFERENCE__C='No Preference',SYS_ADMIN_TAG__C='AYII PT Migration Test');
    insert ptOppS;
    Id ptRtIdS = getRecordType('Participant','Account');
    
    
    //Engagement__c eng = new Engagement__c(Name='test',ACCOUNT_ID__C=ptAccount.Id);
    Engagement__c engS = new Engagement__c(name='TestEngS',OWNERID=sysAdmin.Id,CURRENCYISOCODE='USD',RECORDTYPEID=getRecordType('Ayusa PT','Engagement__c'),CREATEDBYID=sysAdmin.Id,ACCOUNT_ID__C=ptAccount.Id,ENGAGEMENT_END__C=date.newInstance(2014,12,23),ENGAGEMENT_START__C=date.newInstance(2013,12,25),INTRAX_PROGRAM_OPTIONS__C='Ayusa High School;YES',INTRAX_PROGRAM__C='Ayusa',INTRAX_REGION__C='United States',STATUS__C='Program Ready',TERMS_ACCEPTED__C=FALSE,TYPE__C='Participant',FLEXIBLE_DATES__C=FALSE,FLEXIBLE_LOCATION__C=FALSE,INTERESTS_TOP__C='Basketball;Music;Soccer',LIVE_WITH_PETS__C='Yes',LIVE_WITH_SMOKER__C='No',PROGRAM_DURATION__C='Academic Year',CENTER_DISCLOSURE_ACCEPTED__C=FALSE,INT_ORG_FUNDING__C=FALSE,OTHER_FINANCIAL_SUPPORT__C=TRUE,OTHER_ORG_FUNDING__C=FALSE,PERSONAL_FUNDS__C=999,PROGRAM_SPONSOR_FUNDS__C=FALSE,RECEIVED_US_GOVT_FUNDS__C=FALSE,SEVIS_POSITION__C='223-SECONDARY SCHOOL STUDENT',SEVIS_PROGRAM__C='1a-STUDENT SECONDARY',SEVIS_SUBJECT_CATEGORY__C='Interdisciplinary Studies',SEVIS_SUBJECT_CODE__C='Intercultural/Multicultural and Diversity Studies 30.2301',PROGRAM_READY_DATE__C=date.newInstance(2013,12,24));
    insert engS;
    
    //Insert HF Account
    Account HFAccount = new Account(LASTNAME='Adams',FIRSTNAME='Patrick',TYPE='Host Family',RECORDTYPEID=getRecordType('Participant','Account'),OWNERSHIP=sysAdmin.Id,CURRENCYISOCODE='USD',OWNERID=sysAdmin.Id,CREATEDBYID=sysAdmin.Id,LASTMODIFIEDBYID=sysAdmin.Id,PERSONMAILINGSTREET='59179 423rd Ave',PERSONMAILINGCITY='Mazeppa',PERSONMAILINGPOSTALCODE='55956',PERSONMAILINGCOUNTRY='United States',PERSONMOBILEPHONE='',PERSONOTHERPHONE='',PERSONEMAIL='smada1@yahoo.com.ayii',PERSONBIRTHDATE=date.newInstance(1997,01,10),PERSONHASOPTEDOUTOFEMAIL=FALSE,PERSONHASOPTEDOUTOFFAX=FALSE,PERSONDONOTCALL=FALSE,INTRAX_PROGRAMS__C='Ayusa',STATUS__C='Active',INTRAX_REGION__C='United States',INTRAX_PROGRAM_OPTIONS__C='Ayusa High School',J1_EXPERIENCE__C=FALSE,GENDER__PC='Unknown',CITIZENSHIP__PC='United States',ENGLISH_LEVEL__PC='',BIRTH_COUNTRY__PC='',BIRTH_CITY__PC='',LEGAL_RESIDENCE__PC='',NATIONALITY__PC='');
    insert HFAccount;
    //Insert HFOpportunity
    Opportunity HFOpp = new Opportunity(Name='TestPatrick AdamsHF_AY2014',ACCOUNTID=HFAccount.Id,RECORDTYPEID=getRecordType('Host Family','Opportunity'),STAGENAME='Closed Won',PROBABILITY=100,CLOSEDATE=date.NewInstance(2013,8,22),TYPE='Host Family',LEADSOURCE='Partner',FORECASTCATEGORYNAME='Closed',CURRENCYISOCODE='USD',OWNERID='00530000004X9a6AAC',PROGRAM_YEAR__C='2014',INTRAX_PROGRAMS__C='Ayusa',COUNTRIES_OF_INTEREST__C='United States',LEAD_SOURCE_TAG__C='Nemo Migration',PAX__C=1,INTRAX_PROGRAM_OPTIONS__C='Ayusa High School',AGREEMENT_STATUS__C='No Agreement',JOB_DESC_STATUS__C='Not Started',INTRAX_REGION__C='United States',BILL_ORGANIZER__C=TRUE,INFO_SESSION_TYPE__C='Skype',STUDENT_GENDER_PREFERENCE__C='No Preference',SYS_ADMIN_TAG__C='Nemo Match Convert');
    Insert HFOpp;
    //Insert Members
    Member__c member1 = new Member__c(NAME='Patrick Adams',CURRENCYISOCODE='USD',CREATEDBYID=SysAdmin.Id,ACCOUNT_NAME__C=HFAccount.Id,DATE_OF_BIRTH__C=date.newInstance(1967,10,29),EMAIL__C='smada1@yahoo.com',EMPLOYER_NAME__C='Rochester Outdoor Living',FIRST_NAME__C='Patrick',GENDER__C='Male',INTRAX_LEGACY_ID__C='',LAST_NAME__C='Adams',MIDDLE_NAME__C='H.',MOBILE__C='(507) 208-1325',PROFESSION__C='Foreman/installer',RESIDENCY_STATUS__C='Full-Time',ROLE__C='Host',TITLE__C='Foreman',FAMILY_MEMBER__C=FALSE);
    insert member1;
    Member__c member2 =  new Member__c(NAME='Samuel Adams',CURRENCYISOCODE='USD',CREATEDBYID=SysAdmin.Id,ACCOUNT_NAME__C=HFAccount.Id,DATE_OF_BIRTH__C=date.newInstance(1999,1,10),EMAIL__C='',EMPLOYER_NAME__C='',FIRST_NAME__C='Samuel',GENDER__C='Male',INTRAX_LEGACY_ID__C='41910',LAST_NAME__C='Adams',MIDDLE_NAME__C='',MOBILE__C='',PROFESSION__C='Student',RESIDENCY_STATUS__C='',ROLE__C='Child',TITLE__C='',FAMILY_MEMBER__C=FALSE);
    insert member2;
    Member__c member3 =  new Member__c(NAME='Sara Adams',CURRENCYISOCODE='USD',CREATEDBYID=SysAdmin.Id,ACCOUNT_NAME__C=HFAccount.Id,DATE_OF_BIRTH__C=date.newInstance(1964,11,9),EMAIL__C='',EMPLOYER_NAME__C='',FIRST_NAME__C='Sara',GENDER__C='Female',INTRAX_LEGACY_ID__C='778987',LAST_NAME__C='Adams',MIDDLE_NAME__C='M.',MOBILE__C='',PROFESSION__C='Database Administration',RESIDENCY_STATUS__C='Full-Time',ROLE__C='Spouse or Partner',TITLE__C='',FAMILY_MEMBER__C=FALSE);
    insert member3;
    Member__c member4 =  new Member__c(NAME='Aaron Adams',CURRENCYISOCODE='USD',CREATEDBYID=SysAdmin.Id,ACCOUNT_NAME__C=HFAccount.Id,DATE_OF_BIRTH__C=date.newInstance(1997,4,10),EMAIL__C='',EMPLOYER_NAME__C='',FIRST_NAME__C='Aaron',GENDER__C='Male',INTRAX_LEGACY_ID__C='41909',LAST_NAME__C='Adams',MIDDLE_NAME__C='',MOBILE__C='',PROFESSION__C='Student',RESIDENCY_STATUS__C='',ROLE__C='Child',TITLE__C='',FAMILY_MEMBER__C=FALSE);
    insert member4;
    //Insert Position
    Position__c position = new Position__c(OWNERID=SysAdmin.Id,NAME='Patrick Adams',CURRENCYISOCODE='USD',RECORDTYPEID=getRecordType('Ayusa HF','Position__c'),ENGAGEMENT_START__C=date.newInstance(2013,8,21),ENGAGEMENT_END__C=date.newInstance(2014,6,2),STREET__C='1 High Street',CITY__C='San Francisco',STATE__C='CA',POSTAL_CODE__C='94108',COUNTRY__C='United States',HOST_COMPANY_ID__C=HFAccount.Id,INTRAX_PROGRAM__C='Ayusa',INTRAX_REGION__C='United States',STATUS__C='Closed - Filled',INTRAX_PROGRAM_OPTIONS__C='Ayusa High School',SYS_ADMIN_TAG__C='Nemo Match Convert',FLEXIBLE_DATES__C=FALSE,GENDER_PREFERENCE__C='No Preference',SCHOOL_CATEGORY__C='Public',TYPE__C='Host Family',PRIMARY_ACTIVITY_SITE__C=FALSE,SEVIS_UEV_SOA_EDIT__C=TRUE,ACCEPTS_COUPLES__C=FALSE,ACCEPTS_GROUPS__C=FALSE,REQUIRES_INTERVIEW__C=FALSE,OVERTIME_AVAILABLE__C=FALSE);
    insert position;
    Account school = new Account(NAME='Athens High School',TYPE='Institution',INSTITUTION_TYPE__C='Secondary',GS_DISTRICT_NAME__C='Athens City',RECORDTYPEID=getRecordType('Institution','Account'),OWNERSHIP=sysAdmin.Id,CURRENCYISOCODE='USD',OWNERID=sysAdmin.Id,CREATEDBYID=sysAdmin.Id,LASTMODIFIEDBYID=sysAdmin.Id,PERSONMAILINGSTREET='',PERSONMAILINGCITY='',PERSONMAILINGPOSTALCODE='',PERSONMAILINGCOUNTRY='',PERSONMOBILEPHONE='',PERSONOTHERPHONE='',PERSONEMAIL='',PERSONHASOPTEDOUTOFEMAIL=FALSE,PERSONHASOPTEDOUTOFFAX=FALSE,PERSONDONOTCALL=FALSE,INTRAX_PROGRAMS__C='Ayusa',STATUS__C='Prospect',INTRAX_REGION__C='United States',INTRAX_PROGRAM_OPTIONS__C='Ayusa High School',J1_EXPERIENCE__C=FALSE);
    insert school;
    
    Match__c match = new Match__c(Participant_Opportunity_Id__c = ptOpp.Id ,CURRENCYISOCODE='USD',RECORDTYPEID=getRecordType('Ayusa','Match__c'),POSITION_NAME__C=Position.Id,PARTICIPANT_ID__C=PTAccount.Id,STATUS__C='Confirmed',MATCH_DATE__C=date.newInstance(2013,4,24),SYS_ADMIN_TAG__C='Ayusa Migration Test',START_DATE__C=date.newInstance(2013,12,25),END_DATE__C=date.newInstance(2014,7,1),ENGAGEMENT__C=eng.Id,MATCH_TYPE__C='Permanent',DOUBLE_PLACEMENT_INDICATED__C=FALSE,SNK_INDICATED__C=FALSE,SEVIS_UEV_SOA_ADD__C=FALSE,SINGLE_NO_CHILDREN_INDICATED__C=FALSE,IS_PRIMARY_SOA__C=FALSE,DIRECT_PLACEMENT__C=FALSE,VALIDATION_VISIT_DUE_DATE__C=date.newInstance(2013,10,14),CONSIDER_OTHER_POSITIONS__C=FALSE,SCHOOL_ID__C=School.Id,MCASSEXISTS__C=FALSE);
    insert match;
    update match;
    System.debug('MatchRecord:'+match);
    List<Match__c> matchcheck = [Select m.Position_Name__c, m.Participant_Id__c, m.Engagement__c, m.Is_Primary_SOA__c,m.School_Id__c From Match__c m where Engagement__c = :eng.Id and m.Status__c = 'Confirmed' and SEVIS_UEV_SOA_Add__c = false order by LastModifiedDate asc];
    System.debug('MatchRecordcheck:'+matchcheck);
   Engagement__c updatedEng = [select Sevis__c from Engagement__c where Id = :eng.Id];
    System.debug('updatedEng'+updatedEng);
    list<Sevis__c> sevis = [select Id,SEVIS_When_Downloaded__c from Sevis__c where Id = :updatedEng.Sevis__c ];
    
    
    Test.startTest();
    ApexPages.StandardController scnomatchS = new ApexPages.StandardController(eng);
    SevisWrapper.isTest=true;
    SevisWrapper swnomatchS = new SevisWrapper(scnomatchS);
    swnomatchS.packageData();
       
    
    ApexPages.StandardController sc2 = new ApexPages.StandardController(eng);
    SevisWrapper.isTest=true;
    SevisWrapper sw2 = new SevisWrapper(sc2);
    //sw2.packageData();
    
   
    
    
    
    iSevisWebServiceWrapper.Dependent testDep = new iSevisWebServiceWrapper.Dependent();

    //Assume response is received - Record should be unlocked
    if(sevis.size() > 0)
    {
        System.runAs(sysAdmin){
            sevis[0].SEVIS_When_Downloaded__c = System.now();
            sevis[0].SEVIS_Ack_Received_At__c = System.now();
            sevis[0].SEVIS_ID__c = '123';
            update sevis[0];
        }
    }

    ptAccount.Sevis_UEV_Bio__c = true;
    update ptAccount;
    
    school.Sevis_UEV_SOA_Edit__c = true;
    update school;
    
    position.Sevis_UEV_SOA_Edit__c = true;
    update position;
    
    eng.Sevis_UEV_Bio__c = true;
    eng.Sevis_UEV_Pro_Amend__c = true;
    eng.Sevis_UEV_SOA_Edit__c = true;
    eng.Sevis_UEV_Val_USAdd__c = true;
    eng.Sevis_UEV_U_USAdd__c = true;
    //eng.Sevis_UEV_SOA_Add__c = true;
    
    update eng;
    
    //Try sending again but need to do some updates above with SEVIS ID
    ApexPages.StandardController sc3 = new ApexPages.StandardController(eng);
    SevisWrapper.isTest=true;
    SevisWrapper sw3 = new SevisWrapper(sc3);
    sw3.packageData();
    
    ApexPages.StandardController sc33 = new ApexPages.StandardController(engS);
    SevisWrapper.isTest=true;
    SevisWrapper sw33 = new SevisWrapper(sc33);
    sw33.packageData();
   /* 
    Accommodation_Site__c accosite = new Accommodation_Site__c(Name='test',Street__c='123 abc',State__c='CA',Postal_Code__c='94945',City__c='abc',Sevis_UEV_Val_USAdd__c=true,Country__c='United States');
    insert accosite;
    Accommodation__c acco = new Accommodation__c(Accommodation_Site__c=accosite.Id,Engagement__c=eng.Id);
    insert acco;*/
    //update accosite;
    Test.stopTest();
}

static testmethod void sevisTester4(){ 
    
    
    User sysAdmin = [select Id from User where userName = :Constants.SYS_ADMIN ];
    
    Date dob = date.newInstance(1997,01,10);
    iGeoLocateTriggerHelper.isTest = true;
    
    //Insert PT Account
    Account ptAccount = new Account(LASTNAME='TestJordanov C',FIRSTNAME='Martin',TYPE='Participant',RECORDTYPEID=getRecordType('Participant','Account'),OWNERSHIP=sysAdmin.Id,CURRENCYISOCODE='USD',OWNERID=sysAdmin.Id,CREATEDDATE=datetime.now(),CREATEDBYID=sysAdmin.Id,LASTMODIFIEDDATE=datetime.now(),LASTMODIFIEDBYID=sysAdmin.Id,PERSONMAILINGSTREET='Prvi maj 17',PERSONMAILINGCITY='Kochani',PERSONMAILINGPOSTALCODE='2300',PERSONMAILINGCOUNTRY='SG',PERSONMOBILEPHONE='78612678',PERSONOTHERPHONE='(38933) 276297',PERSONEMAIL='martinjordanov@ymail.com.ayii',PERSONBIRTHDATE=date.newInstance(1997,01,10),PERSONHASOPTEDOUTOFEMAIL=FALSE,PERSONHASOPTEDOUTOFFAX=FALSE,PERSONDONOTCALL=FALSE,INTRAX_PROGRAMS__C='Ayusa',STATUS__C='Contracted',INTRAX_REGION__C='United States',INTRAX_PROGRAM_OPTIONS__C='YES;Ayusa High School',J1_EXPERIENCE__C=FALSE,GENDER__PC='Male',CITIZENSHIP__PC='Lithuania',ENGLISH_LEVEL__PC='Advanced',BIRTH_COUNTRY__PC='Lithuania',BIRTH_CITY__PC='Kochahi',LEGAL_RESIDENCE__PC='Lithuania',NATIONALITY__PC='Lithuanian');
    insert ptAccount;
    //Insert PT Opportunity
    Opportunity ptOpp = new Opportunity (Name = 'TestMartin JordanovPT-AY2014', ACCOUNTID=PTAccount.Id,RECORDTYPEID=getRecordType('ICD Intern PT','Opportunity'),STAGENAME='Closed Won',PROBABILITY=100,CLOSEDATE=date.NewInstance(2013,8,22),TYPE='Participant',LEADSOURCE='',CURRENCYISOCODE='USD',OWNERID='00530000004X9a6AAC',PROGRAM_YEAR__C='',INTRAX_PROGRAMS__C='Ayusa',COUNTRIES_OF_INTEREST__C='',LEAD_SOURCE_TAG__C='',PAX__C=1,INTRAX_PROGRAM_OPTIONS__C='YES;Ayusa High School',AGREEMENT_STATUS__C='No Agreement',JOB_DESC_STATUS__C='Not Started',INTRAX_REGION__C='United States',BILL_ORGANIZER__C=TRUE,INFO_SESSION_TYPE__C='Skype',STUDENT_GENDER_PREFERENCE__C='No Preference',SYS_ADMIN_TAG__C='AYII PT Migration Test');
    insert ptOpp;
    Id ptRtId = getRecordType('Participant','Account');
    
    
    //Engagement__c eng = new Engagement__c(Name='test',ACCOUNT_ID__C=ptAccount.Id);
    Engagement__c eng = new Engagement__c(name='TestEng',OWNERID=sysAdmin.Id,CURRENCYISOCODE='USD',RECORDTYPEID=getRecordType('ICD Intern PT','Engagement__c'),CREATEDBYID=sysAdmin.Id,ACCOUNT_ID__C=ptAccount.Id,ENGAGEMENT_END__C=date.newInstance(2014,12,23),ENGAGEMENT_START__C=date.newInstance(2013,12,25),INTRAX_PROGRAM_OPTIONS__C='Ayusa High School;YES',INTRAX_PROGRAM__C='Internship',INTRAX_REGION__C='United States',STATUS__C='Program Ready',TERMS_ACCEPTED__C=FALSE,TYPE__C='Participant',FLEXIBLE_DATES__C=FALSE,FLEXIBLE_LOCATION__C=FALSE,INTERESTS_TOP__C='Basketball;Music;Soccer',LIVE_WITH_PETS__C='Yes',LIVE_WITH_SMOKER__C='No',PROGRAM_DURATION__C='Academic Year',CENTER_DISCLOSURE_ACCEPTED__C=FALSE,INT_ORG_FUNDING__C=FALSE,OTHER_FINANCIAL_SUPPORT__C=TRUE,OTHER_ORG_FUNDING__C=FALSE,PERSONAL_FUNDS__C=999,PROGRAM_SPONSOR_FUNDS__C=FALSE,RECEIVED_US_GOVT_FUNDS__C=FALSE,SEVIS_POSITION__C='223-SECONDARY SCHOOL STUDENT',SEVIS_PROGRAM__C='1a-STUDENT SECONDARY',SEVIS_SUBJECT_CATEGORY__C='Interdisciplinary Studies',SEVIS_SUBJECT_CODE__C='Intercultural/Multicultural and Diversity Studies 30.2301',PROGRAM_READY_DATE__C=date.newInstance(2013,12,24));
    insert eng;
    
    
    
      //Insert PT Account
    Account ptAccountS = new Account(LASTNAME='TestJordanovS C',FIRSTNAME='Martin',TYPE='Participant',RECORDTYPEID=getRecordType('Participant','Account'),OWNERSHIP=sysAdmin.Id,CURRENCYISOCODE='USD',OWNERID=sysAdmin.Id,CREATEDDATE=datetime.now(),CREATEDBYID=sysAdmin.Id,LASTMODIFIEDDATE=datetime.now(),LASTMODIFIEDBYID=sysAdmin.Id,PERSONMAILINGSTREET='Prvi maj 17',PERSONMAILINGCITY='Kochani',PERSONMAILINGPOSTALCODE='2300',PERSONMAILINGCOUNTRY='SG',PERSONMOBILEPHONE='78612678',PERSONOTHERPHONE='(38933) 276297',PERSONEMAIL='martinjordanov@ymail.com.ayii',PERSONBIRTHDATE=date.newInstance(1997,01,10),PERSONHASOPTEDOUTOFEMAIL=FALSE,PERSONHASOPTEDOUTOFFAX=FALSE,PERSONDONOTCALL=FALSE,INTRAX_PROGRAMS__C='Ayusa',STATUS__C='Contracted',INTRAX_REGION__C='United States',INTRAX_PROGRAM_OPTIONS__C='YES;Ayusa High School',J1_EXPERIENCE__C=FALSE,GENDER__PC='Male',CITIZENSHIP__PC='Lithuania',ENGLISH_LEVEL__PC='Advanced',BIRTH_COUNTRY__PC='Lithuania',BIRTH_CITY__PC='Kochahi',LEGAL_RESIDENCE__PC='Lithuania',NATIONALITY__PC='Lithuanian');
    insert ptAccountS;
    //Insert PT Opportunity
    Opportunity ptOppS = new Opportunity (Name = 'TestMartinS JordanovPT-AY2014', ACCOUNTID=PTAccount.Id,RECORDTYPEID=getRecordType('ICD Intern PT','Opportunity'),STAGENAME='Closed Won',PROBABILITY=100,CLOSEDATE=date.NewInstance(2013,8,22),TYPE='Participant',LEADSOURCE='',CURRENCYISOCODE='USD',OWNERID='00530000004X9a6AAC',PROGRAM_YEAR__C='',INTRAX_PROGRAMS__C='Ayusa',COUNTRIES_OF_INTEREST__C='',LEAD_SOURCE_TAG__C='',PAX__C=1,INTRAX_PROGRAM_OPTIONS__C='YES;Ayusa High School',AGREEMENT_STATUS__C='No Agreement',JOB_DESC_STATUS__C='Not Started',INTRAX_REGION__C='United States',BILL_ORGANIZER__C=TRUE,INFO_SESSION_TYPE__C='Skype',STUDENT_GENDER_PREFERENCE__C='No Preference',SYS_ADMIN_TAG__C='AYII PT Migration Test');
    insert ptOppS;
    Id ptRtIdS = getRecordType('Participant','Account');
    
    
    //Engagement__c eng = new Engagement__c(Name='test',ACCOUNT_ID__C=ptAccount.Id);
    Engagement__c engS = new Engagement__c(name='TestEngS',OWNERID=sysAdmin.Id,CURRENCYISOCODE='USD',RECORDTYPEID=getRecordType('ICD Intern PT','Engagement__c'),CREATEDBYID=sysAdmin.Id,ACCOUNT_ID__C=ptAccount.Id,ENGAGEMENT_END__C=date.newInstance(2014,12,23),ENGAGEMENT_START__C=date.newInstance(2013,12,25),INTRAX_PROGRAM_OPTIONS__C='Ayusa High School;YES',INTRAX_PROGRAM__C='Ayusa',INTRAX_REGION__C='United States',STATUS__C='Program Ready',TERMS_ACCEPTED__C=FALSE,TYPE__C='Participant',FLEXIBLE_DATES__C=FALSE,FLEXIBLE_LOCATION__C=FALSE,INTERESTS_TOP__C='Basketball;Music;Soccer',LIVE_WITH_PETS__C='Yes',LIVE_WITH_SMOKER__C='No',PROGRAM_DURATION__C='Academic Year',CENTER_DISCLOSURE_ACCEPTED__C=FALSE,INT_ORG_FUNDING__C=FALSE,OTHER_FINANCIAL_SUPPORT__C=TRUE,OTHER_ORG_FUNDING__C=FALSE,PERSONAL_FUNDS__C=999,PROGRAM_SPONSOR_FUNDS__C=FALSE,RECEIVED_US_GOVT_FUNDS__C=FALSE,SEVIS_POSITION__C='223-SECONDARY SCHOOL STUDENT',SEVIS_PROGRAM__C='1a-STUDENT SECONDARY',SEVIS_SUBJECT_CATEGORY__C='Interdisciplinary Studies',SEVIS_SUBJECT_CODE__C='Intercultural/Multicultural and Diversity Studies 30.2301',PROGRAM_READY_DATE__C=date.newInstance(2013,12,24));
    insert engS;
    
    //Insert HF Account
    Account HFAccount = new Account(LASTNAME='Adams',FIRSTNAME='Patrick',TYPE='Host Family',RECORDTYPEID=getRecordType('Participant','Account'),OWNERSHIP=sysAdmin.Id,CURRENCYISOCODE='USD',OWNERID=sysAdmin.Id,CREATEDBYID=sysAdmin.Id,LASTMODIFIEDBYID=sysAdmin.Id,PERSONMAILINGSTREET='59179 423rd Ave',PERSONMAILINGCITY='Mazeppa',PERSONMAILINGPOSTALCODE='55956',PERSONMAILINGCOUNTRY='United States',PERSONMOBILEPHONE='',PERSONOTHERPHONE='',PERSONEMAIL='smada1@yahoo.com.ayii',PERSONBIRTHDATE=date.newInstance(1997,01,10),PERSONHASOPTEDOUTOFEMAIL=FALSE,PERSONHASOPTEDOUTOFFAX=FALSE,PERSONDONOTCALL=FALSE,INTRAX_PROGRAMS__C='Ayusa',STATUS__C='Active',INTRAX_REGION__C='United States',INTRAX_PROGRAM_OPTIONS__C='Ayusa High School',J1_EXPERIENCE__C=FALSE,GENDER__PC='Unknown',CITIZENSHIP__PC='United States',ENGLISH_LEVEL__PC='',BIRTH_COUNTRY__PC='',BIRTH_CITY__PC='',LEGAL_RESIDENCE__PC='',NATIONALITY__PC='');
    insert HFAccount;
    //Insert HFOpportunity
    Opportunity HFOpp = new Opportunity(Name='TestPatrick AdamsHF_AY2014',ACCOUNTID=HFAccount.Id,RECORDTYPEID=getRecordType('Host Family','Opportunity'),STAGENAME='Closed Won',PROBABILITY=100,CLOSEDATE=date.NewInstance(2013,8,22),TYPE='Host Family',LEADSOURCE='Partner',FORECASTCATEGORYNAME='Closed',CURRENCYISOCODE='USD',OWNERID='00530000004X9a6AAC',PROGRAM_YEAR__C='2014',INTRAX_PROGRAMS__C='Internship',COUNTRIES_OF_INTEREST__C='United States',LEAD_SOURCE_TAG__C='Nemo Migration',PAX__C=1,INTRAX_PROGRAM_OPTIONS__C='Ayusa High School',AGREEMENT_STATUS__C='No Agreement',JOB_DESC_STATUS__C='Not Started',INTRAX_REGION__C='United States',BILL_ORGANIZER__C=TRUE,INFO_SESSION_TYPE__C='Skype',STUDENT_GENDER_PREFERENCE__C='No Preference',SYS_ADMIN_TAG__C='Nemo Match Convert');
    Insert HFOpp;
    //Insert Members
    Member__c member1 = new Member__c(NAME='Patrick Adams',CURRENCYISOCODE='USD',CREATEDBYID=SysAdmin.Id,ACCOUNT_NAME__C=HFAccount.Id,DATE_OF_BIRTH__C=date.newInstance(1967,10,29),EMAIL__C='smada1@yahoo.com',EMPLOYER_NAME__C='Rochester Outdoor Living',FIRST_NAME__C='Patrick',GENDER__C='Male',INTRAX_LEGACY_ID__C='',LAST_NAME__C='Adams',MIDDLE_NAME__C='H.',MOBILE__C='(507) 208-1325',PROFESSION__C='Foreman/installer',RESIDENCY_STATUS__C='Full-Time',ROLE__C='Host',TITLE__C='Foreman',FAMILY_MEMBER__C=FALSE);
    insert member1;
    Member__c member2 =  new Member__c(NAME='Samuel Adams',CURRENCYISOCODE='USD',CREATEDBYID=SysAdmin.Id,ACCOUNT_NAME__C=HFAccount.Id,DATE_OF_BIRTH__C=date.newInstance(1999,1,10),EMAIL__C='',EMPLOYER_NAME__C='',FIRST_NAME__C='Samuel',GENDER__C='Male',INTRAX_LEGACY_ID__C='41910',LAST_NAME__C='Adams',MIDDLE_NAME__C='',MOBILE__C='',PROFESSION__C='Student',RESIDENCY_STATUS__C='',ROLE__C='Child',TITLE__C='',FAMILY_MEMBER__C=FALSE);
    insert member2;
    Member__c member3 =  new Member__c(NAME='Sara Adams',CURRENCYISOCODE='USD',CREATEDBYID=SysAdmin.Id,ACCOUNT_NAME__C=HFAccount.Id,DATE_OF_BIRTH__C=date.newInstance(1964,11,9),EMAIL__C='',EMPLOYER_NAME__C='',FIRST_NAME__C='Sara',GENDER__C='Female',INTRAX_LEGACY_ID__C='778987',LAST_NAME__C='Adams',MIDDLE_NAME__C='M.',MOBILE__C='',PROFESSION__C='Database Administration',RESIDENCY_STATUS__C='Full-Time',ROLE__C='Spouse or Partner',TITLE__C='',FAMILY_MEMBER__C=FALSE);
    insert member3;
    Member__c member4 =  new Member__c(NAME='Aaron Adams',CURRENCYISOCODE='USD',CREATEDBYID=SysAdmin.Id,ACCOUNT_NAME__C=HFAccount.Id,DATE_OF_BIRTH__C=date.newInstance(1997,4,10),EMAIL__C='',EMPLOYER_NAME__C='',FIRST_NAME__C='Aaron',GENDER__C='Male',INTRAX_LEGACY_ID__C='41909',LAST_NAME__C='Adams',MIDDLE_NAME__C='',MOBILE__C='',PROFESSION__C='Student',RESIDENCY_STATUS__C='',ROLE__C='Child',TITLE__C='',FAMILY_MEMBER__C=FALSE);
    insert member4;
    //Insert Position
    Position__c position = new Position__c(OWNERID=SysAdmin.Id,NAME='Patrick Adams',CURRENCYISOCODE='USD',Tipped_Position__c = 'No', RECORDTYPEID=getRecordType('ICD Intern PT','Position__c'),ENGAGEMENT_START__C=date.newInstance(2013,8,21),ENGAGEMENT_END__C=date.newInstance(2014,6,2),STREET__C='1 High Street',CITY__C='San Francisco',STATE__C='CA',POSTAL_CODE__C='94108',COUNTRY__C='United States',HOST_COMPANY_ID__C=HFAccount.Id,INTRAX_PROGRAM__C='Internship',INTRAX_REGION__C='United States',STATUS__C='Closed - Filled',INTRAX_PROGRAM_OPTIONS__C='Ayusa High School',SYS_ADMIN_TAG__C='Nemo Match Convert',FLEXIBLE_DATES__C=FALSE,GENDER_PREFERENCE__C='No Preference',SCHOOL_CATEGORY__C='Public',TYPE__C='Host Family',PRIMARY_ACTIVITY_SITE__C=FALSE,SEVIS_UEV_SOA_EDIT__C=TRUE,ACCEPTS_COUPLES__C=FALSE,ACCEPTS_GROUPS__C=FALSE,REQUIRES_INTERVIEW__C=FALSE,OVERTIME_AVAILABLE__C=FALSE);
    insert position;
    Account school = new Account(NAME='Athens High School',TYPE='Institution',INSTITUTION_TYPE__C='Secondary',GS_DISTRICT_NAME__C='Athens City',RECORDTYPEID=getRecordType('Institution','Account'),OWNERSHIP=sysAdmin.Id,CURRENCYISOCODE='USD',OWNERID=sysAdmin.Id,CREATEDBYID=sysAdmin.Id,LASTMODIFIEDBYID=sysAdmin.Id,PERSONMAILINGSTREET='',PERSONMAILINGCITY='',PERSONMAILINGPOSTALCODE='',PERSONMAILINGCOUNTRY='',PERSONMOBILEPHONE='',PERSONOTHERPHONE='',PERSONEMAIL='',PERSONHASOPTEDOUTOFEMAIL=FALSE,PERSONHASOPTEDOUTOFFAX=FALSE,PERSONDONOTCALL=FALSE,INTRAX_PROGRAMS__C='Ayusa',STATUS__C='Prospect',INTRAX_REGION__C='United States',INTRAX_PROGRAM_OPTIONS__C='Ayusa High School',J1_EXPERIENCE__C=FALSE);
    insert school;
    
    Match__c match = new Match__c(Participant_Opportunity_Id__c = ptOpp.Id ,CURRENCYISOCODE='USD',RECORDTYPEID=getRecordType('Internship','Match__c'),POSITION_NAME__C=Position.Id,PARTICIPANT_ID__C=PTAccount.Id,STATUS__C='Confirmed',MATCH_DATE__C=date.newInstance(2013,4,24),SYS_ADMIN_TAG__C='Ayusa Migration Test',START_DATE__C=date.newInstance(2013,12,25),END_DATE__C=date.newInstance(2014,7,1),ENGAGEMENT__C=eng.Id,MATCH_TYPE__C='Permanent',DOUBLE_PLACEMENT_INDICATED__C=FALSE,SNK_INDICATED__C=FALSE,SEVIS_UEV_SOA_ADD__C=FALSE,SINGLE_NO_CHILDREN_INDICATED__C=FALSE,IS_PRIMARY_SOA__C=FALSE,DIRECT_PLACEMENT__C=FALSE,VALIDATION_VISIT_DUE_DATE__C=date.newInstance(2013,10,14),CONSIDER_OTHER_POSITIONS__C=FALSE,SCHOOL_ID__C=School.Id,MCASSEXISTS__C=FALSE);
    insert match;
    update match;
    Development_Plan__c dev = new Development_Plan__c(Name = 'Test Dev Plan', Match_Name__c = match.Id,Phase__c=1,Description__c = 'test test',Start__c = date.newInstance(2016,06,23), End__c = date.newInstance(2016,06,29));
    insert dev;
    System.debug('MatchRecord:'+match);
    List<Match__c> matchcheck = [Select m.Position_Name__c, m.Participant_Id__c, m.Engagement__c, m.Is_Primary_SOA__c,m.School_Id__c From Match__c m where Engagement__c = :eng.Id and m.Status__c = 'Confirmed' and SEVIS_UEV_SOA_Add__c = false order by LastModifiedDate asc];
    System.debug('MatchRecordcheck:'+matchcheck);
   Engagement__c updatedEng = [select Sevis__c from Engagement__c where Id = :eng.Id];
    System.debug('updatedEng'+updatedEng);
    list<Sevis__c> sevis = [select Id,SEVIS_When_Downloaded__c from Sevis__c where Id = :updatedEng.Sevis__c ];
    
    
    Test.startTest();
    ApexPages.StandardController scnomatchS = new ApexPages.StandardController(eng);
    SevisWrapper.isTest=true;
    SevisWrapper swnomatchS = new SevisWrapper(scnomatchS);
    swnomatchS.packageData();
       
    
    ApexPages.StandardController sc2 = new ApexPages.StandardController(eng);
    SevisWrapper.isTest=true;
    SevisWrapper sw2 = new SevisWrapper(sc2);
    //sw2.packageData();
    
   
    
    
    
    iSevisWebServiceWrapper.Dependent testDep = new iSevisWebServiceWrapper.Dependent();

    //Assume response is received - Record should be unlocked
    if(sevis.size() > 0)
    {
        System.runAs(sysAdmin){
            sevis[0].SEVIS_When_Downloaded__c = System.now();
            sevis[0].SEVIS_Ack_Received_At__c = System.now();
            sevis[0].SEVIS_ID__c = '123';
            update sevis[0];
        }
    }

    ptAccount.Sevis_UEV_Bio__c = true;
    update ptAccount;
    
    school.Sevis_UEV_SOA_Edit__c = true;
    update school;
    
    position.Sevis_UEV_SOA_Edit__c = true;
    update position;
    
    eng.SEVIS_Update_EV_Add_TIPP__c = true;
   // eng.Sevis_UEV_Pro_Amend__c = true;
   // eng.Sevis_UEV_SOA_Edit__c = true;
   // eng.Sevis_UEV_Val_USAdd__c = true;
   // eng.Sevis_UEV_U_USAdd__c = true;
    //eng.Sevis_UEV_SOA_Add__c = true;
    
    update eng;
    
    //Try sending again but need to do some updates above with SEVIS ID
    ApexPages.StandardController sc3 = new ApexPages.StandardController(eng);
    SevisWrapper.isTest=true;
    SevisWrapper sw3 = new SevisWrapper(sc3);
    sw3.packageData();
    
    ApexPages.StandardController sc33 = new ApexPages.StandardController(engS);
    SevisWrapper.isTest=true;
    SevisWrapper sw33 = new SevisWrapper(sc33);
    sw33.packageData();
   /* 
    Accommodation_Site__c accosite = new Accommodation_Site__c(Name='test',Street__c='123 abc',State__c='CA',Postal_Code__c='94945',City__c='abc',Sevis_UEV_Val_USAdd__c=true,Country__c='United States');
    insert accosite;
    Accommodation__c acco = new Accommodation__c(Accommodation_Site__c=accosite.Id,Engagement__c=eng.Id);
    insert acco;*/
    //update accosite;
    Test.stopTest();
}

static testmethod void sevisTester5(){  
    
    
    User sysAdmin = [select Id from User where userName = :Constants.SYS_ADMIN ];
    
    Date dob = date.newInstance(1997,01,10);
    iGeoLocateTriggerHelper.isTest = true;
    
    //Insert PT Account
    Account ptAccount = new Account(LASTNAME='TestJordanov C',FIRSTNAME='Martin',TYPE='Participant',RECORDTYPEID=getRecordType('Participant','Account'),OWNERSHIP=sysAdmin.Id,CURRENCYISOCODE='USD',OWNERID=sysAdmin.Id,CREATEDDATE=datetime.now(),CREATEDBYID=sysAdmin.Id,LASTMODIFIEDDATE=datetime.now(),LASTMODIFIEDBYID=sysAdmin.Id,PERSONMAILINGSTREET='Prvi maj 17',PERSONMAILINGCITY='Kochani',PERSONMAILINGPOSTALCODE='2300',PERSONMAILINGCOUNTRY='SG',PERSONMOBILEPHONE='78612678',PERSONOTHERPHONE='(38933) 276297',PERSONEMAIL='martinjordanov@ymail.com.ayii',PERSONBIRTHDATE=date.newInstance(1997,01,10),PERSONHASOPTEDOUTOFEMAIL=FALSE,PERSONHASOPTEDOUTOFFAX=FALSE,PERSONDONOTCALL=FALSE,INTRAX_PROGRAMS__C='Ayusa',STATUS__C='Contracted',INTRAX_REGION__C='United States',INTRAX_PROGRAM_OPTIONS__C='YES;Ayusa High School',J1_EXPERIENCE__C=FALSE,GENDER__PC='Male',CITIZENSHIP__PC='Lithuania',ENGLISH_LEVEL__PC='Advanced',BIRTH_COUNTRY__PC='Lithuania',BIRTH_CITY__PC='Kochahi',LEGAL_RESIDENCE__PC='Lithuania',NATIONALITY__PC='Lithuanian');
    insert ptAccount;
    //Insert PT Opportunity
    Opportunity ptOpp = new Opportunity (Name = 'TestMartin JordanovPT-AY2014', ACCOUNTID=PTAccount.Id,RECORDTYPEID=getRecordType('ICD Intern PT','Opportunity'),STAGENAME='Closed Won',PROBABILITY=100,CLOSEDATE=date.NewInstance(2013,8,22),TYPE='Participant',LEADSOURCE='',CURRENCYISOCODE='USD',OWNERID='00530000004X9a6AAC',PROGRAM_YEAR__C='',INTRAX_PROGRAMS__C='Ayusa',COUNTRIES_OF_INTEREST__C='',LEAD_SOURCE_TAG__C='',PAX__C=1,INTRAX_PROGRAM_OPTIONS__C='YES;Ayusa High School',AGREEMENT_STATUS__C='No Agreement',JOB_DESC_STATUS__C='Not Started',INTRAX_REGION__C='United States',BILL_ORGANIZER__C=TRUE,INFO_SESSION_TYPE__C='Skype',STUDENT_GENDER_PREFERENCE__C='No Preference',SYS_ADMIN_TAG__C='AYII PT Migration Test');
    insert ptOpp;
    Id ptRtId = getRecordType('Participant','Account');
    
    Sevis__c newSev = new Sevis__c(Name='Test Sevis');
    insert newSev;
    
    //Engagement__c eng = new Engagement__c(Name='test',ACCOUNT_ID__C=ptAccount.Id);
    Engagement__c eng = new Engagement__c(name='TestEng',Sevis__c=newSev.Id, OWNERID=sysAdmin.Id,CURRENCYISOCODE='USD',RECORDTYPEID=getRecordType('ICD Intern PT','Engagement__c'),CREATEDBYID=sysAdmin.Id,ACCOUNT_ID__C=ptAccount.Id,ENGAGEMENT_END__C=date.newInstance(2014,12,23),ENGAGEMENT_START__C=date.newInstance(2013,12,25),INTRAX_PROGRAM_OPTIONS__C='Ayusa High School;YES',INTRAX_PROGRAM__C='Internship',INTRAX_REGION__C='United States',STATUS__C='Program Ready',TERMS_ACCEPTED__C=FALSE,TYPE__C='Participant',FLEXIBLE_DATES__C=FALSE,FLEXIBLE_LOCATION__C=FALSE,INTERESTS_TOP__C='Basketball;Music;Soccer',LIVE_WITH_PETS__C='Yes',LIVE_WITH_SMOKER__C='No',PROGRAM_DURATION__C='Academic Year',CENTER_DISCLOSURE_ACCEPTED__C=FALSE,INT_ORG_FUNDING__C=FALSE,OTHER_FINANCIAL_SUPPORT__C=TRUE,OTHER_ORG_FUNDING__C=FALSE,PERSONAL_FUNDS__C=999,PROGRAM_SPONSOR_FUNDS__C=FALSE,RECEIVED_US_GOVT_FUNDS__C=FALSE,SEVIS_POSITION__C='223-SECONDARY SCHOOL STUDENT',SEVIS_PROGRAM__C='1a-STUDENT SECONDARY',SEVIS_SUBJECT_CATEGORY__C='Interdisciplinary Studies',SEVIS_SUBJECT_CODE__C='Intercultural/Multicultural and Diversity Studies 30.2301',PROGRAM_READY_DATE__C=date.newInstance(2013,12,24));
    insert eng;
    
    
    
      //Insert PT Account
    Account ptAccountS = new Account(LASTNAME='TestJordanovS C',FIRSTNAME='Martin',TYPE='Participant',RECORDTYPEID=getRecordType('Participant','Account'),OWNERSHIP=sysAdmin.Id,CURRENCYISOCODE='USD',OWNERID=sysAdmin.Id,CREATEDDATE=datetime.now(),CREATEDBYID=sysAdmin.Id,LASTMODIFIEDDATE=datetime.now(),LASTMODIFIEDBYID=sysAdmin.Id,PERSONMAILINGSTREET='Prvi maj 17',PERSONMAILINGCITY='Kochani',PERSONMAILINGPOSTALCODE='2300',PERSONMAILINGCOUNTRY='SG',PERSONMOBILEPHONE='78612678',PERSONOTHERPHONE='(38933) 276297',PERSONEMAIL='martinjordanov@ymail.com.ayii',PERSONBIRTHDATE=date.newInstance(1997,01,10),PERSONHASOPTEDOUTOFEMAIL=FALSE,PERSONHASOPTEDOUTOFFAX=FALSE,PERSONDONOTCALL=FALSE,INTRAX_PROGRAMS__C='Ayusa',STATUS__C='Contracted',INTRAX_REGION__C='United States',INTRAX_PROGRAM_OPTIONS__C='YES;Ayusa High School',J1_EXPERIENCE__C=FALSE,GENDER__PC='Male',CITIZENSHIP__PC='Lithuania',ENGLISH_LEVEL__PC='Advanced',BIRTH_COUNTRY__PC='Lithuania',BIRTH_CITY__PC='Kochahi',LEGAL_RESIDENCE__PC='Lithuania',NATIONALITY__PC='Lithuanian');
    insert ptAccountS;
    //Insert PT Opportunity
    Opportunity ptOppS = new Opportunity (Name = 'TestMartinS JordanovPT-AY2014', ACCOUNTID=PTAccount.Id,RECORDTYPEID=getRecordType('ICD Intern PT','Opportunity'),STAGENAME='Closed Won',PROBABILITY=100,CLOSEDATE=date.NewInstance(2013,8,22),TYPE='Participant',LEADSOURCE='',CURRENCYISOCODE='USD',OWNERID='00530000004X9a6AAC',PROGRAM_YEAR__C='',INTRAX_PROGRAMS__C='Ayusa',COUNTRIES_OF_INTEREST__C='',LEAD_SOURCE_TAG__C='',PAX__C=1,INTRAX_PROGRAM_OPTIONS__C='YES;Ayusa High School',AGREEMENT_STATUS__C='No Agreement',JOB_DESC_STATUS__C='Not Started',INTRAX_REGION__C='United States',BILL_ORGANIZER__C=TRUE,INFO_SESSION_TYPE__C='Skype',STUDENT_GENDER_PREFERENCE__C='No Preference',SYS_ADMIN_TAG__C='AYII PT Migration Test');
    insert ptOppS;
    Id ptRtIdS = getRecordType('Participant','Account');
    
    
    //Engagement__c eng = new Engagement__c(Name='test',ACCOUNT_ID__C=ptAccount.Id);
    Engagement__c engS = new Engagement__c(name='TestEngS',OWNERID=sysAdmin.Id,CURRENCYISOCODE='USD',RECORDTYPEID=getRecordType('ICD Intern PT','Engagement__c'),CREATEDBYID=sysAdmin.Id,ACCOUNT_ID__C=ptAccount.Id,ENGAGEMENT_END__C=date.newInstance(2014,12,23),ENGAGEMENT_START__C=date.newInstance(2013,12,25),INTRAX_PROGRAM_OPTIONS__C='Ayusa High School;YES',INTRAX_PROGRAM__C='Ayusa',INTRAX_REGION__C='United States',STATUS__C='Program Ready',TERMS_ACCEPTED__C=FALSE,TYPE__C='Participant',FLEXIBLE_DATES__C=FALSE,FLEXIBLE_LOCATION__C=FALSE,INTERESTS_TOP__C='Basketball;Music;Soccer',LIVE_WITH_PETS__C='Yes',LIVE_WITH_SMOKER__C='No',PROGRAM_DURATION__C='Academic Year',CENTER_DISCLOSURE_ACCEPTED__C=FALSE,INT_ORG_FUNDING__C=FALSE,OTHER_FINANCIAL_SUPPORT__C=TRUE,OTHER_ORG_FUNDING__C=FALSE,PERSONAL_FUNDS__C=999,PROGRAM_SPONSOR_FUNDS__C=FALSE,RECEIVED_US_GOVT_FUNDS__C=FALSE,SEVIS_POSITION__C='223-SECONDARY SCHOOL STUDENT',SEVIS_PROGRAM__C='1a-STUDENT SECONDARY',SEVIS_SUBJECT_CATEGORY__C='Interdisciplinary Studies',SEVIS_SUBJECT_CODE__C='Intercultural/Multicultural and Diversity Studies 30.2301',PROGRAM_READY_DATE__C=date.newInstance(2013,12,24));
    insert engS;
    
    //Insert HF Account
    Account HFAccount = new Account(LASTNAME='Adams',FIRSTNAME='Patrick',TYPE='Host Family',RECORDTYPEID=getRecordType('Participant','Account'),OWNERSHIP=sysAdmin.Id,CURRENCYISOCODE='USD',OWNERID=sysAdmin.Id,CREATEDBYID=sysAdmin.Id,LASTMODIFIEDBYID=sysAdmin.Id,PERSONMAILINGSTREET='59179 423rd Ave',PERSONMAILINGCITY='Mazeppa',PERSONMAILINGPOSTALCODE='55956',PERSONMAILINGCOUNTRY='United States',PERSONMOBILEPHONE='',PERSONOTHERPHONE='',PERSONEMAIL='smada1@yahoo.com.ayii',PERSONBIRTHDATE=date.newInstance(1997,01,10),PERSONHASOPTEDOUTOFEMAIL=FALSE,PERSONHASOPTEDOUTOFFAX=FALSE,PERSONDONOTCALL=FALSE,INTRAX_PROGRAMS__C='Ayusa',STATUS__C='Active',INTRAX_REGION__C='United States',INTRAX_PROGRAM_OPTIONS__C='Ayusa High School',J1_EXPERIENCE__C=FALSE,GENDER__PC='Unknown',CITIZENSHIP__PC='United States',ENGLISH_LEVEL__PC='',BIRTH_COUNTRY__PC='',BIRTH_CITY__PC='',LEGAL_RESIDENCE__PC='',NATIONALITY__PC='');
    insert HFAccount;
    //Insert HFOpportunity
    Opportunity HFOpp = new Opportunity(Name='TestPatrick AdamsHF_AY2014',ACCOUNTID=HFAccount.Id,RECORDTYPEID=getRecordType('Host Family','Opportunity'),STAGENAME='Closed Won',PROBABILITY=100,CLOSEDATE=date.NewInstance(2013,8,22),TYPE='Host Family',LEADSOURCE='Partner',FORECASTCATEGORYNAME='Closed',CURRENCYISOCODE='USD',OWNERID='00530000004X9a6AAC',PROGRAM_YEAR__C='2014',INTRAX_PROGRAMS__C='Internship',COUNTRIES_OF_INTEREST__C='United States',LEAD_SOURCE_TAG__C='Nemo Migration',PAX__C=1,INTRAX_PROGRAM_OPTIONS__C='Ayusa High School',AGREEMENT_STATUS__C='No Agreement',JOB_DESC_STATUS__C='Not Started',INTRAX_REGION__C='United States',BILL_ORGANIZER__C=TRUE,INFO_SESSION_TYPE__C='Skype',STUDENT_GENDER_PREFERENCE__C='No Preference',SYS_ADMIN_TAG__C='Nemo Match Convert');
    Insert HFOpp;
    //Insert Members
    Member__c member1 = new Member__c(NAME='Patrick Adams',CURRENCYISOCODE='USD',CREATEDBYID=SysAdmin.Id,ACCOUNT_NAME__C=HFAccount.Id,DATE_OF_BIRTH__C=date.newInstance(1967,10,29),EMAIL__C='smada1@yahoo.com',EMPLOYER_NAME__C='Rochester Outdoor Living',FIRST_NAME__C='Patrick',GENDER__C='Male',INTRAX_LEGACY_ID__C='',LAST_NAME__C='Adams',MIDDLE_NAME__C='H.',MOBILE__C='(507) 208-1325',PROFESSION__C='Foreman/installer',RESIDENCY_STATUS__C='Full-Time',ROLE__C='Host',TITLE__C='Foreman',FAMILY_MEMBER__C=FALSE);
    insert member1;
    Member__c member2 =  new Member__c(NAME='Samuel Adams',CURRENCYISOCODE='USD',CREATEDBYID=SysAdmin.Id,ACCOUNT_NAME__C=HFAccount.Id,DATE_OF_BIRTH__C=date.newInstance(1999,1,10),EMAIL__C='',EMPLOYER_NAME__C='',FIRST_NAME__C='Samuel',GENDER__C='Male',INTRAX_LEGACY_ID__C='41910',LAST_NAME__C='Adams',MIDDLE_NAME__C='',MOBILE__C='',PROFESSION__C='Student',RESIDENCY_STATUS__C='',ROLE__C='Child',TITLE__C='',FAMILY_MEMBER__C=FALSE);
    insert member2;
    Member__c member3 =  new Member__c(NAME='Sara Adams',CURRENCYISOCODE='USD',CREATEDBYID=SysAdmin.Id,ACCOUNT_NAME__C=HFAccount.Id,DATE_OF_BIRTH__C=date.newInstance(1964,11,9),EMAIL__C='',EMPLOYER_NAME__C='',FIRST_NAME__C='Sara',GENDER__C='Female',INTRAX_LEGACY_ID__C='778987',LAST_NAME__C='Adams',MIDDLE_NAME__C='M.',MOBILE__C='',PROFESSION__C='Database Administration',RESIDENCY_STATUS__C='Full-Time',ROLE__C='Spouse or Partner',TITLE__C='',FAMILY_MEMBER__C=FALSE);
    insert member3;
    Member__c member4 =  new Member__c(NAME='Aaron Adams',CURRENCYISOCODE='USD',CREATEDBYID=SysAdmin.Id,ACCOUNT_NAME__C=HFAccount.Id,DATE_OF_BIRTH__C=date.newInstance(1997,4,10),EMAIL__C='',EMPLOYER_NAME__C='',FIRST_NAME__C='Aaron',GENDER__C='Male',INTRAX_LEGACY_ID__C='41909',LAST_NAME__C='Adams',MIDDLE_NAME__C='',MOBILE__C='',PROFESSION__C='Student',RESIDENCY_STATUS__C='',ROLE__C='Child',TITLE__C='',FAMILY_MEMBER__C=FALSE);
    insert member4;
    //Insert Position
    Position__c position = new Position__c(OWNERID=SysAdmin.Id,NAME='Patrick Adams',CURRENCYISOCODE='USD',Tipped_Position__c = 'No', RECORDTYPEID=getRecordType('ICD Intern PT','Position__c'),ENGAGEMENT_START__C=date.newInstance(2013,8,21),ENGAGEMENT_END__C=date.newInstance(2014,6,2),STREET__C='1 High Street',CITY__C='San Francisco',STATE__C='CA',POSTAL_CODE__C='94108',COUNTRY__C='United States',HOST_COMPANY_ID__C=HFAccount.Id,INTRAX_PROGRAM__C='Internship',INTRAX_REGION__C='United States',STATUS__C='Closed - Filled',INTRAX_PROGRAM_OPTIONS__C='Ayusa High School',SYS_ADMIN_TAG__C='Nemo Match Convert',FLEXIBLE_DATES__C=FALSE,GENDER_PREFERENCE__C='No Preference',SCHOOL_CATEGORY__C='Public',TYPE__C='Host Family',PRIMARY_ACTIVITY_SITE__C=FALSE,SEVIS_UEV_SOA_EDIT__C=TRUE,ACCEPTS_COUPLES__C=FALSE,ACCEPTS_GROUPS__C=FALSE,REQUIRES_INTERVIEW__C=FALSE,OVERTIME_AVAILABLE__C=FALSE);
    insert position;
    Account school = new Account(NAME='Athens High School',TYPE='Institution',INSTITUTION_TYPE__C='Secondary',GS_DISTRICT_NAME__C='Athens City',RECORDTYPEID=getRecordType('Institution','Account'),OWNERSHIP=sysAdmin.Id,CURRENCYISOCODE='USD',OWNERID=sysAdmin.Id,CREATEDBYID=sysAdmin.Id,LASTMODIFIEDBYID=sysAdmin.Id,PERSONMAILINGSTREET='',PERSONMAILINGCITY='',PERSONMAILINGPOSTALCODE='',PERSONMAILINGCOUNTRY='',PERSONMOBILEPHONE='',PERSONOTHERPHONE='',PERSONEMAIL='',PERSONHASOPTEDOUTOFEMAIL=FALSE,PERSONHASOPTEDOUTOFFAX=FALSE,PERSONDONOTCALL=FALSE,INTRAX_PROGRAMS__C='Ayusa',STATUS__C='Prospect',INTRAX_REGION__C='United States',INTRAX_PROGRAM_OPTIONS__C='Ayusa High School',J1_EXPERIENCE__C=FALSE);
    insert school;
    
    Match__c match = new Match__c(Participant_Opportunity_Id__c = ptOpp.Id ,CURRENCYISOCODE='USD',RECORDTYPEID=getRecordType('Internship','Match__c'),POSITION_NAME__C=Position.Id,PARTICIPANT_ID__C=PTAccount.Id,STATUS__C='Confirmed',MATCH_DATE__C=date.newInstance(2013,4,24),SYS_ADMIN_TAG__C='Ayusa Migration Test',START_DATE__C=date.newInstance(2013,12,25),END_DATE__C=date.newInstance(2014,7,1),ENGAGEMENT__C=eng.Id,MATCH_TYPE__C='Permanent',DOUBLE_PLACEMENT_INDICATED__C=FALSE,SNK_INDICATED__C=FALSE,SEVIS_UEV_SOA_ADD__C=FALSE,SINGLE_NO_CHILDREN_INDICATED__C=FALSE,IS_PRIMARY_SOA__C=FALSE,DIRECT_PLACEMENT__C=FALSE,VALIDATION_VISIT_DUE_DATE__C=date.newInstance(2013,10,14),CONSIDER_OTHER_POSITIONS__C=FALSE,SCHOOL_ID__C=School.Id,MCASSEXISTS__C=FALSE);
    insert match;
    update match;
    Development_Plan__c dev = new Development_Plan__c(Name = 'Test Dev Plan', Match_Name__c = match.Id,Phase__c=1,Description__c = 'test test',Start__c = date.newInstance(2016,06,23), End__c = date.newInstance(2016,06,29));
    insert dev;
    System.debug('MatchRecord:'+match);
    List<Match__c> matchcheck = [Select m.Position_Name__c, m.Participant_Id__c, m.Engagement__c, m.Is_Primary_SOA__c,m.School_Id__c From Match__c m where Engagement__c = :eng.Id and m.Status__c = 'Confirmed' and SEVIS_UEV_SOA_Add__c = false order by LastModifiedDate asc];
    System.debug('MatchRecordcheck:'+matchcheck);
   Engagement__c updatedEng = [select Sevis__c from Engagement__c where Id = :eng.Id];
    System.debug('updatedEng'+updatedEng);
    list<Sevis__c> sevis = [select Id,SEVIS_When_Downloaded__c from Sevis__c where Id = :updatedEng.Sevis__c ];
    
    
    Test.startTest();
    ApexPages.StandardController scnomatchS = new ApexPages.StandardController(eng);
    SevisWrapper.isTest=true;
    SevisWrapper swnomatchS = new SevisWrapper(scnomatchS);
    swnomatchS.packageData();
       
    
    ApexPages.StandardController sc2 = new ApexPages.StandardController(eng);
    SevisWrapper.isTest=true;
    SevisWrapper sw2 = new SevisWrapper(sc2);
    //sw2.packageData();
    
   
    
    
    
    iSevisWebServiceWrapper.Dependent testDep = new iSevisWebServiceWrapper.Dependent();

    //Assume response is received - Record should be unlocked
    if(sevis.size() > 0)
    {
        System.runAs(sysAdmin){
            sevis[0].SEVIS_When_Downloaded__c = System.now();
            sevis[0].SEVIS_Ack_Received_At__c = System.now();
            sevis[0].SEVIS_ID__c = '123';
            update sevis[0];
        }
    }

    ptAccount.Sevis_UEV_Bio__c = true;
    update ptAccount;
    
    school.Sevis_UEV_SOA_Edit__c = true;
    update school;
    
    position.Sevis_UEV_SOA_Edit__c = true;
    update position;
    
    //eng.SEVIS_Update_EV_Add_TIPP__c = true;
    eng.Sevis_UEV_Pro_Amend__c = true;
    eng.Sevis_UEV_SOA_Edit__c = true;
    eng.Sevis_UEV_Val_USAdd__c = true;
    eng.Sevis_UEV_U_USAdd__c = true;
    eng.Sevis_UEV_SOA_Add__c = true;
    
    update eng;
    
    //Try sending again but need to do some updates above with SEVIS ID
    ApexPages.StandardController sc3 = new ApexPages.StandardController(eng);
    SevisWrapper.isTest=true;
    SevisWrapper sw3 = new SevisWrapper(sc3);
    sw3.packageData();
    
    ApexPages.StandardController sc33 = new ApexPages.StandardController(engS);
    SevisWrapper.isTest=true;
    SevisWrapper sw33 = new SevisWrapper(sc33);
    sw33.packageData();
   /* 
    Accommodation_Site__c accosite = new Accommodation_Site__c(Name='test',Street__c='123 abc',State__c='CA',Postal_Code__c='94945',City__c='abc',Sevis_UEV_Val_USAdd__c=true,Country__c='United States');
    insert accosite;
    Accommodation__c acco = new Accommodation__c(Accommodation_Site__c=accosite.Id,Engagement__c=eng.Id);
    insert acco;*/
    //update accosite;
    Test.stopTest();
}

static testmethod void sevisTester6(){  
    
    
    User sysAdmin = [select Id from User where userName = :Constants.SYS_ADMIN ];
    
    Date dob = date.newInstance(1997,01,10);
    iGeoLocateTriggerHelper.isTest = true;
    
    //Insert PT Account
    Account ptAccount = new Account(LASTNAME='TestJordanov C',FIRSTNAME='Martin',TYPE='Participant',RECORDTYPEID=getRecordType('Participant','Account'),OWNERSHIP=sysAdmin.Id,CURRENCYISOCODE='USD',OWNERID=sysAdmin.Id,CREATEDDATE=datetime.now(),CREATEDBYID=sysAdmin.Id,LASTMODIFIEDDATE=datetime.now(),LASTMODIFIEDBYID=sysAdmin.Id,PERSONMAILINGSTREET='Prvi maj 17',PERSONMAILINGCITY='Kochani',PERSONMAILINGPOSTALCODE='2300',PERSONMAILINGCOUNTRY='SG',PERSONMOBILEPHONE='78612678',PERSONOTHERPHONE='(38933) 276297',PERSONEMAIL='martinjordanov@ymail.com.ayii',PERSONBIRTHDATE=date.newInstance(1997,01,10),PERSONHASOPTEDOUTOFEMAIL=FALSE,PERSONHASOPTEDOUTOFFAX=FALSE,PERSONDONOTCALL=FALSE,INTRAX_PROGRAMS__C='Ayusa',STATUS__C='Contracted',INTRAX_REGION__C='United States',INTRAX_PROGRAM_OPTIONS__C='YES;Ayusa High School',J1_EXPERIENCE__C=FALSE,GENDER__PC='Male',CITIZENSHIP__PC='Lithuania',ENGLISH_LEVEL__PC='Advanced',BIRTH_COUNTRY__PC='Lithuania',BIRTH_CITY__PC='Kochahi',LEGAL_RESIDENCE__PC='Lithuania',NATIONALITY__PC='Lithuanian');
    insert ptAccount;
    //Insert PT Opportunity
    Opportunity ptOpp = new Opportunity (Name = 'TestMartin JordanovPT-AY2014', ACCOUNTID=PTAccount.Id,RECORDTYPEID=getRecordType('ICD Intern PT','Opportunity'),STAGENAME='Closed Won',PROBABILITY=100,CLOSEDATE=date.NewInstance(2013,8,22),TYPE='Participant',LEADSOURCE='',CURRENCYISOCODE='USD',OWNERID='00530000004X9a6AAC',PROGRAM_YEAR__C='',INTRAX_PROGRAMS__C='Ayusa',COUNTRIES_OF_INTEREST__C='',LEAD_SOURCE_TAG__C='',PAX__C=1,INTRAX_PROGRAM_OPTIONS__C='YES;Ayusa High School',AGREEMENT_STATUS__C='No Agreement',JOB_DESC_STATUS__C='Not Started',INTRAX_REGION__C='United States',BILL_ORGANIZER__C=TRUE,INFO_SESSION_TYPE__C='Skype',STUDENT_GENDER_PREFERENCE__C='No Preference',SYS_ADMIN_TAG__C='AYII PT Migration Test');
    insert ptOpp;
    Id ptRtId = getRecordType('Participant','Account');
    
    Sevis__c newSev = new Sevis__c(Name='Test Sevis');
    insert newSev;
    
    //Engagement__c eng = new Engagement__c(Name='test',ACCOUNT_ID__C=ptAccount.Id);
    Engagement__c eng = new Engagement__c(name='TestEng',Sevis__c=newSev.Id, OWNERID=sysAdmin.Id,CURRENCYISOCODE='USD',RECORDTYPEID=getRecordType('ICD Intern PT','Engagement__c'),CREATEDBYID=sysAdmin.Id,ACCOUNT_ID__C=ptAccount.Id,ENGAGEMENT_END__C=date.newInstance(2014,12,23),ENGAGEMENT_START__C=date.newInstance(2013,12,25),INTRAX_PROGRAM_OPTIONS__C='Ayusa High School;YES',INTRAX_PROGRAM__C='Internship',INTRAX_REGION__C='United States',STATUS__C='Program Ready',TERMS_ACCEPTED__C=FALSE,TYPE__C='Participant',FLEXIBLE_DATES__C=FALSE,FLEXIBLE_LOCATION__C=FALSE,INTERESTS_TOP__C='Basketball;Music;Soccer',LIVE_WITH_PETS__C='Yes',LIVE_WITH_SMOKER__C='No',PROGRAM_DURATION__C='Academic Year',CENTER_DISCLOSURE_ACCEPTED__C=FALSE,INT_ORG_FUNDING__C=FALSE,OTHER_FINANCIAL_SUPPORT__C=TRUE,OTHER_ORG_FUNDING__C=FALSE,PERSONAL_FUNDS__C=999,PROGRAM_SPONSOR_FUNDS__C=FALSE,RECEIVED_US_GOVT_FUNDS__C=FALSE,SEVIS_POSITION__C='223-SECONDARY SCHOOL STUDENT',SEVIS_PROGRAM__C='1a-STUDENT SECONDARY',SEVIS_SUBJECT_CATEGORY__C='Interdisciplinary Studies',SEVIS_SUBJECT_CODE__C='Intercultural/Multicultural and Diversity Studies 30.2301',PROGRAM_READY_DATE__C=date.newInstance(2013,12,24));
    insert eng;
    
    
    
      //Insert PT Account
    Account ptAccountS = new Account(LASTNAME='TestJordanovS C',FIRSTNAME='Martin',TYPE='Participant',RECORDTYPEID=getRecordType('Participant','Account'),OWNERSHIP=sysAdmin.Id,CURRENCYISOCODE='USD',OWNERID=sysAdmin.Id,CREATEDDATE=datetime.now(),CREATEDBYID=sysAdmin.Id,LASTMODIFIEDDATE=datetime.now(),LASTMODIFIEDBYID=sysAdmin.Id,PERSONMAILINGSTREET='Prvi maj 17',PERSONMAILINGCITY='Kochani',PERSONMAILINGPOSTALCODE='2300',PERSONMAILINGCOUNTRY='SG',PERSONMOBILEPHONE='78612678',PERSONOTHERPHONE='(38933) 276297',PERSONEMAIL='martinjordanov@ymail.com.ayii',PERSONBIRTHDATE=date.newInstance(1997,01,10),PERSONHASOPTEDOUTOFEMAIL=FALSE,PERSONHASOPTEDOUTOFFAX=FALSE,PERSONDONOTCALL=FALSE,INTRAX_PROGRAMS__C='Ayusa',STATUS__C='Contracted',INTRAX_REGION__C='United States',INTRAX_PROGRAM_OPTIONS__C='YES;Ayusa High School',J1_EXPERIENCE__C=FALSE,GENDER__PC='Male',CITIZENSHIP__PC='Lithuania',ENGLISH_LEVEL__PC='Advanced',BIRTH_COUNTRY__PC='Lithuania',BIRTH_CITY__PC='Kochahi',LEGAL_RESIDENCE__PC='Lithuania',NATIONALITY__PC='Lithuanian');
    insert ptAccountS;
    //Insert PT Opportunity
    Opportunity ptOppS = new Opportunity (Name = 'TestMartinS JordanovPT-AY2014', ACCOUNTID=PTAccount.Id,RECORDTYPEID=getRecordType('ICD Intern PT','Opportunity'),STAGENAME='Closed Won',PROBABILITY=100,CLOSEDATE=date.NewInstance(2013,8,22),TYPE='Participant',LEADSOURCE='',CURRENCYISOCODE='USD',OWNERID='00530000004X9a6AAC',PROGRAM_YEAR__C='',INTRAX_PROGRAMS__C='Ayusa',COUNTRIES_OF_INTEREST__C='',LEAD_SOURCE_TAG__C='',PAX__C=1,INTRAX_PROGRAM_OPTIONS__C='YES;Ayusa High School',AGREEMENT_STATUS__C='No Agreement',JOB_DESC_STATUS__C='Not Started',INTRAX_REGION__C='United States',BILL_ORGANIZER__C=TRUE,INFO_SESSION_TYPE__C='Skype',STUDENT_GENDER_PREFERENCE__C='No Preference',SYS_ADMIN_TAG__C='AYII PT Migration Test');
    insert ptOppS;
    Id ptRtIdS = getRecordType('Participant','Account');
    
    
    //Engagement__c eng = new Engagement__c(Name='test',ACCOUNT_ID__C=ptAccount.Id);
    Engagement__c engS = new Engagement__c(name='TestEngS',OWNERID=sysAdmin.Id,CURRENCYISOCODE='USD',RECORDTYPEID=getRecordType('ICD Intern PT','Engagement__c'),CREATEDBYID=sysAdmin.Id,ACCOUNT_ID__C=ptAccount.Id,ENGAGEMENT_END__C=date.newInstance(2014,12,23),ENGAGEMENT_START__C=date.newInstance(2013,12,25),INTRAX_PROGRAM_OPTIONS__C='Ayusa High School;YES',INTRAX_PROGRAM__C='Ayusa',INTRAX_REGION__C='United States',STATUS__C='Program Ready',TERMS_ACCEPTED__C=FALSE,TYPE__C='Participant',FLEXIBLE_DATES__C=FALSE,FLEXIBLE_LOCATION__C=FALSE,INTERESTS_TOP__C='Basketball;Music;Soccer',LIVE_WITH_PETS__C='Yes',LIVE_WITH_SMOKER__C='No',PROGRAM_DURATION__C='Academic Year',CENTER_DISCLOSURE_ACCEPTED__C=FALSE,INT_ORG_FUNDING__C=FALSE,OTHER_FINANCIAL_SUPPORT__C=TRUE,OTHER_ORG_FUNDING__C=FALSE,PERSONAL_FUNDS__C=999,PROGRAM_SPONSOR_FUNDS__C=FALSE,RECEIVED_US_GOVT_FUNDS__C=FALSE,SEVIS_POSITION__C='223-SECONDARY SCHOOL STUDENT',SEVIS_PROGRAM__C='1a-STUDENT SECONDARY',SEVIS_SUBJECT_CATEGORY__C='Interdisciplinary Studies',SEVIS_SUBJECT_CODE__C='Intercultural/Multicultural and Diversity Studies 30.2301',PROGRAM_READY_DATE__C=date.newInstance(2013,12,24));
    insert engS;
    
    //Insert HF Account
    Account HFAccount = new Account(LASTNAME='Adams',FIRSTNAME='Patrick',TYPE='Host Family',RECORDTYPEID=getRecordType('Participant','Account'),OWNERSHIP=sysAdmin.Id,CURRENCYISOCODE='USD',OWNERID=sysAdmin.Id,CREATEDBYID=sysAdmin.Id,LASTMODIFIEDBYID=sysAdmin.Id,PERSONMAILINGSTREET='59179 423rd Ave',PERSONMAILINGCITY='Mazeppa',PERSONMAILINGPOSTALCODE='55956',PERSONMAILINGCOUNTRY='United States',PERSONMOBILEPHONE='',PERSONOTHERPHONE='',PERSONEMAIL='smada1@yahoo.com.ayii',PERSONBIRTHDATE=date.newInstance(1997,01,10),PERSONHASOPTEDOUTOFEMAIL=FALSE,PERSONHASOPTEDOUTOFFAX=FALSE,PERSONDONOTCALL=FALSE,INTRAX_PROGRAMS__C='Ayusa',STATUS__C='Active',INTRAX_REGION__C='United States',INTRAX_PROGRAM_OPTIONS__C='Ayusa High School',J1_EXPERIENCE__C=FALSE,GENDER__PC='Unknown',CITIZENSHIP__PC='United States',ENGLISH_LEVEL__PC='',BIRTH_COUNTRY__PC='',BIRTH_CITY__PC='',LEGAL_RESIDENCE__PC='',NATIONALITY__PC='');
    insert HFAccount;
    //Insert HFOpportunity
    Opportunity HFOpp = new Opportunity(Name='TestPatrick AdamsHF_AY2014',ACCOUNTID=HFAccount.Id,RECORDTYPEID=getRecordType('Host Family','Opportunity'),STAGENAME='Closed Won',PROBABILITY=100,CLOSEDATE=date.NewInstance(2013,8,22),TYPE='Host Family',LEADSOURCE='Partner',FORECASTCATEGORYNAME='Closed',CURRENCYISOCODE='USD',OWNERID='00530000004X9a6AAC',PROGRAM_YEAR__C='2014',INTRAX_PROGRAMS__C='Internship',COUNTRIES_OF_INTEREST__C='United States',LEAD_SOURCE_TAG__C='Nemo Migration',PAX__C=1,INTRAX_PROGRAM_OPTIONS__C='Ayusa High School',AGREEMENT_STATUS__C='No Agreement',JOB_DESC_STATUS__C='Not Started',INTRAX_REGION__C='United States',BILL_ORGANIZER__C=TRUE,INFO_SESSION_TYPE__C='Skype',STUDENT_GENDER_PREFERENCE__C='No Preference',SYS_ADMIN_TAG__C='Nemo Match Convert');
    Insert HFOpp;
    //Insert Members
    Member__c member1 = new Member__c(NAME='Patrick Adams',CURRENCYISOCODE='USD',CREATEDBYID=SysAdmin.Id,ACCOUNT_NAME__C=HFAccount.Id,DATE_OF_BIRTH__C=date.newInstance(1967,10,29),EMAIL__C='smada1@yahoo.com',EMPLOYER_NAME__C='Rochester Outdoor Living',FIRST_NAME__C='Patrick',GENDER__C='Male',INTRAX_LEGACY_ID__C='',LAST_NAME__C='Adams',MIDDLE_NAME__C='H.',MOBILE__C='(507) 208-1325',PROFESSION__C='Foreman/installer',RESIDENCY_STATUS__C='Full-Time',ROLE__C='Host',TITLE__C='Foreman',FAMILY_MEMBER__C=FALSE);
    insert member1;
    Member__c member2 =  new Member__c(NAME='Samuel Adams',CURRENCYISOCODE='USD',CREATEDBYID=SysAdmin.Id,ACCOUNT_NAME__C=HFAccount.Id,DATE_OF_BIRTH__C=date.newInstance(1999,1,10),EMAIL__C='',EMPLOYER_NAME__C='',FIRST_NAME__C='Samuel',GENDER__C='Male',INTRAX_LEGACY_ID__C='41910',LAST_NAME__C='Adams',MIDDLE_NAME__C='',MOBILE__C='',PROFESSION__C='Student',RESIDENCY_STATUS__C='',ROLE__C='Child',TITLE__C='',FAMILY_MEMBER__C=FALSE);
    insert member2;
    Member__c member3 =  new Member__c(NAME='Sara Adams',CURRENCYISOCODE='USD',CREATEDBYID=SysAdmin.Id,ACCOUNT_NAME__C=HFAccount.Id,DATE_OF_BIRTH__C=date.newInstance(1964,11,9),EMAIL__C='',EMPLOYER_NAME__C='',FIRST_NAME__C='Sara',GENDER__C='Female',INTRAX_LEGACY_ID__C='778987',LAST_NAME__C='Adams',MIDDLE_NAME__C='M.',MOBILE__C='',PROFESSION__C='Database Administration',RESIDENCY_STATUS__C='Full-Time',ROLE__C='Spouse or Partner',TITLE__C='',FAMILY_MEMBER__C=FALSE);
    insert member3;
    Member__c member4 =  new Member__c(NAME='Aaron Adams',CURRENCYISOCODE='USD',CREATEDBYID=SysAdmin.Id,ACCOUNT_NAME__C=HFAccount.Id,DATE_OF_BIRTH__C=date.newInstance(1997,4,10),EMAIL__C='',EMPLOYER_NAME__C='',FIRST_NAME__C='Aaron',GENDER__C='Male',INTRAX_LEGACY_ID__C='41909',LAST_NAME__C='Adams',MIDDLE_NAME__C='',MOBILE__C='',PROFESSION__C='Student',RESIDENCY_STATUS__C='',ROLE__C='Child',TITLE__C='',FAMILY_MEMBER__C=FALSE);
    insert member4;
    //Insert Position
    Position__c position = new Position__c(OWNERID=SysAdmin.Id,NAME='Patrick Adams',CURRENCYISOCODE='USD',Tipped_Position__c = 'No', RECORDTYPEID=getRecordType('ICD Intern PT','Position__c'),ENGAGEMENT_START__C=date.newInstance(2013,8,21),ENGAGEMENT_END__C=date.newInstance(2014,6,2),STREET__C='1 High Street',CITY__C='San Francisco',STATE__C='CA',POSTAL_CODE__C='94108',COUNTRY__C='United States',HOST_COMPANY_ID__C=HFAccount.Id,INTRAX_PROGRAM__C='Internship',INTRAX_REGION__C='United States',STATUS__C='Closed - Filled',INTRAX_PROGRAM_OPTIONS__C='Ayusa High School',SYS_ADMIN_TAG__C='Nemo Match Convert',FLEXIBLE_DATES__C=FALSE,GENDER_PREFERENCE__C='No Preference',SCHOOL_CATEGORY__C='Public',TYPE__C='Host Family',PRIMARY_ACTIVITY_SITE__C=FALSE,SEVIS_UEV_SOA_EDIT__C=TRUE,ACCEPTS_COUPLES__C=FALSE,ACCEPTS_GROUPS__C=FALSE,REQUIRES_INTERVIEW__C=FALSE,OVERTIME_AVAILABLE__C=FALSE);
    insert position;
    Account school = new Account(NAME='Athens High School',TYPE='Institution',INSTITUTION_TYPE__C='Secondary',GS_DISTRICT_NAME__C='Athens City',RECORDTYPEID=getRecordType('Institution','Account'),OWNERSHIP=sysAdmin.Id,CURRENCYISOCODE='USD',OWNERID=sysAdmin.Id,CREATEDBYID=sysAdmin.Id,LASTMODIFIEDBYID=sysAdmin.Id,PERSONMAILINGSTREET='',PERSONMAILINGCITY='',PERSONMAILINGPOSTALCODE='',PERSONMAILINGCOUNTRY='',PERSONMOBILEPHONE='',PERSONOTHERPHONE='',PERSONEMAIL='',PERSONHASOPTEDOUTOFEMAIL=FALSE,PERSONHASOPTEDOUTOFFAX=FALSE,PERSONDONOTCALL=FALSE,INTRAX_PROGRAMS__C='Ayusa',STATUS__C='Prospect',INTRAX_REGION__C='United States',INTRAX_PROGRAM_OPTIONS__C='Ayusa High School',J1_EXPERIENCE__C=FALSE);
    insert school;
    
    Match__c match = new Match__c(Participant_Opportunity_Id__c = ptOpp.Id ,CURRENCYISOCODE='USD',RECORDTYPEID=getRecordType('Internship','Match__c'),POSITION_NAME__C=Position.Id,PARTICIPANT_ID__C=PTAccount.Id,STATUS__C='Confirmed',MATCH_DATE__C=date.newInstance(2013,4,24),SYS_ADMIN_TAG__C='Ayusa Migration Test',START_DATE__C=date.newInstance(2013,12,25),END_DATE__C=date.newInstance(2014,7,1),ENGAGEMENT__C=eng.Id,MATCH_TYPE__C='Permanent',DOUBLE_PLACEMENT_INDICATED__C=FALSE,SNK_INDICATED__C=FALSE,SEVIS_UEV_SOA_ADD__C=FALSE,SINGLE_NO_CHILDREN_INDICATED__C=FALSE,IS_PRIMARY_SOA__C=FALSE,DIRECT_PLACEMENT__C=FALSE,VALIDATION_VISIT_DUE_DATE__C=date.newInstance(2013,10,14),CONSIDER_OTHER_POSITIONS__C=FALSE,SCHOOL_ID__C=School.Id,MCASSEXISTS__C=FALSE);
    insert match;
    update match;
    Development_Plan__c dev = new Development_Plan__c(Name = 'Test Dev Plan', Match_Name__c = match.Id,Phase__c=1,Description__c = 'test test',Start__c = date.newInstance(2016,06,23), End__c = date.newInstance(2016,06,29));
    insert dev;
    System.debug('MatchRecord:'+match);
    List<Match__c> matchcheck = [Select m.Position_Name__c, m.Participant_Id__c, m.Engagement__c, m.Is_Primary_SOA__c,m.School_Id__c From Match__c m where Engagement__c = :eng.Id and m.Status__c = 'Confirmed' and SEVIS_UEV_SOA_Add__c = false order by LastModifiedDate asc];
    System.debug('MatchRecordcheck:'+matchcheck);
   Engagement__c updatedEng = [select Sevis__c from Engagement__c where Id = :eng.Id];
    System.debug('updatedEng'+updatedEng);
    list<Sevis__c> sevis = [select Id,SEVIS_When_Downloaded__c from Sevis__c where Id = :updatedEng.Sevis__c ];
    
    
    Test.startTest();
    ApexPages.StandardController scnomatchS = new ApexPages.StandardController(eng);
    SevisWrapper.isTest=true;
    SevisWrapper swnomatchS = new SevisWrapper(scnomatchS);
    swnomatchS.packageData();
       
    
    ApexPages.StandardController sc2 = new ApexPages.StandardController(eng);
    SevisWrapper.isTest=true;
    SevisWrapper sw2 = new SevisWrapper(sc2);
    //sw2.packageData();
    
   
    
    
    
    iSevisWebServiceWrapper.Dependent testDep = new iSevisWebServiceWrapper.Dependent();

    //Assume response is received - Record should be unlocked
    if(sevis.size() > 0)
    {
        System.runAs(sysAdmin){
            sevis[0].SEVIS_When_Downloaded__c = System.now();
            sevis[0].SEVIS_Ack_Received_At__c = System.now();
            sevis[0].SEVIS_ID__c = '123';
            update sevis[0];
        }
    }

    //ptAccount.Sevis_UEV_Bio__c = true;
    //update ptAccount;
    
   // school.Sevis_UEV_SOA_Edit__c = true;
   // update school;
    
   // position.Sevis_UEV_SOA_Edit__c = true;
   // update position;
    
    //eng.SEVIS_Update_EV_Add_TIPP__c = true;
    //eng.Sevis_UEV_Pro_Amend__c = true;
    //eng.Sevis_UEV_SOA_Edit__c = true;
    //eng.Sevis_UEV_Val_USAdd__c = true;
    //eng.Sevis_UEV_U_USAdd__c = true;
    eng.Sevis_UEV_SOA_Add__c = true;
    
    update eng;
    
    //Try sending again but need to do some updates above with SEVIS ID
    ApexPages.StandardController sc3 = new ApexPages.StandardController(eng);
    SevisWrapper.isTest=true;
    SevisWrapper sw3 = new SevisWrapper(sc3);
    sw3.packageData();
    
    ApexPages.StandardController sc33 = new ApexPages.StandardController(engS);
    SevisWrapper.isTest=true;
    SevisWrapper sw33 = new SevisWrapper(sc33);
    sw33.packageData();
   /* 
    Accommodation_Site__c accosite = new Accommodation_Site__c(Name='test',Street__c='123 abc',State__c='CA',Postal_Code__c='94945',City__c='abc',Sevis_UEV_Val_USAdd__c=true,Country__c='United States');
    insert accosite;
    Accommodation__c acco = new Accommodation__c(Accommodation_Site__c=accosite.Id,Engagement__c=eng.Id);
    insert acco;*/
    //update accosite;
    Test.stopTest();
}

static testmethod void sevisTester7(){  
    
    
    User sysAdmin = [select Id from User where userName = :Constants.SYS_ADMIN ];
    
    Date dob = date.newInstance(1997,01,10);
    iGeoLocateTriggerHelper.isTest = true;
    
    //Insert PT Account
    Account ptAccount = new Account(LASTNAME='TestJordanov C',FIRSTNAME='Martin',TYPE='Participant',RECORDTYPEID=getRecordType('Participant','Account'),OWNERSHIP=sysAdmin.Id,CURRENCYISOCODE='USD',OWNERID=sysAdmin.Id,CREATEDDATE=datetime.now(),CREATEDBYID=sysAdmin.Id,LASTMODIFIEDDATE=datetime.now(),LASTMODIFIEDBYID=sysAdmin.Id,PERSONMAILINGSTREET='Prvi maj 17',PERSONMAILINGCITY='Kochani',PERSONMAILINGPOSTALCODE='2300',PERSONMAILINGCOUNTRY='SG',PERSONMOBILEPHONE='78612678',PERSONOTHERPHONE='(38933) 276297',PERSONEMAIL='martinjordanov@ymail.com.ayii',PERSONBIRTHDATE=date.newInstance(1997,01,10),PERSONHASOPTEDOUTOFEMAIL=FALSE,PERSONHASOPTEDOUTOFFAX=FALSE,PERSONDONOTCALL=FALSE,INTRAX_PROGRAMS__C='Ayusa',STATUS__C='Contracted',INTRAX_REGION__C='United States',INTRAX_PROGRAM_OPTIONS__C='YES;Ayusa High School',J1_EXPERIENCE__C=FALSE,GENDER__PC='Male',CITIZENSHIP__PC='Lithuania',ENGLISH_LEVEL__PC='Advanced',BIRTH_COUNTRY__PC='Lithuania',BIRTH_CITY__PC='Kochahi',LEGAL_RESIDENCE__PC='Lithuania',NATIONALITY__PC='Lithuanian');
    insert ptAccount;
    //Insert PT Opportunity
    Opportunity ptOpp = new Opportunity (Name = 'TestMartin JordanovPT-AY2014', ACCOUNTID=PTAccount.Id,RECORDTYPEID=getRecordType('ICD Intern PT','Opportunity'),STAGENAME='Closed Won',PROBABILITY=100,CLOSEDATE=date.NewInstance(2013,8,22),TYPE='Participant',LEADSOURCE='',CURRENCYISOCODE='USD',OWNERID='00530000004X9a6AAC',PROGRAM_YEAR__C='',INTRAX_PROGRAMS__C='Ayusa',COUNTRIES_OF_INTEREST__C='',LEAD_SOURCE_TAG__C='',PAX__C=1,INTRAX_PROGRAM_OPTIONS__C='YES;Ayusa High School',AGREEMENT_STATUS__C='No Agreement',JOB_DESC_STATUS__C='Not Started',INTRAX_REGION__C='United States',BILL_ORGANIZER__C=TRUE,INFO_SESSION_TYPE__C='Skype',STUDENT_GENDER_PREFERENCE__C='No Preference',SYS_ADMIN_TAG__C='AYII PT Migration Test');
    insert ptOpp;
    Id ptRtId = getRecordType('Participant','Account');
    
    Sevis__c newSev = new Sevis__c(Name='Test Sevis');
    insert newSev;
    
    //Engagement__c eng = new Engagement__c(Name='test',ACCOUNT_ID__C=ptAccount.Id);
    Engagement__c eng = new Engagement__c(name='TestEng',Sevis__c=newSev.Id, OWNERID=sysAdmin.Id,CURRENCYISOCODE='USD',RECORDTYPEID=getRecordType('ICD Intern PT','Engagement__c'),CREATEDBYID=sysAdmin.Id,ACCOUNT_ID__C=ptAccount.Id,ENGAGEMENT_END__C=date.newInstance(2014,12,23),ENGAGEMENT_START__C=date.newInstance(2013,12,25),INTRAX_PROGRAM_OPTIONS__C='Ayusa High School;YES',INTRAX_PROGRAM__C='Internship',INTRAX_REGION__C='United States',STATUS__C='Program Ready',TERMS_ACCEPTED__C=FALSE,TYPE__C='Participant',FLEXIBLE_DATES__C=FALSE,FLEXIBLE_LOCATION__C=FALSE,INTERESTS_TOP__C='Basketball;Music;Soccer',LIVE_WITH_PETS__C='Yes',LIVE_WITH_SMOKER__C='No',PROGRAM_DURATION__C='Academic Year',CENTER_DISCLOSURE_ACCEPTED__C=FALSE,INT_ORG_FUNDING__C=FALSE,OTHER_FINANCIAL_SUPPORT__C=TRUE,OTHER_ORG_FUNDING__C=FALSE,PERSONAL_FUNDS__C=999,PROGRAM_SPONSOR_FUNDS__C=FALSE,RECEIVED_US_GOVT_FUNDS__C=FALSE,SEVIS_POSITION__C='223-SECONDARY SCHOOL STUDENT',SEVIS_PROGRAM__C='1a-STUDENT SECONDARY',SEVIS_SUBJECT_CATEGORY__C='Interdisciplinary Studies',SEVIS_SUBJECT_CODE__C='Intercultural/Multicultural and Diversity Studies 30.2301',PROGRAM_READY_DATE__C=date.newInstance(2013,12,24));
    insert eng;
    
    
    
      //Insert PT Account
    Account ptAccountS = new Account(LASTNAME='TestJordanovS C',FIRSTNAME='Martin',TYPE='Participant',RECORDTYPEID=getRecordType('Participant','Account'),OWNERSHIP=sysAdmin.Id,CURRENCYISOCODE='USD',OWNERID=sysAdmin.Id,CREATEDDATE=datetime.now(),CREATEDBYID=sysAdmin.Id,LASTMODIFIEDDATE=datetime.now(),LASTMODIFIEDBYID=sysAdmin.Id,PERSONMAILINGSTREET='Prvi maj 17',PERSONMAILINGCITY='Kochani',PERSONMAILINGPOSTALCODE='2300',PERSONMAILINGCOUNTRY='SG',PERSONMOBILEPHONE='78612678',PERSONOTHERPHONE='(38933) 276297',PERSONEMAIL='martinjordanov@ymail.com.ayii',PERSONBIRTHDATE=date.newInstance(1997,01,10),PERSONHASOPTEDOUTOFEMAIL=FALSE,PERSONHASOPTEDOUTOFFAX=FALSE,PERSONDONOTCALL=FALSE,INTRAX_PROGRAMS__C='Ayusa',STATUS__C='Contracted',INTRAX_REGION__C='United States',INTRAX_PROGRAM_OPTIONS__C='YES;Ayusa High School',J1_EXPERIENCE__C=FALSE,GENDER__PC='Male',CITIZENSHIP__PC='Lithuania',ENGLISH_LEVEL__PC='Advanced',BIRTH_COUNTRY__PC='Lithuania',BIRTH_CITY__PC='Kochahi',LEGAL_RESIDENCE__PC='Lithuania',NATIONALITY__PC='Lithuanian');
    insert ptAccountS;
    //Insert PT Opportunity
    Opportunity ptOppS = new Opportunity (Name = 'TestMartinS JordanovPT-AY2014', ACCOUNTID=PTAccount.Id,RECORDTYPEID=getRecordType('ICD Intern PT','Opportunity'),STAGENAME='Closed Won',PROBABILITY=100,CLOSEDATE=date.NewInstance(2013,8,22),TYPE='Participant',LEADSOURCE='',CURRENCYISOCODE='USD',OWNERID='00530000004X9a6AAC',PROGRAM_YEAR__C='',INTRAX_PROGRAMS__C='Ayusa',COUNTRIES_OF_INTEREST__C='',LEAD_SOURCE_TAG__C='',PAX__C=1,INTRAX_PROGRAM_OPTIONS__C='YES;Ayusa High School',AGREEMENT_STATUS__C='No Agreement',JOB_DESC_STATUS__C='Not Started',INTRAX_REGION__C='United States',BILL_ORGANIZER__C=TRUE,INFO_SESSION_TYPE__C='Skype',STUDENT_GENDER_PREFERENCE__C='No Preference',SYS_ADMIN_TAG__C='AYII PT Migration Test');
    insert ptOppS;
    Id ptRtIdS = getRecordType('Participant','Account');
    
    
    //Engagement__c eng = new Engagement__c(Name='test',ACCOUNT_ID__C=ptAccount.Id);
    Engagement__c engS = new Engagement__c(name='TestEngS',OWNERID=sysAdmin.Id,CURRENCYISOCODE='USD',RECORDTYPEID=getRecordType('ICD Intern PT','Engagement__c'),CREATEDBYID=sysAdmin.Id,ACCOUNT_ID__C=ptAccount.Id,ENGAGEMENT_END__C=date.newInstance(2014,12,23),ENGAGEMENT_START__C=date.newInstance(2013,12,25),INTRAX_PROGRAM_OPTIONS__C='Ayusa High School;YES',INTRAX_PROGRAM__C='Ayusa',INTRAX_REGION__C='United States',STATUS__C='Program Ready',TERMS_ACCEPTED__C=FALSE,TYPE__C='Participant',FLEXIBLE_DATES__C=FALSE,FLEXIBLE_LOCATION__C=FALSE,INTERESTS_TOP__C='Basketball;Music;Soccer',LIVE_WITH_PETS__C='Yes',LIVE_WITH_SMOKER__C='No',PROGRAM_DURATION__C='Academic Year',CENTER_DISCLOSURE_ACCEPTED__C=FALSE,INT_ORG_FUNDING__C=FALSE,OTHER_FINANCIAL_SUPPORT__C=TRUE,OTHER_ORG_FUNDING__C=FALSE,PERSONAL_FUNDS__C=999,PROGRAM_SPONSOR_FUNDS__C=FALSE,RECEIVED_US_GOVT_FUNDS__C=FALSE,SEVIS_POSITION__C='223-SECONDARY SCHOOL STUDENT',SEVIS_PROGRAM__C='1a-STUDENT SECONDARY',SEVIS_SUBJECT_CATEGORY__C='Interdisciplinary Studies',SEVIS_SUBJECT_CODE__C='Intercultural/Multicultural and Diversity Studies 30.2301',PROGRAM_READY_DATE__C=date.newInstance(2013,12,24));
    insert engS;
    
    //Insert HF Account
    Account HFAccount = new Account(LASTNAME='Adams',FIRSTNAME='Patrick',TYPE='Host Family',RECORDTYPEID=getRecordType('Participant','Account'),OWNERSHIP=sysAdmin.Id,CURRENCYISOCODE='USD',OWNERID=sysAdmin.Id,CREATEDBYID=sysAdmin.Id,LASTMODIFIEDBYID=sysAdmin.Id,PERSONMAILINGSTREET='59179 423rd Ave',PERSONMAILINGCITY='Mazeppa',PERSONMAILINGPOSTALCODE='55956',PERSONMAILINGCOUNTRY='United States',PERSONMOBILEPHONE='',PERSONOTHERPHONE='',PERSONEMAIL='smada1@yahoo.com.ayii',PERSONBIRTHDATE=date.newInstance(1997,01,10),PERSONHASOPTEDOUTOFEMAIL=FALSE,PERSONHASOPTEDOUTOFFAX=FALSE,PERSONDONOTCALL=FALSE,INTRAX_PROGRAMS__C='Ayusa',STATUS__C='Active',INTRAX_REGION__C='United States',INTRAX_PROGRAM_OPTIONS__C='Ayusa High School',J1_EXPERIENCE__C=FALSE,GENDER__PC='Unknown',CITIZENSHIP__PC='United States',ENGLISH_LEVEL__PC='',BIRTH_COUNTRY__PC='',BIRTH_CITY__PC='',LEGAL_RESIDENCE__PC='',NATIONALITY__PC='');
    insert HFAccount;
    //Insert HFOpportunity
    Opportunity HFOpp = new Opportunity(Name='TestPatrick AdamsHF_AY2014',ACCOUNTID=HFAccount.Id,RECORDTYPEID=getRecordType('Host Family','Opportunity'),STAGENAME='Closed Won',PROBABILITY=100,CLOSEDATE=date.NewInstance(2013,8,22),TYPE='Host Family',LEADSOURCE='Partner',FORECASTCATEGORYNAME='Closed',CURRENCYISOCODE='USD',OWNERID='00530000004X9a6AAC',PROGRAM_YEAR__C='2014',INTRAX_PROGRAMS__C='Internship',COUNTRIES_OF_INTEREST__C='United States',LEAD_SOURCE_TAG__C='Nemo Migration',PAX__C=1,INTRAX_PROGRAM_OPTIONS__C='Ayusa High School',AGREEMENT_STATUS__C='No Agreement',JOB_DESC_STATUS__C='Not Started',INTRAX_REGION__C='United States',BILL_ORGANIZER__C=TRUE,INFO_SESSION_TYPE__C='Skype',STUDENT_GENDER_PREFERENCE__C='No Preference',SYS_ADMIN_TAG__C='Nemo Match Convert');
    Insert HFOpp;
    //Insert Members
    Member__c member1 = new Member__c(NAME='Patrick Adams',CURRENCYISOCODE='USD',CREATEDBYID=SysAdmin.Id,ACCOUNT_NAME__C=HFAccount.Id,DATE_OF_BIRTH__C=date.newInstance(1967,10,29),EMAIL__C='smada1@yahoo.com',EMPLOYER_NAME__C='Rochester Outdoor Living',FIRST_NAME__C='Patrick',GENDER__C='Male',INTRAX_LEGACY_ID__C='',LAST_NAME__C='Adams',MIDDLE_NAME__C='H.',MOBILE__C='(507) 208-1325',PROFESSION__C='Foreman/installer',RESIDENCY_STATUS__C='Full-Time',ROLE__C='Host',TITLE__C='Foreman',FAMILY_MEMBER__C=FALSE);
    insert member1;
    Member__c member2 =  new Member__c(NAME='Samuel Adams',CURRENCYISOCODE='USD',CREATEDBYID=SysAdmin.Id,ACCOUNT_NAME__C=HFAccount.Id,DATE_OF_BIRTH__C=date.newInstance(1999,1,10),EMAIL__C='',EMPLOYER_NAME__C='',FIRST_NAME__C='Samuel',GENDER__C='Male',INTRAX_LEGACY_ID__C='41910',LAST_NAME__C='Adams',MIDDLE_NAME__C='',MOBILE__C='',PROFESSION__C='Student',RESIDENCY_STATUS__C='',ROLE__C='Child',TITLE__C='',FAMILY_MEMBER__C=FALSE);
    insert member2;
    Member__c member3 =  new Member__c(NAME='Sara Adams',CURRENCYISOCODE='USD',CREATEDBYID=SysAdmin.Id,ACCOUNT_NAME__C=HFAccount.Id,DATE_OF_BIRTH__C=date.newInstance(1964,11,9),EMAIL__C='',EMPLOYER_NAME__C='',FIRST_NAME__C='Sara',GENDER__C='Female',INTRAX_LEGACY_ID__C='778987',LAST_NAME__C='Adams',MIDDLE_NAME__C='M.',MOBILE__C='',PROFESSION__C='Database Administration',RESIDENCY_STATUS__C='Full-Time',ROLE__C='Spouse or Partner',TITLE__C='',FAMILY_MEMBER__C=FALSE);
    insert member3;
    Member__c member4 =  new Member__c(NAME='Aaron Adams',CURRENCYISOCODE='USD',CREATEDBYID=SysAdmin.Id,ACCOUNT_NAME__C=HFAccount.Id,DATE_OF_BIRTH__C=date.newInstance(1997,4,10),EMAIL__C='',EMPLOYER_NAME__C='',FIRST_NAME__C='Aaron',GENDER__C='Male',INTRAX_LEGACY_ID__C='41909',LAST_NAME__C='Adams',MIDDLE_NAME__C='',MOBILE__C='',PROFESSION__C='Student',RESIDENCY_STATUS__C='',ROLE__C='Child',TITLE__C='',FAMILY_MEMBER__C=FALSE);
    insert member4;
    //Insert Position
    Position__c position = new Position__c(OWNERID=SysAdmin.Id,NAME='Patrick Adams',CURRENCYISOCODE='USD',Tipped_Position__c = 'No', RECORDTYPEID=getRecordType('ICD Intern PT','Position__c'),ENGAGEMENT_START__C=date.newInstance(2013,8,21),ENGAGEMENT_END__C=date.newInstance(2014,6,2),STREET__C='1 High Street',CITY__C='San Francisco',STATE__C='CA',POSTAL_CODE__C='94108',COUNTRY__C='United States',HOST_COMPANY_ID__C=HFAccount.Id,INTRAX_PROGRAM__C='Internship',INTRAX_REGION__C='United States',STATUS__C='Closed - Filled',INTRAX_PROGRAM_OPTIONS__C='Ayusa High School',SYS_ADMIN_TAG__C='Nemo Match Convert',FLEXIBLE_DATES__C=FALSE,GENDER_PREFERENCE__C='No Preference',SCHOOL_CATEGORY__C='Public',TYPE__C='Host Family',PRIMARY_ACTIVITY_SITE__C=FALSE,SEVIS_UEV_SOA_EDIT__C=TRUE,ACCEPTS_COUPLES__C=FALSE,ACCEPTS_GROUPS__C=FALSE,REQUIRES_INTERVIEW__C=FALSE,OVERTIME_AVAILABLE__C=FALSE);
    insert position;
    Account school = new Account(NAME='Athens High School',TYPE='Institution',INSTITUTION_TYPE__C='Secondary',GS_DISTRICT_NAME__C='Athens City',RECORDTYPEID=getRecordType('Institution','Account'),OWNERSHIP=sysAdmin.Id,CURRENCYISOCODE='USD',OWNERID=sysAdmin.Id,CREATEDBYID=sysAdmin.Id,LASTMODIFIEDBYID=sysAdmin.Id,PERSONMAILINGSTREET='',PERSONMAILINGCITY='',PERSONMAILINGPOSTALCODE='',PERSONMAILINGCOUNTRY='',PERSONMOBILEPHONE='',PERSONOTHERPHONE='',PERSONEMAIL='',PERSONHASOPTEDOUTOFEMAIL=FALSE,PERSONHASOPTEDOUTOFFAX=FALSE,PERSONDONOTCALL=FALSE,INTRAX_PROGRAMS__C='Ayusa',STATUS__C='Prospect',INTRAX_REGION__C='United States',INTRAX_PROGRAM_OPTIONS__C='Ayusa High School',J1_EXPERIENCE__C=FALSE);
    insert school;
    
    Match__c match = new Match__c(Participant_Opportunity_Id__c = ptOpp.Id ,CURRENCYISOCODE='USD',RECORDTYPEID=getRecordType('Internship','Match__c'),POSITION_NAME__C=Position.Id,PARTICIPANT_ID__C=PTAccount.Id,STATUS__C='Confirmed',MATCH_DATE__C=date.newInstance(2013,4,24),SYS_ADMIN_TAG__C='Ayusa Migration Test',START_DATE__C=date.newInstance(2013,12,25),END_DATE__C=date.newInstance(2014,7,1),ENGAGEMENT__C=eng.Id,MATCH_TYPE__C='Permanent',DOUBLE_PLACEMENT_INDICATED__C=FALSE,SNK_INDICATED__C=FALSE,SEVIS_UEV_SOA_ADD__C=FALSE,SINGLE_NO_CHILDREN_INDICATED__C=FALSE,IS_PRIMARY_SOA__C=FALSE,DIRECT_PLACEMENT__C=FALSE,VALIDATION_VISIT_DUE_DATE__C=date.newInstance(2013,10,14),CONSIDER_OTHER_POSITIONS__C=FALSE,SCHOOL_ID__C=School.Id,MCASSEXISTS__C=FALSE);
    insert match;
    update match;
    Development_Plan__c dev = new Development_Plan__c(Name = 'Test Dev Plan', Match_Name__c = match.Id,Phase__c=1,Description__c = 'test test',Start__c = date.newInstance(2016,06,23), End__c = date.newInstance(2016,06,29));
    insert dev;
    System.debug('MatchRecord:'+match);
    List<Match__c> matchcheck = [Select m.Position_Name__c, m.Participant_Id__c, m.Engagement__c, m.Is_Primary_SOA__c,m.School_Id__c From Match__c m where Engagement__c = :eng.Id and m.Status__c = 'Confirmed' and SEVIS_UEV_SOA_Add__c = false order by LastModifiedDate asc];
    System.debug('MatchRecordcheck:'+matchcheck);
   Engagement__c updatedEng = [select Sevis__c from Engagement__c where Id = :eng.Id];
    System.debug('updatedEng'+updatedEng);
    list<Sevis__c> sevis = [select Id,SEVIS_When_Downloaded__c from Sevis__c where Id = :updatedEng.Sevis__c ];
    
    
    Test.startTest();
    ApexPages.StandardController scnomatchS = new ApexPages.StandardController(eng);
    SevisWrapper.isTest=true;
    SevisWrapper swnomatchS = new SevisWrapper(scnomatchS);
    swnomatchS.packageData();
       
    
    ApexPages.StandardController sc2 = new ApexPages.StandardController(eng);
    SevisWrapper.isTest=true;
    SevisWrapper sw2 = new SevisWrapper(sc2);
    //sw2.packageData();
    
   
    
    
    
    iSevisWebServiceWrapper.Dependent testDep = new iSevisWebServiceWrapper.Dependent();

    //Assume response is received - Record should be unlocked
    if(sevis.size() > 0)
    {
        System.runAs(sysAdmin){
            sevis[0].SEVIS_When_Downloaded__c = System.now();
            sevis[0].SEVIS_Ack_Received_At__c = System.now();
            sevis[0].SEVIS_ID__c = '123';
            update sevis[0];
        }
    }

    //ptAccount.Sevis_UEV_Bio__c = true;
    //update ptAccount;
    
   // school.Sevis_UEV_SOA_Edit__c = true;
   // update school;
    
   // position.Sevis_UEV_SOA_Edit__c = true;
   // update position;
    
    //eng.SEVIS_Update_EV_Add_TIPP__c = true;
    //eng.Sevis_UEV_Pro_Amend__c = true;
    //eng.Sevis_UEV_SOA_Edit__c = true;
    //eng.Sevis_UEV_Val_USAdd__c = true;
    //eng.Sevis_UEV_U_USAdd__c = true;
    eng.Sevis_UEV_Nonstandard_SoA__c = true;
    
    update eng;
    
    //Try sending again but need to do some updates above with SEVIS ID
    ApexPages.StandardController sc3 = new ApexPages.StandardController(eng);
    SevisWrapper.isTest=true;
    SevisWrapper sw3 = new SevisWrapper(sc3);
    sw3.packageData();
    
    ApexPages.StandardController sc33 = new ApexPages.StandardController(engS);
    SevisWrapper.isTest=true;
    SevisWrapper sw33 = new SevisWrapper(sc33);
    sw33.packageData();
   /* 
    Accommodation_Site__c accosite = new Accommodation_Site__c(Name='test',Street__c='123 abc',State__c='CA',Postal_Code__c='94945',City__c='abc',Sevis_UEV_Val_USAdd__c=true,Country__c='United States');
    insert accosite;
    Accommodation__c acco = new Accommodation__c(Accommodation_Site__c=accosite.Id,Engagement__c=eng.Id);
    insert acco;*/
    //update accosite;
    Test.stopTest();
}

static Id getRecordType(String rtName,String sObjectName){
    List<RecordType> rt = [select Id from RecordType where sObjectType = :sObjectName and name = :rtName ];
    if (rt.size() > 0){
        return rt[0].Id;
    }
    else{
        return null;
    }
}
}