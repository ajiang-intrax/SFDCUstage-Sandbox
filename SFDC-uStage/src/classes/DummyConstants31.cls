public with sharing class DummyConstants31 {
/*
    Purpose         :   This call is to hold the constant properties.
              
    Created Date    :   02/06/2012
    
    Current Version :   v1.2
    
    Revision Log    :   V_1.1 Created
       -DL 17OCT2012    Added R1.0 AppEngine / Ayusa Constants, updated Background Check values
*/

    //MUST BE SET TO ENVIRONMENT-SPECIFIC CONFIGURATION
    public final static String MARKETO_USER = 'marketosfdc@intraxinc.com.qa';  //Case sensitive
    public final static String SYS_ADMIN = 'spillai@hiperware.com.qa'; //It needs to be spillai for EMAIL-OPT-OUT-FIX
    public final static String PortalId = '06030000000pqif';
    
    //variable to hold the paging behaviour
    public final static Integer PAGE_SIZE = 10;
    public final static String AUDIT_STATUS_COMPLETE_PASSED = 'Complete - Pass';
    public final static String AUDIT_STATUS_COMPLETE_FAILED = 'Complete - Fail';
    public final static String AUDIT_STATUS_COMPLETE_NEEDS_FOLLOW ='Complete - Needs Follow Up';    
    public final static String POSITION_STATUS_CLOSED_FILLED = 'Closed - Filled';
    public final static String OPPORTUNITY_OPERATIONAL_STAGE_MATCHED = 'Matched';
    public final static String MATCH_STATUS_MATCHED = 'Confirmed';
    public final static String MATCH_STATUS_WITHDRAWN = 'Withdrawn';
    public final static String MATCH_STATUS_ASSIGNED = 'Assigned';
    public final static String IMAGE_SIZE_ORIGINAL = 'Original';
    public final static String MATCH_STATUS_INTERVIEW_PENDING = 'Interview Pending';
    public final static Set<String> MATCH_POST_MATCH_VALUES = new Set<String>{'Matched', 'Confirmed', 'On-Program', 'Completed', 'Terminated - PT', 'Terminated - HC'};
    //public final static String backGroundCheckUrl = 'https://casper.aupaircare.com/webservices/bc/capture/index.cfm';
    public final static String backGroundCheckUrl='https://cfdev.intraxinc.com/webservices/bc/capture/index.cfm';
    public final static String BGCXMLTemplate = '<?xml version="1.0" encoding="utf-8"?><BackgroundCheckRequest><EntityId></EntityId><EntityType>AYUSFDCFamily</EntityType><Token>0E15E28C-B3CD-C47F-45FACE98868A73E5</Token><LastName></LastName><FirstName></FirstName><MiddleInitial></MiddleInitial><SSN></SSN><DOB></DOB><Address><HouseNumber></HouseNumber><StreetName></StreetName><City></City><State></State><Zip></Zip></Address></BackgroundCheckRequest>';
    public final static Map<String,String> BGCXMLNode2SObjField = new Map<String,String>{'EntityId' => 'Entity_Id__c','EntityType' => '','Token' => '','LastName' => 'Last_Name__c','FirstName' => 'First_Name__c','MiddleInitial' => 'Middle_Name__c','SSN' => 'ESSN__c','DOB' => 'Date_Of_Birth__c','HouseNumber' => 'Home_Street_1__c','StreetName' => 'Home_Street_1__c','City' => 'Home_City__c','State' => 'Home_State__c','Zip' => 'Home_Postal_Code__c'};    
    public final static Map<String,String> BGCXMLNodeMemberSObjField = new Map<String,String>{'EntityId' =>'EntityId__c','EntityType' => '','Token' => '','LastName' => 'Last_Name__c','FirstName' => 'First_Name__c','MiddleInitial' => 'Middle_Name__c','SSN' => 'ESSN__c','DOB' => 'Date_Of_Birth__c','HouseNumber' => 'PersonMailingStreet','StreetName' => 'PersonMailingStreet','City' => 'PersonMailingCity','State' => 'PersonMailingState','Zip' => 'PersonMailingPostalCode'};
    public final static Boolean enableBGCProd = false;
    public final static String derivedbaseUrl = 'https://qa-intraxinc.cs23.force.com/intraxappengine';
    public final static String OWEAddress ='info@ayusa.org';
    public final static Id Portal_Account_Id ='00118000002G426';
    public final static String QUEUE_NAME = 'Ayusa Applications';
    public final static String QUEUE_APC_NAME = 'APC Applications';
    public final static List<String> ALLOWED_ROLE_LIST = new List<String>{'Parent', 'Reference', 'Other', 'Student', 'Host'};
    
    // APPLICANT INFO RECORD TYPES
    public final static Id AyusaPT_Record_Type_Id = '012a0000001NOM0';
    public final static Id AyusaHF_Record_Type_Id = '012a0000001NOM5';
    public final static Id ICD_Intern_PT_Record_Type_Id = '012a0000001NOLl';
    public final static Id PW_PT_Record_Type_Id = '012a0000001NV3t';
    public final static Id WT_PT_Record_Type_Id = '012a0000001NYBQ';
    public final static Id AuPairCareHF_Record_Type_Id = '01213000000AUyw';
    public final static Id AuPairCarePT_Record_Type_Id = '01213000000AUyx';
    
    // PERSON INFO RECORD TYPES 
    public final static Id APC_Host_Primary_Record_Type_Id = '01213000000AUzB';
    public final static Id APC_Participant_Record_Type_Id = '01213000000AUz3';
    public final static Id APC_Parent_Record_Type_Id = '01213000000AUz2';
    public final static Id APC_Child_Record_Type_Id = '01213000000AUyy';
    public final static Id APC_Reference_Record_Type_Id = '01213000000AUz4';
    public final static Id APC_Spouse_Record_Type_Id = '01213000000AUz5';
    public final static Id APC_Host_Record_Type_Id = '01213000000AUyz';
    public final static Id APC_Other_Record_Type_Id = '01213000000AUz1';     

    // ENGAGEMENT RECORD TYPES 
    public final static string ENG_CENTERS_PT = '012a0000001NV3w'; 
    public final static string ENG_GROUP_PARTICIPANT = '012a0000001NV3x'; 
    public final static string ENG_ICD_INTERN_PT = '012a0000001NV3y'; 
    public final static string ENG_IIA_INTERN_PT = '012a0000001NV3z'; 
    public final static string ENG_PW_PARTICIPANT = '012a0000001NV40'; 
    public final static string ENG_AUPAIRCARE_PT = '012a0000001NV3u'; 
    public final static string ENG_AYUSA_PT = '012a0000001NV3v'; 
    public final static string ENG_WORK_TRAVEL_PT = '012a0000001NV41';
           
    // OPPORTUNITY RECORD TYPES
    public final static string OPP_AUPAIRCARE_PT = '01230000000skjI';
    public final static string OPP_CENTERS_PT = '01230000000sWd6'; 
    public final static string OPP_AYUSA_PT = '01230000000ssBg'; 
    public final static string OPP_HOST_FAMILY = '01230000000skjh';
    public final static string OPP_GROUP_PARTICIPANT = '012a0000001NQjj';     
    public final static string OPP_ICD_INTERN_PT = '01230000000sboT'; 
    public final static string OPP_IIA_INTERN_PT = '01230000000rv8J';
    public final static string OPP_INTERN_HC='01230000000sCj0';     
    public final static string OPP_LANGO_FRANCHISE = '01230000000rmQ4'; 
    public final static string OPP_LANGO_SCHOOL = '01230000000sls6';
    public final static string OPP_PW_PARTICIPANT='01230000000rwI6';     
    public final static string OPP_PW_UNIVERSITY = '01230000000rwI1';     
    public final static string OPP_PW_HC = '012a0000001NOMF';    
    public final static string OPP_STUDY_ABROAD_PT = '01230000000roLq';
    public final static string OPP_TEACH_ABROAD_PT='01230000000rFBo';     
    public final static string OPP_WORK_TRAVEL_HC = '01230000000roCr'; 
    public final static string OPP_WORK_TRAVEL_PT= '01230000000skjc';
    public final static Id Opp_AuPairCare_PT_Id = '01230000000skjIAAQ';     

    // MATCH RECORD TYPES
    public final static string MAT_INTERNSHIP = '012a0000001NYBK';
    public final static string MAT_AYUSA = '012a0000001NYBJ';

    //POSITION RECORD TYPES
    public final static string POS_AYUSA_HF = '012a0000001NYCT';
    public final static string POS_WORK_TRAVEL = '012a0000001NYCW';
    public final static string POS_ICD_INTERN_PT = '012a0000001NYCV';   

    // CASE RECORD TYPES
    public final static string CASE_AYUSA = '012a0000001NZ7p';
    public final static string CASE_WT = '012a0000001NbNh'; 
    
    // ASSESSMENT RECORD TYPES
    public final static string ASS_AY_HF_Contact = '012e00000008dfT'; 
    public final static string ASS_AY_PT_Contact = '012e00000008dfW';
    public final static string ASS_AY_SC_Contact = '012e00000008eSp';
    public final static string ASS_AY_PT_Orientation = '012a0000001NYBH';
    public final static string ASS_AY_HF_Validation = '012a0000001NYBD';
    public final static string ASS_WT_HC_Validation = '012a0000001Nabz';
    public final static string ASS_WT_PT_Check_In = '012a0000001NawK';
    public final static string ASS_WT_PT_Monthly_Contact = '012a0000001NawL';    

    public final static Map<String,String> ASS_HF_CONTACT_YEAR_RECORDTYPES = new Map<String,String>
   {'August' => '012a0000001NZ74',
   'September' => '012a0000001NZ7N',
   'October' => '012a0000001NZ7L',
   'November' => '012a0000001NZ7J',
   'December' => '012a0000001NZ76',
   'January' => '012a0000001NZ7B',
   'February' => '012a0000001NZ78',
   'March' => '012a0000001NZ7F',
   'April' => '012a0000001NZ72',
   'May' => '012a0000001NZ7H',
   'June' => '012a0000001NZ7D'};

    public final static Map<String,String> ASS_HF_CONTACT_S1_RECORDTYPES = new Map<String,String>
   {'August' => '012a0000001NZ73',
   'September' => '012a0000001NZ7M',
   'October' => '012a0000001NZ7K',
   'November' => '012a0000001NZ7I',
   'December' => '012a0000001NZ75',
   'January' => '012a0000001NZ79'};

    public final static Map<String,String> ASS_HF_CONTACT_S2_RECORDTYPES = new Map<String,String>
   {'January' => '012a0000001NZ7A',
   'February' => '012a0000001NZ77',
   'March' => '012a0000001NZ7E',
   'April' => '012a0000001NZ71',
   'May' => '012a0000001NZ7G',
   'June' => '012a0000001NZ7C'};

    public final static Map<String,String> ASS_PT_CONTACT_YEAR_RECORDTYPES = new Map<String,String>
   {'August' => '012a0000001NZ7R',
   'September' => '012a0000001NZ7k',
   'October' => '012a0000001NZ7i',
   'November' => '012a0000001NZ7g',
   'December' => '012a0000001NZ7T',
   'January' => '012a0000001NZ7Y',
   'February' => '012a0000001NZ7V',
   'March' => '012a0000001NZ7c',
   'April' => '012a0000001NZ7P',
   'May' => '012a0000001NZ7e',
   'June' => '012a0000001NZ7a'};

    public final static Map<String,String> ASS_PT_CONTACT_S1_RECORDTYPES = new Map<String,String>
   {'August' => '012a0000001NZ7Q',
   'September' => '012a0000001NZ7j',
   'October' => '012a0000001NZ7h',
   'November' => '012a0000001NZ7f',
   'December' => '012a0000001NZ7S',
   'January' => '012a0000001NZ7W'};

    public final static Map<String,String> ASS_PT_CONTACT_S2_RECORDTYPES = new Map<String,String>
   {'January' => '012a0000001NZ7X',
   'February' => '012a0000001NZ7U',
   'March' => '012a0000001NZ7b',
   'April' => '012a0000001NZ7O',
   'May' => '012a0000001NZ7d',
   'June' => '012a0000001NZ7Z'};

    public final static Map<String,String> ASS_SC_CONTACT_RECORDTYPES = new Map<String,String>
   {'September' => '012a0000001NZ7o',
   'November' => '012a0000001NZ7n',
   'February' => '012a0000001NZ7l',
   'May' => '012a0000001NZ7m'};
   
    public final static Map<String,String> ASS_SC_CONTACT_S1_RECORDTYPES = new Map<String,String>
   {'September' => '012a0000001NanU',
   'November' => '012a0000001NanT'};
   
    public final static Map<String,String> ASS_SC_CONTACT_S2_RECORDTYPES = new Map<String,String>
   {'February' => '012a0000001NanR',
   'May' => '012a0000001NanS'};   
    
    // FILE UPLOADS
    public final static String fileUploadUrl ='https://srvvpc-web-qa.intraxinc.com:8443/fileloader-0.0.1-SNAPSHOT/fileloader.jsp?';
    public final static String fileUploadUrl2 ='https://srvvpc-web-qa.intraxinc.com:8443/fileloader-0.0.2-SNAPSHOT/fileloader.jsp?';
    public final static String documentService ='https://srvvpc-app-qa.intraxinc.com:8443/document-0.0.1-SNAPSHOT/document/rs/';
    public final static String imageService ='https://srvvpc-app-qa.intraxinc.com:8443/image-0.0.1-SNAPSHOT/image/rs/';
    public final static String UploadServiceUrl = 'https://srvvpc-web-qa.intraxinc.com:8443/fileloader-0.0.1-SNAPSHOT/fileloader.jsp';
    public final static String FlowUploadServiceUrl = 'https://srvvpc-web-qa.intraxinc.com:8443/fileloader-0.0.1-SNAPSHOT/fileloader.jsp';
    public final static String videoService ='https://srvvpc-app-qa.intraxinc.com:8443/video-0.0.1-SNAPSHOT/video/rs/';

    public final static String ldapCredentials ='salesforce_user:password';
    public final static String serviceAuthToken ='aRsPuKzDqKeQv4pBb9gEySf2mLkUqOdQhL';
    public final static Boolean disableFileUpload = false;  
    public final static String disableFileUploadText = 'File Uploads are currently not supported. Please proceed to other sections of the application.';
    public final static String CONFG_ENV = 'QA'; 
    public final static String source = 'cs23';
                               
    //Country ISO Code mapping
    public final static Map<String, String> MAP_COUNTRY_WITH_ISO_CODE = new Map<String, String>{'afghanistan' => 'AF',
                                                                                                'åland islands' => 'AX',
                                                                                                'albania' => 'AL',
                                                                                                'algeria' => 'DZ',
                                                                                                'american samoa' => 'AS',
                                                                                                'andorra' => 'AD',
                                                                                                'angola' => 'AO',
                                                                                                'anguilla' => 'AI',
                                                                                                'antarctica' => 'AQ',
                                                                                                'antigua and barbuda' => 'AG',
                                                                                                'argentina' => 'AR',
                                                                                                'armenia' => 'AM',
                                                                                                'aruba' => 'AW',
                                                                                                'australia' => 'AU',
                                                                                                'austria' => 'AT',
                                                                                                'azerbaijan' => 'AZ',
                                                                                                'bahamas' => 'BS',
                                                                                                'bahrain' => 'BH',
                                                                                                'bangladesh' => 'BD',
                                                                                                'barbados' => 'BB',
                                                                                                'belarus' => 'BY',
                                                                                                'belgium' => 'BE',
                                                                                                'belize' => 'BZ',
                                                                                                'benin' => 'BJ',
                                                                                                'bermuda' => 'BM',
                                                                                                'bhutan' => 'BT',
                                                                                                'bolivia, plurinational state of' => 'BO',
                                                                                                'bonaire, sint eustatius and saba' => 'BQ',
                                                                                                'bosnia and herzegovina' => 'BA',
                                                                                                'botswana' => 'BW',
                                                                                                'bouvet island' => 'BV',
                                                                                                'brazil' => 'BR',
                                                                                                'british indian ocean territory' => 'IO',
                                                                                                'brunei darussalam' => 'BN',
                                                                                                'bulgaria' => 'BG',
                                                                                                'burkina faso' => 'BF',
                                                                                                'burundi' => 'BI',
                                                                                                'cambodia' => 'KH',
                                                                                                'cameroon' => 'CM',
                                                                                                'canada' => 'CA',
                                                                                                'cape verde' => 'CV',
                                                                                                'cayman islands' => 'KY',
                                                                                                'central african republic' => 'CF',
                                                                                                'chad' => 'TD',
                                                                                                'chile' => 'CL',
                                                                                                'china' => 'CN',
                                                                                                'christmas island' => 'CX',
                                                                                                'cocos (keeling) islands' => 'CC',
                                                                                                'colombia' => 'CO',
                                                                                                'comoros' => 'KM',
                                                                                                'congo' => 'CG',
                                                                                                'congo, the democratic republic of the' => 'CD',
                                                                                                'cook islands' => 'CK',
                                                                                                'costa rica' => 'CR',
                                                                                                'côte d\'ivoire' => 'CI',
                                                                                                'croatia' => 'HR',
                                                                                                'cuba' => 'CU',
                                                                                                'curaçao' => 'CW',
                                                                                                'cyprus' => 'CY',
                                                                                                'czech republic' => 'CZ',
                                                                                                'denmark' => 'DK',
                                                                                                'djibouti' => 'DJ',
                                                                                                'dominica' => 'DM',
                                                                                                'dominican republic' => 'DO',
                                                                                                'ecuador' => 'EC',
                                                                                                'egypt' => 'EG',
                                                                                                'el salvador' => 'SV',
                                                                                                'equatorial guinea' => 'GQ',
                                                                                                'eritrea' => 'ER',
                                                                                                'estonia' => 'EE',
                                                                                                'ethiopia' => 'ET',
                                                                                                'falkland islands (malvinas)' => 'FK',
                                                                                                'faroe islands' => 'FO',
                                                                                                'fiji' => 'FJ',
                                                                                                'finland' => 'FI',
                                                                                                'france' => 'FR',
                                                                                                'french guiana' => 'GF',
                                                                                                'french polynesia' => 'PF',
                                                                                                'french southern territories' => 'TF',
                                                                                                'gabon' => 'GA',
                                                                                                'gambia' => 'GM',
                                                                                                'georgia' => 'GE',
                                                                                                'germany' => 'DE',
                                                                                                'ghana' => 'GH',
                                                                                                'gibraltar' => 'GI',
                                                                                                'greece' => 'GR',
                                                                                                'greenland' => 'GL',
                                                                                                'grenada' => 'GD',
                                                                                                'guadeloupe' => 'GP',
                                                                                                'guam' => 'GU',
                                                                                                'guatemala' => 'GT',
                                                                                                'guernsey' => 'GG',
                                                                                                'guinea' => 'GN',
                                                                                                'guinea-bissau' => 'GW',
                                                                                                'guyana' => 'GY',
                                                                                                'haiti' => 'HT',
                                                                                                'heard island and mcdonald islands' => 'HM',
                                                                                                'holy see (vatican city state)' => 'VA',
                                                                                                'honduras' => 'HN',
                                                                                                'hong kong' => 'HK',
                                                                                                'hungary' => 'HU',
                                                                                                'iceland' => 'IS',
                                                                                                'india' => 'IN',
                                                                                                'indonesia' => 'ID',
                                                                                                'iran, islamic republic of' => 'IR',
                                                                                                'iraq' => 'IQ',
                                                                                                'ireland' => 'IE',
                                                                                                'isle of man' => 'IM',
                                                                                                'israel' => 'IL',
                                                                                                'italy' => 'IT',
                                                                                                'jamaica' => 'JM',
                                                                                                'japan' => 'JP',
                                                                                                'jersey' => 'JE',
                                                                                                'jordan' => 'JO',
                                                                                                'kazakhstan' => 'KZ',
                                                                                                'kenya' => 'KE',
                                                                                                'kiribati' => 'KI',
                                                                                                'korea, democratic people\'s republic of' => 'KP',
                                                                                                'korea, republic of' => 'KR',
                                                                                                'kuwait' => 'KW',
                                                                                                'kyrgyzstan' => 'KG',
                                                                                                'lao people\'s democratic republic' => 'LA',
                                                                                                'latvia' => 'LV',
                                                                                                'lebanon' => 'LB',
                                                                                                'lesotho' => 'LS',
                                                                                                'liberia' => 'LR',
                                                                                                'libya' => 'LY',
                                                                                                'liechtenstein' => 'LI',
                                                                                                'lithuania' => 'LT',
                                                                                                'luxembourg' => 'LU',
                                                                                                'macao' => 'MO',
                                                                                                'macedonia, the former yugoslav republic of' => 'MK',
                                                                                                'madagascar' => 'MG',
                                                                                                'malawi' => 'MW',
                                                                                                'malaysia' => 'MY',
                                                                                                'maldives' => 'MV',
                                                                                                'mali' => 'ML',
                                                                                                'malta' => 'MT',
                                                                                                'marshall islands' => 'MH',
                                                                                                'martinique' => 'MQ',
                                                                                                'mauritania' => 'MR',
                                                                                                'mauritius' => 'MU',
                                                                                                'mayotte' => 'YT',
                                                                                                'mexico' => 'MX',
                                                                                                'micronesia, federated states of' => 'FM',
                                                                                                'moldova, republic of' => 'MD',
                                                                                                'monaco' => 'MC',
                                                                                                'mongolia' => 'MN',
                                                                                                'montenegro' => 'ME',
                                                                                                'montserrat' => 'MS',
                                                                                                'morocco' => 'MA',
                                                                                                'mozambique' => 'MZ',
                                                                                                'myanmar' => 'MM',
                                                                                                'namibia' => 'NA',
                                                                                                'nauru' => 'NR',
                                                                                                'nepal' => 'NP',
                                                                                                'netherlands' => 'NL',
                                                                                                'new caledonia' => 'NC',
                                                                                                'new zealand' => 'NZ',
                                                                                                'nicaragua' => 'NI',
                                                                                                'niger' => 'NE',
                                                                                                'nigeria' => 'NG',
                                                                                                'niue' => 'NU',
                                                                                                'norfolk island' => 'NF',
                                                                                                'northern mariana islands' => 'MP',
                                                                                                'norway' => 'NO',
                                                                                                'oman' => 'OM',
                                                                                                'pakistan' => 'PK',
                                                                                                'palau' => 'PW',
                                                                                                'palestinian territory, occupied' => 'PS',
                                                                                                'panama' => 'PA',
                                                                                                'papua new guinea' => 'PG',
                                                                                                'paraguay' => 'PY',
                                                                                                'peru' => 'PE',
                                                                                                'philippines' => 'PH',
                                                                                                'pitcairn' => 'PN',
                                                                                                'poland' => 'PL',
                                                                                                'portugal' => 'PT',
                                                                                                'puerto rico' => 'PR',
                                                                                                'qatar' => 'QA',
                                                                                                'réunion' => 'RE',
                                                                                                'romania' => 'RO',
                                                                                                'russian federation' => 'RU',
                                                                                                'rwanda' => 'RW',
                                                                                                'saint barthélemy' => 'BL',
                                                                                                'saint helena, ascension and tristan da cunha' => 'SH',
                                                                                                'saint kitts and nevis' => 'KN',
                                                                                                'saint lucia' => 'LC',
                                                                                                'saint martin (french part)' => 'MF',
                                                                                                'saint pierre and miquelon' => 'PM',
                                                                                                'saint vincent and the grenadines' => 'VC',
                                                                                                'samoa' => 'WS',
                                                                                                'san marino' => 'SM',
                                                                                                'sao tome and principe' => 'ST',
                                                                                                'saudi arabia' => 'SA',
                                                                                                'senegal' => 'SN',
                                                                                                'serbia' => 'RS',
                                                                                                'seychelles' => 'SC',
                                                                                                'sierra leone' => 'SL',
                                                                                                'singapore' => 'SG',
                                                                                                'sint maarten (dutch part)' => 'SX',
                                                                                                'slovakia' => 'SK',
                                                                                                'slovenia' => 'SI',
                                                                                                'solomon islands' => 'SB',
                                                                                                'somalia' => 'SO',
                                                                                                'south africa' => 'ZA',
                                                                                                'south georgia and the south sandwich islands' => 'GS',
                                                                                                'south sudan' => 'SS',
                                                                                                'spain' => 'ES',
                                                                                                'sri lanka' => 'LK',
                                                                                                'sudan' => 'SD',
                                                                                                'suriname' => 'SR',
                                                                                                'svalbard and jan mayen' => 'SJ',
                                                                                                'swaziland' => 'SZ',
                                                                                                'sweden' => 'SE',
                                                                                                'switzerland' => 'CH',
                                                                                                'syrian arab republic' => 'SY',
                                                                                                'taiwan, province of china' => 'TW',
                                                                                                'tajikistan' => 'TJ',
                                                                                                'tanzania, united republic of' => 'TZ',
                                                                                                'thailand' => 'TH',
                                                                                                'timor-leste' => 'TL',
                                                                                                'togo' => 'TG',
                                                                                                'tokelau' => 'TK',
                                                                                                'tonga' => 'TO',
                                                                                                'trinidad and tobago' => 'TT',
                                                                                                'tunisia' => 'TN',
                                                                                                'turkey' => 'TR',
                                                                                                'turkmenistan' => 'TM',
                                                                                                'turks and caicos islands' => 'TC',
                                                                                                'tuvalu' => 'TV',
                                                                                                'uganda' => 'UG',
                                                                                                'ukraine' => 'UA',
                                                                                                'united arab emirates' => 'AE',
                                                                                                'united kingdom' => 'GB',
                                                                                                'united states' => 'US',
                                                                                                'united states minor outlying islands' => 'UM',
                                                                                                'uruguay' => 'UY',
                                                                                                'uzbekistan' => 'UZ',
                                                                                                'vanuatu' => 'VU',
                                                                                                'venezuela, bolivarian republic of' => 'VE',
                                                                                                'viet nam' => 'VN',
                                                                                                'virgin islands, british' => 'VG',
                                                                                                'virgin islands, u.s.' => 'VI',
                                                                                                'wallis and futuna' => 'WF',
                                                                                                'western sahara' => 'EH',
                                                                                                'yemen' => 'YE',
                                                                                                'zambia' => 'ZM',
                                                                                                'zimbabwe' => 'ZW'
    };

    //APC
    public final static Map<String,String> APC_DOCTYPES = new Map<String,String>
    {'Lifeguard' => '/apc_ap_main_swimming_experience?doctype=Lifeguard',
    'Drivers-License' => '/apc_ap_main_driving_experience?doctype=Drivers-License',
    'Health' => '/apc_ap_main_physician_form?doctype=Health',
    'Proof-of-Education' => '/apc_ap_main_education_proof?doctype=Proof-of-Education',
    'Participant-Photo' => '/apc_ap_main_media?doctype=Participant-Photo',
    'Transcripts' => '/apc_ap_main_training?doctype=Transcripts',
    'Secondary-School-Diploma' => '/apc_ap_main_training?doctype=Secondary-School-Diploma',
    'University-Diploma' => '/apc_ap_main_training?doctype=University-Diploma',
    'Certificate' => '/apc_ap_main_training?doctype=Certificate',
    'Passport' => '/apc_ap_main_visa_info?doctype=Passport'};
    //public final static String APC_PAYMENT_CONFIRMATION_ID = '00X130000016JEr';

    // AYUSA
    public final static Map<String,String> AYUSA_DOCTYPES = new Map<String,String>
    {'Health' => '/ayusa_app_doc_assessment?doctype=Health','Transcripts' => '/ayusa_app_school_transcripts?doctype=Transcripts',
    'Agreements' => '/ayusa_app_prog_agreements?doctype=Agreements','Partner' => '/ayusa_app_partner_detailed_report?doctype=Partner',
    'Media' => '/ayusa_app_stu_photos_videos?doctype=Media','Passport' => '/ayusa_app_passport_details?doctype=Passport',
    'Family' => '/ayusa_app_fam_photos_videos?doctype=Family','HostFamily' => '/ayusa_hf_photos_videos?doctype=HostFamily',
    'HFAgreements' => '/ayusa_hf_prog_agree?doctype=HostAgreements','Teacher' => '/ayusa_app_reco_list?docType=Academic',
    'Academic' => '/ayusa_app_reco_list?docType=Academic','School' => '/ayusa_app_reco_list?docType=Academic',
    'BackgroundCheck' => '/ayusa_hf_prog_agree?doctype=HostAgreements',
    'HostAgreements' => '/ayusa_hf_prog_agree?doctype=HostAgreements'};
   
    // CENTERS
    // public final static Map<String,String> CENTERS_DOCTYPES = new Map<String,String>{'Passport' => '/centers_app_passport_details?doctype=Passport','FinancialResponsibility' => '/centers_app_my_visa_documents?doctype=FinancialResponsibility'};  
    public final static Map<String,String> CENTERS_DOCTYPES = new Map<String,String>{'Passport' => '/centers_app_passport_details?doctype=Passport','FinancialResponsibility' => '/centers_app_my_visa_documents?doctype=FinancialResponsibility','AllDocuments' => '/centers_app_my_document_uploads?doctype=AllDocuments'}; 
     
    // IGI
    public final static Map<String, String> IGI_DOCTYPES = new Map<String,String>{ 
      //OLD 'Participant-Photo' => '/participant_preapp_biographical_docs?docType=Participant-Photo', 
      //'Participant-Photo' => '/igi_pt_app_media?docType=Participant-Photo',
      'igi-documents' => '/igi_pt_app_documents?docType=igi-documents',
      'Participant-Photo' => '/igi_pt_app_media?docType=Participant-Photo',        
      'Previous-Visa' => '/participant_preapp_biographical_docs?docType=Participant-Photo', 
      'Passport' => '/participant_preapp_biographical_docs?docType=Participant-Photo', 
      'Resume' => '/participant_preapp_Experience?docType=Resume', 
      'Other' => '/participant_preapp_biographical_documents?docType=Other' 
      };

    public final static List<String> IGI_SD_REQ_DOCTYPES = new List<String>{'Resume'};
    public final static List<String> IGI_HT_REQ_DOCTYPES = new List<String>{'Offer-Document','Passport','Resume','Introductory-Video','University-Diploma','Proof-of-Language-Level'};
    public final static List<String> IGI_BUS_IN_REQ_DOCTYPES = new List<String>{'Offer-Document','Passport','Resume','Proof-of-Language-Level','Terms-and-Conditions'};
      
    public final static String QUEUE_NAME_IGI = 'IGI Applications';   
    public final static String YES = 'Yes';
    public final static String NO = 'No';
    //List to hold the options for Study Weeks
    public static List<SelectOption> SERVICE_LEVEL_LIST {
      get {
        //List to hold the options
        List<SelectOption> options = new List<SelectOption>();
          options.add(new SelectOption('Yes','Yes'));   
          options.add(new SelectOption('No','No'));
          //Return SelectOption List
          return options;
      }
    }
    
    // WORK TRAVEL
    public final static Map<String, String> WT_DOCTYPES = new Map<String,String>{
        'Participant-Photo' => '/participant_preapp_biographical_docs?docType=Participant-Photo',
        'Other' => '/participant_preapp_biographical_documents?docType=Other'
        };

    // PARTNER PORTAL
    public final static Map<String,String> PARTNER_PORTAL_DOCTYPES = new Map<String,String>{
        'Pre-Departure-Orientation-Agreement' => '/Partner_Docs_Upload?docType=Pre-Departure-Orientation-Agreement',
        'PT-Double-Placement-Agreement' => '/Partner_Docs_Upload?docType=PT-Double-Placement-Agreement',
        'NP-Double-Placement-Agreement' => '/Partner_Docs_Upload?docType=NP-Double-Placement-Agreement',
        'SNK-Placement-Agreement' => '/Partner_Docs_Upload?docType=SNK-Placement-Agreement',
        'Participant-Eligibility-Form' => '/Partner_Docs_Upload?docType=Participant-Eligibility-Form',
        'University-Letter' => '/Partner_Docs_Upload?docType=University-Letter',
        'University-Letter-Translation' => '/Partner_Docs_Upload?docType=University-Letter-Translation',
        'Terms-and-Conditions' => '/Partner_Docs_Upload?docType=Terms-and-Conditions', 
        'Other' => '/Partner_Docs_Upload?docType=Other',
        'Offer-Document' => '/Partner_Docs_Upload?docType=Offer-Document',
        'Private-School-Agreement' => '/Partner_Docs_Upload?docType=Private-School-Agreement',
        'Tutoring-Agreement' => '/Partner_Docs_Upload?docType=Tutoring-Agreement'
        }; 

    // HF Portal
    public final static Map<String,String> HFPortalPtPhotosDocTypes = new Map<String,String>{'ProfilePhotoDocType' => 'Media',
                                                                                                'FamilyPhotoDocType' => 'Family'};
    public final static Map<String,String> HFPortalPtPhotosDocSizes = new Map<String,String>{'ProfilePhotoSize' => 'medium',
                                                                                                'FamilyPhotoSize' => 'medium'};   
    public final static String awsProgramTypeAyusaPT = 'ayusa-pt';  
        
    //Partner Portal 
    public static List<String> PPPTMatchPosdocTypes = new List<String>{'Kitchen','Living-Room','Bathroom','Student-Bedroom','Exterior-Of-Home','Family-Photo'};
    public final static Map<String,List<String>> PartnerPortalPTMatchPosPhotosDocTypes = new Map<String,List<String>>{'PPPTMatchPosDocTypes' =>PPPTMatchPosdocTypes };
    public final static Map<String,String> PartnerPortalPTMatchPosPhotosDocSizes = new Map<String,String>{'PPPTMatchPosDocSize' => 'medium'}; 
    public final static String awsProgramTypePPPTMatchPos = 'upload_pos';  
        
    // CENTERS  
    public final static String QUEUE_NAME_INTRAX_CENTERS_ONLINE = 'Centers Application';
    public final static String HYPHEN = '-';
    public final static String IC = 'IC';
    public final static String HOW_HEARD_AGENCY = 'Agency';
    
    //List to hold the description value for Professional Certificates Products  
    public static List<String> PROFESSIONAL_CERTIFICATES_DESCRIPTION_FINAL_LIST {
      
      get {
        
        //List to hold the desc
        List<String> listDesc = new List<String>();
        
        //Create a set tomaintain the uniqueness
        Set<String> uniqueDesc = new Set<String>();
        
        //Create a list to holdthe description
        for(Product2 p : [Select Description,Product_Description_Label__c, Promo_CTA__c, Promo_CTA_Label__c from Product2 where Family = 'Professional Certificates' AND Description != null order by SORT_ORDER__c]) {
        /*
        if(p.Promo_CTA__c == null)
            p.Promo_CTA__c = '';
                
        //Check if item does not exist already
        if(!uniqueDesc.contains(p.Description + ' ' + p.Promo_CTA__c) ) {        
          //Add description in list
          listDesc.add(p.Description + ' ' + p.Promo_CTA__c);  
          uniqueDesc.add(p.Description + ' ' + p.Promo_CTA__c);
        }        
        */   
        if(p.Promo_CTA_Label__c == null)
            p.Promo_CTA_Label__c = '';
                               
        //Check if item does not exist already
        if(!uniqueDesc.contains(p.Product_Description_Label__c) ) {       
          //Add description label in list
          if(p.Product_Description_Label__c != null){
            listDesc.add(p.Product_Description_Label__c);  
            uniqueDesc.add(p.Product_Description_Label__c);
          }                                
        }
                
        }
        System.debug('@@@@@ Valuein list of description'+ listDesc);
        //return 
        return listDesc;
      }
    }

    
    public final static Id Centers_Record_Type_Id = '012a0000001Vz4l';  
    public final static String CTR_STUDENT_PHONE_NUMBER = '+1 415.434.5643';    
    public final static String CTR_LIVE_CHAT = 'https://server.iad.liveperson.net/hc/27443582/?cmd=file&file=visitorWantsToChat&site=27443582&SESSIONVAR!opid=2&imageUrl=https://images.liveperson.com/lp/27443582&referrer=http%3A//www.intrax.edu/';    
    public final static String CTR_SKYPE = 'intraxglobal';    
    public final static String CTR_PARTNER_PHONE_NUMBER = '+1 415.434.5586';
    public final static String CTR_STUDENT_EMAIL = 'info@intrax.edu';
    public final static String CTR_PARTNER_EMAIL = 'admissions@intrax.edu';
    
    public static List<SelectOption> STUDY_WEEKS_LIST {
      
      get {
        
        //List to hold the options
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','--None--'));
          options.add(new SelectOption('1','1'));   options.add(new SelectOption('2','2'));   options.add(new SelectOption('3','3'));   
          options.add(new SelectOption('4','4'));   options.add(new SelectOption('5','5'));   options.add(new SelectOption('6','6'));   
          options.add(new SelectOption('7','7'));   options.add(new SelectOption('8','8'));   options.add(new SelectOption('9','9'));   
          options.add(new SelectOption('10','10')); options.add(new SelectOption('11','11')); options.add(new SelectOption('12','12')); 
          options.add(new SelectOption('13','13')); options.add(new SelectOption('14','14')); options.add(new SelectOption('15','15')); 
          options.add(new SelectOption('16','16')); options.add(new SelectOption('17','17')); options.add(new SelectOption('18','18')); 
          options.add(new SelectOption('19','19')); options.add(new SelectOption('20','20')); options.add(new SelectOption('21','21')); 
          options.add(new SelectOption('22','22')); options.add(new SelectOption('23','23')); options.add(new SelectOption('24','24')); 
          options.add(new SelectOption('25','25')); options.add(new SelectOption('26','26')); options.add(new SelectOption('27','27')); 
          options.add(new SelectOption('28','28')); options.add(new SelectOption('29','29')); options.add(new SelectOption('30','30')); 
          options.add(new SelectOption('31','31')); options.add(new SelectOption('32','32')); options.add(new SelectOption('33','33')); 
          options.add(new SelectOption('34','34')); options.add(new SelectOption('35','35')); options.add(new SelectOption('36','36')); 
          options.add(new SelectOption('37','37')); options.add(new SelectOption('38','38')); options.add(new SelectOption('39','39')); 
          options.add(new SelectOption('40','40')); options.add(new SelectOption('41','41')); options.add(new SelectOption('42','42')); 
          options.add(new SelectOption('43','43')); options.add(new SelectOption('44','44')); options.add(new SelectOption('45','45')); 
          options.add(new SelectOption('46','46')); options.add(new SelectOption('47','47')); options.add(new SelectOption('48','48'));
          
          //Return SelectOption List
          return options;
      }
    }
    
   //List of Program Type
   public static List<SelectOption> Program_Type {
      get {
        //List to hold the options
        List<SelectOption> InstOptions = new List<SelectOption>();
            InstOptions.add(new SelectOption('Bachelor','Bachelor'));
            InstOptions.add(new SelectOption('Master','Master'));
            InstOptions.add(new SelectOption('Doctorate','Doctorate'));
            return InstOptions;
          }
   } 

    //List of country codes
   public static List<SelectOption> PHONE_COUNTRY_CODES {
      
      get {
        
        //List to hold the options
        List<SelectOption> phoneOptions = new List<SelectOption>();
            phoneOptions.add(new SelectOption('+93','Afghanistan (93)'));
            phoneOptions.add(new SelectOption('+355','Albania (355)'));
            phoneOptions.add(new SelectOption('+213','Algeria (213)'));
            phoneOptions.add(new SelectOption('+1 684','American Samoa (1 684)'));
            phoneOptions.add(new SelectOption('+376','Andorra (376)'));
            phoneOptions.add(new SelectOption('+244','Angola (244)'));
            phoneOptions.add(new SelectOption('+1 264','Anguilla (1 264)'));
            phoneOptions.add(new SelectOption('+672','Antarctica (672)'));
            phoneOptions.add(new SelectOption('+1 268','Antigua and Barbuda (1 268)'));
            phoneOptions.add(new SelectOption('+54','Argentina (54)'));
            phoneOptions.add(new SelectOption('+374','Armenia (374)'));
            phoneOptions.add(new SelectOption('+297','Aruba (297)'));
            phoneOptions.add(new SelectOption('+61','Australia (61)'));
            phoneOptions.add(new SelectOption('+43','Austria (43)'));
            phoneOptions.add(new SelectOption('+994','Azerbaijan (994)'));
            phoneOptions.add(new SelectOption('+1 242','Bahamas (1 242)'));
            phoneOptions.add(new SelectOption('+973','Bahrain (973)'));
            phoneOptions.add(new SelectOption('+880','Bangladesh (880)'));
            phoneOptions.add(new SelectOption('+1 246','Barbados (1 246)'));
            phoneOptions.add(new SelectOption('+375','Belarus (375)'));
            phoneOptions.add(new SelectOption('+32','Belgium (32)'));
            phoneOptions.add(new SelectOption('+501','Belize (501)'));
            phoneOptions.add(new SelectOption('+229','Benin (229)'));
            phoneOptions.add(new SelectOption('+1 441','Bermuda (1 441)'));
            phoneOptions.add(new SelectOption('+975','Bhutan (975)'));
            phoneOptions.add(new SelectOption('+591','Bolivia (591)'));
            phoneOptions.add(new SelectOption('+387','Bosnia and Herzegovina (387)'));
            phoneOptions.add(new SelectOption('+267','Botswana (267)'));
            phoneOptions.add(new SelectOption('+55','Brazil (55)'));
            phoneOptions.add(new SelectOption('+1 284','British Virgin Islands (1 284)'));
            phoneOptions.add(new SelectOption('+673','Brunei (673)'));
            phoneOptions.add(new SelectOption('+359','Bulgaria (359)'));
            phoneOptions.add(new SelectOption('+226','Burkina Faso (226)'));
            phoneOptions.add(new SelectOption('+95','Burma (Myanmar) (95)'));
            phoneOptions.add(new SelectOption('+257','Burundi (257)'));
            phoneOptions.add(new SelectOption('+855','Cambodia (855)'));
            phoneOptions.add(new SelectOption('+237','Cameroon (237)'));
            phoneOptions.add(new SelectOption('+1','Canada (1)'));
            phoneOptions.add(new SelectOption('+238','Cape Verde (238)'));
            phoneOptions.add(new SelectOption('+1 345','Cayman Islands (1 345)'));
            phoneOptions.add(new SelectOption('+236','Central African Republic (236)'));
            phoneOptions.add(new SelectOption('+235','Chad (235)'));
            phoneOptions.add(new SelectOption('+56','Chile (56)'));
            phoneOptions.add(new SelectOption('+86','China (86)'));
            phoneOptions.add(new SelectOption('+61','Christmas Island (61)'));
            phoneOptions.add(new SelectOption('+61','Cocos (Keeling) Islands (61)'));
            phoneOptions.add(new SelectOption('+57','Colombia (57)'));
            phoneOptions.add(new SelectOption('+269','Comoros (269)'));
            phoneOptions.add(new SelectOption('+682','Cook Islands (682)'));
            phoneOptions.add(new SelectOption('+506','Costa Rica (506)'));
            phoneOptions.add(new SelectOption('+385','Croatia (385)'));
            phoneOptions.add(new SelectOption('+53','Cuba (53)'));
            phoneOptions.add(new SelectOption('+357','Cyprus (357)'));
            phoneOptions.add(new SelectOption('+420','Czech Republic (420)'));
            phoneOptions.add(new SelectOption('+243','Democratic Republic of the Congo (243)'));
            phoneOptions.add(new SelectOption('+45','Denmark (45)'));
            phoneOptions.add(new SelectOption('+253','Djibouti (253)'));
            phoneOptions.add(new SelectOption('+1 767','Dominica (1 767)'));
            phoneOptions.add(new SelectOption('+1 809','Dominican Republic (1 809)'));
            phoneOptions.add(new SelectOption('+593','Ecuador (593)'));
            phoneOptions.add(new SelectOption('+20','Egypt (20)'));
            phoneOptions.add(new SelectOption('+503','El Salvador (503)'));
            phoneOptions.add(new SelectOption('+240','Equatorial Guinea (240)'));
            phoneOptions.add(new SelectOption('+291','Eritrea (291)'));
            phoneOptions.add(new SelectOption('+372','Estonia (372)'));
            phoneOptions.add(new SelectOption('+251','Ethiopia (251)'));
            phoneOptions.add(new SelectOption('+500','Falkland Islands (500)'));
            phoneOptions.add(new SelectOption('+298','Faroe Islands (298)'));
            phoneOptions.add(new SelectOption('+679','Fiji (679)'));
            phoneOptions.add(new SelectOption('+358','Finland (358)'));
            phoneOptions.add(new SelectOption('+33','France (33)'));
            phoneOptions.add(new SelectOption('+689','French Polynesia (689)'));
            phoneOptions.add(new SelectOption('+241','Gabon (241)'));
            phoneOptions.add(new SelectOption('+220','Gambia (220)'));
            phoneOptions.add(new SelectOption('+970','Gaza Strip (970)'));
            phoneOptions.add(new SelectOption('+995','Georgia (995)'));
            phoneOptions.add(new SelectOption('+49','Germany (49)'));
            phoneOptions.add(new SelectOption('+233','Ghana (233)'));
            phoneOptions.add(new SelectOption('+350','Gibraltar (350)'));
            phoneOptions.add(new SelectOption('+30','Greece (30)'));
            phoneOptions.add(new SelectOption('+299','Greenland (299)'));
            phoneOptions.add(new SelectOption('+1 473','Grenada (1 473)'));
            phoneOptions.add(new SelectOption('+1 671','Guam (1 671)'));
            phoneOptions.add(new SelectOption('+502','Guatemala (502)'));
            phoneOptions.add(new SelectOption('+224','Guinea (224)'));
            phoneOptions.add(new SelectOption('+245','Guinea-Bissau (245)'));
            phoneOptions.add(new SelectOption('+592','Guyana (592)'));
            phoneOptions.add(new SelectOption('+509','Haiti (509)'));
            phoneOptions.add(new SelectOption('+39','Holy See (Vatican City) (39)'));
            phoneOptions.add(new SelectOption('+504','Honduras (504)'));
            phoneOptions.add(new SelectOption('+852','Hong Kong (852)'));
            phoneOptions.add(new SelectOption('+36','Hungary (36)'));
            phoneOptions.add(new SelectOption('+354','Iceland (354)'));
            phoneOptions.add(new SelectOption('+91','India (91)'));
            phoneOptions.add(new SelectOption('+62','Indonesia (62)'));
            phoneOptions.add(new SelectOption('+98','Iran (98)'));
            phoneOptions.add(new SelectOption('+964','Iraq (964)'));
            phoneOptions.add(new SelectOption('+353','Ireland (353)'));
            phoneOptions.add(new SelectOption('+44','Isle of Man (44)'));
            phoneOptions.add(new SelectOption('+972','Israel (972)'));
            phoneOptions.add(new SelectOption('+39','Italy (39)'));
            phoneOptions.add(new SelectOption('+225','Ivory Coast (225)'));
            phoneOptions.add(new SelectOption('+1 876','Jamaica (1 876)'));
            phoneOptions.add(new SelectOption('+81','Japan (81)'));
            phoneOptions.add(new SelectOption('+962','Jordan (962)'));
            phoneOptions.add(new SelectOption('+7','Kazakhstan (7)'));
            phoneOptions.add(new SelectOption('+254','Kenya (254)'));
            phoneOptions.add(new SelectOption('+686','Kiribati (686)'));
            phoneOptions.add(new SelectOption('+381','Kosovo (381)'));
            phoneOptions.add(new SelectOption('+965','Kuwait (965)'));
            phoneOptions.add(new SelectOption('+996','Kyrgyzstan (996)'));
            phoneOptions.add(new SelectOption('+856','Laos (856)'));
            phoneOptions.add(new SelectOption('+371','Latvia (371)'));
            phoneOptions.add(new SelectOption('+961','Lebanon (961)'));
            phoneOptions.add(new SelectOption('+266','Lesotho (266)'));
            phoneOptions.add(new SelectOption('+231','Liberia (231)'));
            phoneOptions.add(new SelectOption('+218','Libya (218)'));
            phoneOptions.add(new SelectOption('+423','Liechtenstein (423)'));
            phoneOptions.add(new SelectOption('+370','Lithuania (370)'));
            phoneOptions.add(new SelectOption('+352','Luxembourg (352)'));
            phoneOptions.add(new SelectOption('+853','Macau (853)'));
            phoneOptions.add(new SelectOption('+389','Macedonia (389)'));
            phoneOptions.add(new SelectOption('+261','Madagascar (261)'));
            phoneOptions.add(new SelectOption('+265','Malawi (265)'));
            phoneOptions.add(new SelectOption('+60','Malaysia (60)'));
            phoneOptions.add(new SelectOption('+960','Maldives (960)'));
            phoneOptions.add(new SelectOption('+223','Mali (223)'));
            phoneOptions.add(new SelectOption('+356','Malta (356)'));
            phoneOptions.add(new SelectOption('+692','Marshall Islands (692)'));
            phoneOptions.add(new SelectOption('+222','Mauritania (222)'));
            phoneOptions.add(new SelectOption('+230','Mauritius (230)'));
            phoneOptions.add(new SelectOption('+262','Mayotte (262)'));
            phoneOptions.add(new SelectOption('+52','Mexico (52)'));
            phoneOptions.add(new SelectOption('+691','Micronesia (691)'));
            phoneOptions.add(new SelectOption('+373','Moldova (373)'));
            phoneOptions.add(new SelectOption('+377','Monaco (377)'));
            phoneOptions.add(new SelectOption('+976','Mongolia (976)'));
            phoneOptions.add(new SelectOption('+382','Montenegro (382)'));
            phoneOptions.add(new SelectOption('+1 664','Montserrat (1 664)'));
            phoneOptions.add(new SelectOption('+212','Morocco (212)'));
            phoneOptions.add(new SelectOption('+258','Mozambique (258)'));
            phoneOptions.add(new SelectOption('+264','Namibia (264)'));
            phoneOptions.add(new SelectOption('+674','Nauru (674)'));
            phoneOptions.add(new SelectOption('+977','Nepal (977)'));
            phoneOptions.add(new SelectOption('+31','Netherlands (31)'));
            phoneOptions.add(new SelectOption('+599','Netherlands Antilles (599)'));
            phoneOptions.add(new SelectOption('+687','New Caledonia (687)'));
            phoneOptions.add(new SelectOption('+64','New Zealand (64)'));
            phoneOptions.add(new SelectOption('+505','Nicaragua (505)'));
            phoneOptions.add(new SelectOption('+227','Niger (227)'));
            phoneOptions.add(new SelectOption('+234','Nigeria (234)'));
            phoneOptions.add(new SelectOption('+683','Niue (683)'));
            phoneOptions.add(new SelectOption('+672','Norfolk Island (672)'));
            phoneOptions.add(new SelectOption('+850','North Korea (850)'));
            phoneOptions.add(new SelectOption('+1 670','Northern Mariana Islands (1 670)'));
            phoneOptions.add(new SelectOption('+47','Norway (47)'));
            phoneOptions.add(new SelectOption('+968','Oman (968)'));
            phoneOptions.add(new SelectOption('+92','Pakistan (92)'));
            phoneOptions.add(new SelectOption('+680','Palau (680)'));
            phoneOptions.add(new SelectOption('+507','Panama (507)'));
            phoneOptions.add(new SelectOption('+675','Papua New Guinea (675)'));
            phoneOptions.add(new SelectOption('+595','Paraguay (595)'));
            phoneOptions.add(new SelectOption('+51','Peru (51)'));
            phoneOptions.add(new SelectOption('+63','Philippines (63)'));
            phoneOptions.add(new SelectOption('+870','Pitcairn Islands (870)'));
            phoneOptions.add(new SelectOption('+48','Poland (48)'));
            phoneOptions.add(new SelectOption('+351','Portugal (351)'));
            phoneOptions.add(new SelectOption('+1','Puerto Rico (1)'));
            phoneOptions.add(new SelectOption('+974','Qatar (974)'));
            phoneOptions.add(new SelectOption('+242','Republic of the Congo (242)'));
            phoneOptions.add(new SelectOption('+40','Romania (40)'));
            phoneOptions.add(new SelectOption('+7','Russia (7)'));
            phoneOptions.add(new SelectOption('+250','Rwanda (250)'));
            phoneOptions.add(new SelectOption('+590','Saint Barthelemy (590)'));
            phoneOptions.add(new SelectOption('+290','Saint Helena (290)'));
            phoneOptions.add(new SelectOption('+1 869','Saint Kitts and Nevis (1 869)'));
            phoneOptions.add(new SelectOption('+1 758','Saint Lucia (1 758)'));
            phoneOptions.add(new SelectOption('+1 599','Saint Martin (1 599)'));
            phoneOptions.add(new SelectOption('+508','Saint Pierre and Miquelon (508)'));
            phoneOptions.add(new SelectOption('+1 784','Saint Vincent and the Grenadines (1 784)'));
            phoneOptions.add(new SelectOption('+685','Samoa (685)'));
            phoneOptions.add(new SelectOption('+378','San Marino (378)'));
            phoneOptions.add(new SelectOption('+239','Sao Tome and Principe (239)'));
            phoneOptions.add(new SelectOption('+966','Saudi Arabia (966)'));
            phoneOptions.add(new SelectOption('+221','Senegal (221)'));
            phoneOptions.add(new SelectOption('+381','Serbia (381)'));
            phoneOptions.add(new SelectOption('+248','Seychelles (248)'));
            phoneOptions.add(new SelectOption('+232','Sierra Leone (232)'));
            phoneOptions.add(new SelectOption('+65','Singapore (65)'));
            phoneOptions.add(new SelectOption('+421','Slovakia (421)'));
            phoneOptions.add(new SelectOption('+386','Slovenia (386)'));
            phoneOptions.add(new SelectOption('+677','Solomon Islands (677)'));
            phoneOptions.add(new SelectOption('+252','Somalia (252)'));
            phoneOptions.add(new SelectOption('+27','South Africa (27)'));
            phoneOptions.add(new SelectOption('+82','South Korea (82)'));
            phoneOptions.add(new SelectOption('+34','Spain (34)'));
            phoneOptions.add(new SelectOption('+94','Sri Lanka (94)'));
            phoneOptions.add(new SelectOption('+249','Sudan (249)'));
            phoneOptions.add(new SelectOption('+597','Suriname (597)'));
            phoneOptions.add(new SelectOption('+268','Swaziland (268)'));
            phoneOptions.add(new SelectOption('+46','Sweden (46)'));
            phoneOptions.add(new SelectOption('+41','Switzerland (41)'));
            phoneOptions.add(new SelectOption('+963','Syria (963)'));
            phoneOptions.add(new SelectOption('+886','Taiwan (886)'));
            phoneOptions.add(new SelectOption('+992','Tajikistan (992)'));
            phoneOptions.add(new SelectOption('+255','Tanzania (255)'));
            phoneOptions.add(new SelectOption('+66','Thailand (66)'));
            phoneOptions.add(new SelectOption('+670','Timor-Leste (670)'));
            phoneOptions.add(new SelectOption('+228','Togo (228)'));
            phoneOptions.add(new SelectOption('+690','Tokelau (690)'));
            phoneOptions.add(new SelectOption('+676','Tonga (676)'));
            phoneOptions.add(new SelectOption('+1 868','Trinidad and Tobago (1 868)'));
            phoneOptions.add(new SelectOption('+216','Tunisia (216)'));
            phoneOptions.add(new SelectOption('+90','Turkey (90)'));
            phoneOptions.add(new SelectOption('+993','Turkmenistan (993)'));
            phoneOptions.add(new SelectOption('+1 649','Turks and Caicos Islands (1 649)'));
            phoneOptions.add(new SelectOption('+688','Tuvalu (688)'));
            phoneOptions.add(new SelectOption('+256','Uganda (256)'));
            phoneOptions.add(new SelectOption('+380','Ukraine (380)'));
            phoneOptions.add(new SelectOption('+971','United Arab Emirates (971)'));
            phoneOptions.add(new SelectOption('+44','United Kingdom (44)'));
            phoneOptions.add(new SelectOption('+1','United States (1)'));
            phoneOptions.add(new SelectOption('+598','Uruguay (598)'));
            phoneOptions.add(new SelectOption('+1 340','US Virgin Islands (1 340)'));
            phoneOptions.add(new SelectOption('+998','Uzbekistan (998)'));
            phoneOptions.add(new SelectOption('+678','Vanuatu (678)'));
            phoneOptions.add(new SelectOption('+58','Venezuela (58)'));
            phoneOptions.add(new SelectOption('+84','Vietnam (84)'));
            phoneOptions.add(new SelectOption('+681','Wallis and Futuna (681)'));
            phoneOptions.add(new SelectOption('+970','West Bank (970)'));
            phoneOptions.add(new SelectOption('+967','Yemen (967)'));
            phoneOptions.add(new SelectOption('+260','Zambia (260)'));
            phoneOptions.add(new SelectOption('+263','Zimbabwe (263)'));
          //Return SelectOption List
          return phoneOptions;
      }
  }   
    
  public final static String ID_PARAMETER = 'id';
  public final static String APPLICANT_INFO = 'Applicant_Info__c';
  // public final static String ACCOMODATION_FEE = 'Accommodation_Placement_Fee';
  public final static String CENTERS = 'Centers';
  public final static String DASH = '-';
  public final static String CAMBRIGE_FCE_PRODUCT_NAME = 'Cambridge FCE & CAE Preparation';
  public final static String ACADEMIC_PROGRAMS = 'Academic Programs';
  
  /*public static Map<String, Site_Text__c> MAP_SITE_TEXT {
    
    get {
      
      //Checking map for null value
      if(MAP_SITE_TEXT == null) {        
        
        //Memory allocation to the map
        MAP_SITE_TEXT = new Map<String, Site_Text__c>();        
    
        //List to hold the custom setting data
        List<Site_Text__c> configs = Site_Text__c.getAll().values();
              
        //Loop through all the custom setting records        
        for(Site_Text__c config : configs) {          
          
          //Checking if Name is not null          
          if(config.Name == null || config.Name.trim() == '') 
            continue;         
            
          //Populate map with the values
          MAP_SITE_TEXT.put(config.Name + Constants.DASH + config.Site__c, config);        
        }
      }
      
      //Return map
      return MAP_SITE_TEXT;
    }
   }*/
 
    //CT-119 User is not allowed to save page when user selects Accommodation Preference "homestay" and fills up all the mandatory fields.
    public final static String HOMESTAY = 'Homestay';
    //CT-119 End
    
    //CT-109
    public final static String UNLIMITED_PACKAGE = 'Unlimited Package';
    public final static String SELF_DIRECTED = 'Self-Directed';
    public final static String PROFESSIONAL_CERTIFICATE = 'Professional Certificates';
    public final static String INTENSITY = 'Intensity';
    public final static String PACKAGE_DELIEVERY = 'Package Delivery';
    public final static String INSURANCE = 'Insurance';
    public final static String ACCOMODATION = 'Accommodation';
    public final static String PRIVATE_LESSONS = 'Private Lessons';
    public final static String BASIC = 'Basic';
    public final static String MAIN = 'Main';
    //CT-109 End
    
    //CT-112
    public final static String CUSTOM_TYPE = 'Custom';
    public final static String PACKAGE_TYPE = 'Package';
    //CT-112 End
    
    
    //MT_191
    public static List<DeploymentTestCreation__c> lstDeployTestFlag;
    public static boolean blnDeployTestFlag 
    { get
        { boolean flag; 
        lstDeployTestFlag = DeploymentTestCreation__c.getAll().Values(); 
        system.debug('*******lstDeployTestFlag*******'+lstDeployTestFlag);
         if(lstDeployTestFlag!=null && lstDeployTestFlag.size()>0) 
         { 
            For(DeploymentTestCreation__c DeployTest : lstDeployTestFlag) 
            { 
                if(DeployTest.Name=='DeployTestFlag') flag = DeployTest.TestFlag__c; 
            } 
         
          system.debug('*******flag*******'+flag); 
          return flag;
         }
        else
        return true;
        }
        
     }
    //MT-191 End    
    
        
}