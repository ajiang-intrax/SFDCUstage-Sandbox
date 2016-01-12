public with sharing class DocuSignAPI {
	
public class PublishConnectFailures_element {
        public DocuSignAPI.PublishConnectFailuresFilter PublishConnectFailuresFilter;
        private String[] PublishConnectFailuresFilter_type_info = new String[]{'PublishConnectFailuresFilter','http://www.docusign.net/API/3.0','PublishConnectFailuresFilter','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'PublishConnectFailuresFilter'};
    }
    public class VoidEnvelope_element {
        public String EnvelopeID;
        public String Reason;
        private String[] EnvelopeID_type_info = new String[]{'EnvelopeID','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Reason_type_info = new String[]{'Reason','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'EnvelopeID','Reason'};
    }
    public class Reminders {
        public Boolean ReminderEnabled;
        public Integer ReminderDelay;
        public Integer ReminderFrequency;
        private String[] ReminderEnabled_type_info = new String[]{'ReminderEnabled','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] ReminderDelay_type_info = new String[]{'ReminderDelay','http://www.w3.org/2001/XMLSchema','nonNegativeInteger','0','1','false'};
        private String[] ReminderFrequency_type_info = new String[]{'ReminderFrequency','http://www.w3.org/2001/XMLSchema','nonNegativeInteger','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'ReminderEnabled','ReminderDelay','ReminderFrequency'};
    }
    public class ArrayOfInlineTemplate {
        public DocuSignAPI.InlineTemplate[] InlineTemplate;
        private String[] InlineTemplate_type_info = new String[]{'InlineTemplate','http://www.docusign.net/API/3.0','InlineTemplate','0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'InlineTemplate'};
    }
    public class BrandRequestItem {
        public String BrandId;
        private String[] BrandId_type_info = new String[]{'BrandId','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'BrandId'};
    }
    public class RecipientEsignList {
        public String AccountId;
        public DocuSignAPI.ArrayOfRecipientEsign RecipientEsign;
        private String[] AccountId_type_info = new String[]{'AccountId','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] RecipientEsign_type_info = new String[]{'RecipientEsign','http://www.docusign.net/API/3.0','ArrayOfRecipientEsign','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'AccountId','RecipientEsign'};
    }
    public class BrandResults {
        public String RecipientBrandIdDefault;
        public String SenderBrandIdDefault;
        public DocuSignAPI.ArrayOfBrandResultItem BrandResultItems;
        private String[] RecipientBrandIdDefault_type_info = new String[]{'RecipientBrandIdDefault','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] SenderBrandIdDefault_type_info = new String[]{'SenderBrandIdDefault','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] BrandResultItems_type_info = new String[]{'BrandResultItems','http://www.docusign.net/API/3.0','ArrayOfBrandResultItem','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'RecipientBrandIdDefault','SenderBrandIdDefault','BrandResultItems'};
    }
    public class UpdateAddressBookItems_element {
        public DocuSignAPI.ArrayOfAddressBookItem AddressBookItems;
        public Boolean ReturnAddressBook;
        private String[] AddressBookItems_type_info = new String[]{'AddressBookItems','http://www.docusign.net/API/3.0','ArrayOfAddressBookItem','0','1','false'};
        private String[] ReturnAddressBook_type_info = new String[]{'ReturnAddressBook','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'AddressBookItems','ReturnAddressBook'};
    }
    public class DeleteEnvelopesResponse_element {
        public Boolean DeleteEnvelopesResult;
        private String[] DeleteEnvelopesResult_type_info = new String[]{'DeleteEnvelopesResult','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'DeleteEnvelopesResult'};
    }
    public class CreateEnvelopeFromTemplatesAndForms_element {
        public DocuSignAPI.EnvelopeInformation EnvelopeInformation;
        public DocuSignAPI.ArrayOfCompositeTemplate CompositeTemplates;
        public Boolean ActivateEnvelope;
        private String[] EnvelopeInformation_type_info = new String[]{'EnvelopeInformation','http://www.docusign.net/API/3.0','EnvelopeInformation','0','1','false'};
        private String[] CompositeTemplates_type_info = new String[]{'CompositeTemplates','http://www.docusign.net/API/3.0','ArrayOfCompositeTemplate','0','1','false'};
        private String[] ActivateEnvelope_type_info = new String[]{'ActivateEnvelope','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'EnvelopeInformation','CompositeTemplates','ActivateEnvelope'};
    }
    public class SendEnvelope_element {
        public String EnvelopeId;
        public String AccountId;
        private String[] EnvelopeId_type_info = new String[]{'EnvelopeId','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] AccountId_type_info = new String[]{'AccountId','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'EnvelopeId','AccountId'};
    }
    public class RequestDocumentPDFsEx_element {
        public String EnvelopeID;
        private String[] EnvelopeID_type_info = new String[]{'EnvelopeID','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'EnvelopeID'};
    }
    public class AuthoritativeCopyExportStatus {
        public Boolean AuthoritativeCopyExportSuccess;
        public String EnvelopeId;
        public String ExportKey;
        private String[] AuthoritativeCopyExportSuccess_type_info = new String[]{'AuthoritativeCopyExportSuccess','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] EnvelopeId_type_info = new String[]{'EnvelopeId','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] ExportKey_type_info = new String[]{'ExportKey','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'AuthoritativeCopyExportSuccess','EnvelopeId','ExportKey'};
    }
    public class SynchEnvelopeResponse_element {
        public DocuSignAPI.SynchEnvelopeStatus SynchEnvelopeResult;
        private String[] SynchEnvelopeResult_type_info = new String[]{'SynchEnvelopeResult','http://www.docusign.net/API/3.0','SynchEnvelopeStatus','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'SynchEnvelopeResult'};
    }
    public class ArrayOfFolderItem {
        public DocuSignAPI.FolderItem[] FolderItem;
        private String[] FolderItem_type_info = new String[]{'FolderItem','http://www.docusign.net/API/3.0','FolderItem','0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'FolderItem'};
    }
    public class EnvelopeStatus {
        public DocuSignAPI.ArrayOfRecipientStatus RecipientStatuses;
        public DateTime TimeGenerated;
        public String EnvelopeID;
        public String Subject;
        public String UserName;
        public String Email;
        public String Status;
        public DateTime Created;
        public DateTime Deleted;
        public DateTime Sent;
        public DateTime Delivered;
        public DateTime Signed;
        public DateTime Completed;
        public DateTime Declined;
        public DateTime TimedOut;
        public String ACStatus;
        public DateTime ACStatusDate;
        public String ACHolder;
        public String ACHolderEmail;
        public String ACHolderLocation;
        public String SigningLocation;
        public String SenderIPAddress;
        public String EnvelopePDFHash;
        public DocuSignAPI.ArrayOfCustomField CustomFields;
        public DocuSignAPI.VaultingDetails VaultingDetails;
        public Boolean AutoNavigation;
        public Boolean EnvelopeIdStamping;
        public Boolean AuthoritativeCopy;
        public DocuSignAPI.ArrayOfAttachment EnvelopeAttachment;
        public DocuSignAPI.ArrayOfDocumentStatus DocumentStatuses;
        public DocuSignAPI.FormData FormData;
        private String[] RecipientStatuses_type_info = new String[]{'RecipientStatuses','http://www.docusign.net/API/3.0','ArrayOfRecipientStatus','1','1','true'};
        private String[] TimeGenerated_type_info = new String[]{'TimeGenerated','http://www.w3.org/2001/XMLSchema','dateTime','1','1','false'};
        private String[] EnvelopeID_type_info = new String[]{'EnvelopeID','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Subject_type_info = new String[]{'Subject','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] UserName_type_info = new String[]{'UserName','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Email_type_info = new String[]{'Email','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Status_type_info = new String[]{'Status','http://www.docusign.net/API/3.0','EnvelopeStatusCode','1','1','false'};
        private String[] Created_type_info = new String[]{'Created','http://www.w3.org/2001/XMLSchema','dateTime','1','1','false'};
        private String[] Deleted_type_info = new String[]{'Deleted','http://www.w3.org/2001/XMLSchema','dateTime','0','1','false'};
        private String[] Sent_type_info = new String[]{'Sent','http://www.w3.org/2001/XMLSchema','dateTime','0','1','false'};
        private String[] Delivered_type_info = new String[]{'Delivered','http://www.w3.org/2001/XMLSchema','dateTime','0','1','false'};
        private String[] Signed_type_info = new String[]{'Signed','http://www.w3.org/2001/XMLSchema','dateTime','0','1','false'};
        private String[] Completed_type_info = new String[]{'Completed','http://www.w3.org/2001/XMLSchema','dateTime','0','1','false'};
        private String[] Declined_type_info = new String[]{'Declined','http://www.w3.org/2001/XMLSchema','dateTime','0','1','false'};
        private String[] TimedOut_type_info = new String[]{'TimedOut','http://www.w3.org/2001/XMLSchema','dateTime','0','1','false'};
        private String[] ACStatus_type_info = new String[]{'ACStatus','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] ACStatusDate_type_info = new String[]{'ACStatusDate','http://www.w3.org/2001/XMLSchema','dateTime','1','1','false'};
        private String[] ACHolder_type_info = new String[]{'ACHolder','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] ACHolderEmail_type_info = new String[]{'ACHolderEmail','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] ACHolderLocation_type_info = new String[]{'ACHolderLocation','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] SigningLocation_type_info = new String[]{'SigningLocation','http://www.docusign.net/API/3.0','SigningLocationCode','1','1','false'};
        private String[] SenderIPAddress_type_info = new String[]{'SenderIPAddress','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] EnvelopePDFHash_type_info = new String[]{'EnvelopePDFHash','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] CustomFields_type_info = new String[]{'CustomFields','http://www.docusign.net/API/3.0','ArrayOfCustomField','0','1','false'};
        private String[] VaultingDetails_type_info = new String[]{'VaultingDetails','http://www.docusign.net/API/3.0','VaultingDetails','0','1','false'};
        private String[] AutoNavigation_type_info = new String[]{'AutoNavigation','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] EnvelopeIdStamping_type_info = new String[]{'EnvelopeIdStamping','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] AuthoritativeCopy_type_info = new String[]{'AuthoritativeCopy','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] EnvelopeAttachment_type_info = new String[]{'EnvelopeAttachment','http://www.docusign.net/API/3.0','ArrayOfAttachment','0','1','false'};
        private String[] DocumentStatuses_type_info = new String[]{'DocumentStatuses','http://www.docusign.net/API/3.0','ArrayOfDocumentStatus','0','1','false'};
        private String[] FormData_type_info = new String[]{'FormData','http://www.docusign.net/API/3.0','FormData','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'RecipientStatuses','TimeGenerated','EnvelopeID','Subject','UserName','Email','Status','Created','Deleted','Sent','Delivered','Signed','Completed','Declined','TimedOut','ACStatus','ACStatusDate','ACHolder','ACHolderEmail','ACHolderLocation','SigningLocation','SenderIPAddress','EnvelopePDFHash','CustomFields','VaultingDetails','AutoNavigation','EnvelopeIdStamping','AuthoritativeCopy','EnvelopeAttachment','DocumentStatuses','FormData'};
    }
    public class GetRecipientEsignList_element {
        public String UserName;
        public String SenderEmail;
        public String SenderAccountId;
        public String RecipientEmail;
        private String[] UserName_type_info = new String[]{'UserName','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] SenderEmail_type_info = new String[]{'SenderEmail','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] SenderAccountId_type_info = new String[]{'SenderAccountId','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] RecipientEmail_type_info = new String[]{'RecipientEmail','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'UserName','SenderEmail','SenderAccountId','RecipientEmail'};
    }
    public class EventResult {
        public String Status;
        public DateTime EventTimestamp;
        public String FailureDescription;
        public String VendorFailureStatusCode;
        private String[] Status_type_info = new String[]{'Status','http://www.docusign.net/API/3.0','EventStatusCode','1','1','false'};
        private String[] EventTimestamp_type_info = new String[]{'EventTimestamp','http://www.w3.org/2001/XMLSchema','dateTime','1','1','false'};
        private String[] FailureDescription_type_info = new String[]{'FailureDescription','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] VendorFailureStatusCode_type_info = new String[]{'VendorFailureStatusCode','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'Status','EventTimestamp','FailureDescription','VendorFailureStatusCode'};
    }
    public class CreateEnvelopeResponse_element {
        public DocuSignAPI.EnvelopeStatus CreateEnvelopeResult;
        private String[] CreateEnvelopeResult_type_info = new String[]{'CreateEnvelopeResult','http://www.docusign.net/API/3.0','EnvelopeStatus','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'CreateEnvelopeResult'};
    }
    public class RecipientCorrectionStatus {
        public Boolean CorrectionSucceeded;
        public DocuSignAPI.RecipientCorrection RecipientCorrection;
        public DocuSignAPI.RecipientStatus RecipientStatus;
        private String[] CorrectionSucceeded_type_info = new String[]{'CorrectionSucceeded','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] RecipientCorrection_type_info = new String[]{'RecipientCorrection','http://www.docusign.net/API/3.0','RecipientCorrection','0','1','false'};
        private String[] RecipientStatus_type_info = new String[]{'RecipientStatus','http://www.docusign.net/API/3.0','RecipientStatus','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'CorrectionSucceeded','RecipientCorrection','RecipientStatus'};
    }
    public class SSN4Information {
        public String SSN4;
        private String[] SSN4_type_info = new String[]{'SSN4','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'SSN4'};
    }
    public class Expirations {
        public Boolean ExpireEnabled;
        public Integer ExpireAfter;
        public Integer ExpireWarn;
        private String[] ExpireEnabled_type_info = new String[]{'ExpireEnabled','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] ExpireAfter_type_info = new String[]{'ExpireAfter','http://www.w3.org/2001/XMLSchema','nonNegativeInteger','0','1','false'};
        private String[] ExpireWarn_type_info = new String[]{'ExpireWarn','http://www.w3.org/2001/XMLSchema','nonNegativeInteger','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'ExpireEnabled','ExpireAfter','ExpireWarn'};
    }
    public class RequestPDFNoWaterMark_element {
        public String EnvelopeID;
        private String[] EnvelopeID_type_info = new String[]{'EnvelopeID','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'EnvelopeID'};
    }
    public class RequestDocumentPDFsRecipientsViewResponse_element {
        public DocuSignAPI.DocumentPDFs RequestDocumentPDFsRecipientsViewResult;
        private String[] RequestDocumentPDFsRecipientsViewResult_type_info = new String[]{'RequestDocumentPDFsRecipientsViewResult','http://www.docusign.net/API/3.0','DocumentPDFs','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'RequestDocumentPDFsRecipientsViewResult'};
    }
    public class DocuSignEnvelopeInformation {
        public DocuSignAPI.EnvelopeStatus EnvelopeStatus;
        public DocuSignAPI.ArrayOfDocumentPDF DocumentPDFs;
        public String TimeZone;
        public Integer TimeZoneOffset;
        private String[] EnvelopeStatus_type_info = new String[]{'EnvelopeStatus','http://www.docusign.net/API/3.0','EnvelopeStatus','0','1','false'};
        private String[] DocumentPDFs_type_info = new String[]{'DocumentPDFs','http://www.docusign.net/API/3.0','ArrayOfDocumentPDF','0','1','false'};
        private String[] TimeZone_type_info = new String[]{'TimeZone','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] TimeZoneOffset_type_info = new String[]{'TimeZoneOffset','http://www.w3.org/2001/XMLSchema','int','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'EnvelopeStatus','DocumentPDFs','TimeZone','TimeZoneOffset'};
    }
    public class FolderItem {
        public String EnvelopeId;
        public String Status;
        public String Owner;
        public String SenderName;
        public String SenderEmail;
        public String SenderCompany;
        public DocuSignAPI.ArrayOfRecipientStatus RecipientStatuses;
        public DocuSignAPI.ArrayOfCustomField CustomFields;
        public DateTime Created;
        public DateTime Sent;
        public DateTime Completed;
        public String Subject;
        private String[] EnvelopeId_type_info = new String[]{'EnvelopeId','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Status_type_info = new String[]{'Status','http://www.docusign.net/API/3.0','EnvelopeStatusCode','1','1','false'};
        private String[] Owner_type_info = new String[]{'Owner','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] SenderName_type_info = new String[]{'SenderName','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] SenderEmail_type_info = new String[]{'SenderEmail','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] SenderCompany_type_info = new String[]{'SenderCompany','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] RecipientStatuses_type_info = new String[]{'RecipientStatuses','http://www.docusign.net/API/3.0','ArrayOfRecipientStatus','0','1','false'};
        private String[] CustomFields_type_info = new String[]{'CustomFields','http://www.docusign.net/API/3.0','ArrayOfCustomField','0','1','false'};
        private String[] Created_type_info = new String[]{'Created','http://www.w3.org/2001/XMLSchema','dateTime','0','1','false'};
        private String[] Sent_type_info = new String[]{'Sent','http://www.w3.org/2001/XMLSchema','dateTime','0','1','false'};
        private String[] Completed_type_info = new String[]{'Completed','http://www.w3.org/2001/XMLSchema','dateTime','0','1','false'};
        private String[] Subject_type_info = new String[]{'Subject','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'EnvelopeId','Status','Owner','SenderName','SenderEmail','SenderCompany','RecipientStatuses','CustomFields','Created','Sent','Completed','Subject'};
    }
    public class RequestPDFsWithOptions_element {
        public String EnvelopeID;
        public DocuSignAPI.PDFsOptions PDFsOptions;
        private String[] EnvelopeID_type_info = new String[]{'EnvelopeID','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] PDFsOptions_type_info = new String[]{'PDFsOptions','http://www.docusign.net/API/3.0','PDFsOptions','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'EnvelopeID','PDFsOptions'};
    }
    public class RequestDocumentPDFsRecipientsView_element {
        public String EnvelopeID;
        public String RecipientName;
        public String RecipientEmail;
        private String[] EnvelopeID_type_info = new String[]{'EnvelopeID','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] RecipientName_type_info = new String[]{'RecipientName','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] RecipientEmail_type_info = new String[]{'RecipientEmail','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'EnvelopeID','RecipientName','RecipientEmail'};
    }
    public class GetFolderList_element {
        public DocuSignAPI.FoldersFilter FoldersFilter;
        private String[] FoldersFilter_type_info = new String[]{'FoldersFilter','http://www.docusign.net/API/3.0','FoldersFilter','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'FoldersFilter'};
    }
    public class RequestStatusesResponse_element {
        public DocuSignAPI.FilteredEnvelopeStatuses RequestStatusesResult;
        private String[] RequestStatusesResult_type_info = new String[]{'RequestStatusesResult','http://www.docusign.net/API/3.0','FilteredEnvelopeStatuses','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'RequestStatusesResult'};
    }
    public class CreateAccountBrands_element {
        public String AccountId;
        public DocuSignAPI.BrandDefinitions BrandDefinitions;
        private String[] AccountId_type_info = new String[]{'AccountId','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] BrandDefinitions_type_info = new String[]{'BrandDefinitions','http://www.docusign.net/API/3.0','BrandDefinitions','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'AccountId','BrandDefinitions'};
    }
    public class RecipientCorrectionCorrectedCaptiveInfo {
        public String ClientUserId;
        private String[] ClientUserId_type_info = new String[]{'ClientUserId','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'ClientUserId'};
    }
    public class CreateAccountBrandsResponse_element {
        public DocuSignAPI.BrandResults CreateAccountBrandsResult;
        private String[] CreateAccountBrandsResult_type_info = new String[]{'CreateAccountBrandsResult','http://www.docusign.net/API/3.0','BrandResults','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'CreateAccountBrandsResult'};
    }
    public class GetStatusInDocuSignConnectFormatResponse_element {
        public DocuSignAPI.DocuSignEnvelopeInformation GetStatusInDocuSignConnectFormatResult;
        private String[] GetStatusInDocuSignConnectFormatResult_type_info = new String[]{'GetStatusInDocuSignConnectFormatResult','http://www.docusign.net/API/3.0','DocuSignEnvelopeInformation','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'GetStatusInDocuSignConnectFormatResult'};
    }
    public class ArrayOfConnectFailure {
        public DocuSignAPI.ConnectFailure[] ConnectFailure;
        private String[] ConnectFailure_type_info = new String[]{'ConnectFailure','http://www.docusign.net/API/3.0','ConnectFailure','0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'ConnectFailure'};
    }
    public class CreateAndSendEnvelope_element {
        public DocuSignAPI.Envelope Envelope;
        private String[] Envelope_type_info = new String[]{'Envelope','http://www.docusign.net/API/3.0','Envelope','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'Envelope'};
        private integer timeout_x;
    }
    public class ArrayOfMatchBox {
        public DocuSignAPI.MatchBox[] MatchBox;
        private String[] MatchBox_type_info = new String[]{'MatchBox','http://www.docusign.net/API/3.0','MatchBox','0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'MatchBox'};
    }
    public class RequestRecipientToken_element {
        public String EnvelopeID;
        public String ClientUserID;
        public String Username;
        public String Email;
        public DocuSignAPI.RequestRecipientTokenAuthenticationAssertion AuthenticationAssertion;
        public DocuSignAPI.RequestRecipientTokenClientURLs ClientURLs;
        private String[] EnvelopeID_type_info = new String[]{'EnvelopeID','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] ClientUserID_type_info = new String[]{'ClientUserID','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Username_type_info = new String[]{'Username','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Email_type_info = new String[]{'Email','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] AuthenticationAssertion_type_info = new String[]{'AuthenticationAssertion','http://www.docusign.net/API/3.0','RequestRecipientTokenAuthenticationAssertion','0','1','false'};
        private String[] ClientURLs_type_info = new String[]{'ClientURLs','http://www.docusign.net/API/3.0','RequestRecipientTokenClientURLs','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'EnvelopeID','ClientUserID','Username','Email','AuthenticationAssertion','ClientURLs'};
    }
    public class TransferEnvelopeStatus {
        public Boolean TransferEnvelopeSuccess;
        private String[] TransferEnvelopeSuccess_type_info = new String[]{'TransferEnvelopeSuccess','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'TransferEnvelopeSuccess'};
    }
    public class ArrayOfDocumentStatus {
        public DocuSignAPI.DocumentStatus[] DocumentStatus;
        private String[] DocumentStatus_type_info = new String[]{'DocumentStatus','http://www.docusign.net/API/3.0','DocumentStatus','0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'DocumentStatus'};
    }
    public class ArrayOfEnvelopeStatusCode {
        public String[] Status;
        private String[] Status_type_info = new String[]{'Status','http://www.docusign.net/API/3.0','EnvelopeStatusCode','0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'Status'};
    }
    public class RecipientList {
        public Boolean ReservedRecipientEmail;
        public Boolean MultipleUsers;
        public DocuSignAPI.ArrayOfString3 RecipientName;
        private String[] ReservedRecipientEmail_type_info = new String[]{'ReservedRecipientEmail','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] MultipleUsers_type_info = new String[]{'MultipleUsers','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] RecipientName_type_info = new String[]{'RecipientName','http://www.docusign.net/API/3.0','ArrayOfString3','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'ReservedRecipientEmail','MultipleUsers','RecipientName'};
    }
    public class RequestTemplateList_element {
        public DocuSignAPI.ArrayOfString5 TemplateIDs;
        public Boolean IncludeDocumentBytes;
        private String[] TemplateIDs_type_info = new String[]{'TemplateIDs','http://www.docusign.net/API/3.0','ArrayOfString5','0','1','false'};
        private String[] IncludeDocumentBytes_type_info = new String[]{'IncludeDocumentBytes','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'TemplateIDs','IncludeDocumentBytes'};
    }
    public class RequestStatusCodes_element {
        public DocuSignAPI.EnvelopeStatusFilter EnvelopeStatusFilter;
        private String[] EnvelopeStatusFilter_type_info = new String[]{'EnvelopeStatusFilter','http://www.docusign.net/API/3.0','EnvelopeStatusFilter','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'EnvelopeStatusFilter'};
    }
    public class IDCheckInformation {
        public DocuSignAPI.AddressInformation AddressInformation;
        public DocuSignAPI.DOBInformation DOBInformation;
        public DocuSignAPI.SSN4Information SSN4Information;
        private String[] AddressInformation_type_info = new String[]{'AddressInformation','http://www.docusign.net/API/3.0','AddressInformation','0','1','false'};
        private String[] DOBInformation_type_info = new String[]{'DOBInformation','http://www.docusign.net/API/3.0','DOBInformation','0','1','false'};
        private String[] SSN4Information_type_info = new String[]{'SSN4Information','http://www.docusign.net/API/3.0','SSN4Information','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'AddressInformation','DOBInformation','SSN4Information'};
    }
    public class ServerTemplate {
        public Integer Sequence;
        public String TemplateID;
        private String[] Sequence_type_info = new String[]{'Sequence','http://www.w3.org/2001/XMLSchema','positiveInteger','0','1','false'};
        private String[] TemplateID_type_info = new String[]{'TemplateID','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'Sequence','TemplateID'};
    }
    public class RemoveAddressBookItems_element {
        public DocuSignAPI.ArrayOfAddressBookRemoveItem AddressBookRemoveItems;
        public Boolean ReturnAddressBook;
        private String[] AddressBookRemoveItems_type_info = new String[]{'AddressBookRemoveItems','http://www.docusign.net/API/3.0','ArrayOfAddressBookRemoveItem','0','1','false'};
        private String[] ReturnAddressBook_type_info = new String[]{'ReturnAddressBook','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'AddressBookRemoveItems','ReturnAddressBook'};
    }
    public class IDCheckInformationInput {
        public DocuSignAPI.AddressInformationInput AddressInformationInput;
        public DocuSignAPI.DOBInformationInput DOBInformationInput;
        public DocuSignAPI.SSN4InformationInput SSN4InformationInput;
        public DocuSignAPI.SSN9InformationInput SSN9InformationInput;
        private String[] AddressInformationInput_type_info = new String[]{'AddressInformationInput','http://www.docusign.net/API/3.0','AddressInformationInput','0','1','false'};
        private String[] DOBInformationInput_type_info = new String[]{'DOBInformationInput','http://www.docusign.net/API/3.0','DOBInformationInput','0','1','false'};
        private String[] SSN4InformationInput_type_info = new String[]{'SSN4InformationInput','http://www.docusign.net/API/3.0','SSN4InformationInput','0','1','false'};
        private String[] SSN9InformationInput_type_info = new String[]{'SSN9InformationInput','http://www.docusign.net/API/3.0','SSN9InformationInput','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'AddressInformationInput','DOBInformationInput','SSN4InformationInput','SSN9InformationInput'};
    }
    public class PDFOptions {
        public Boolean ShowChanges;
        public Boolean AddWaterMark;
        public Boolean IncludeCert;
        private String[] ShowChanges_type_info = new String[]{'ShowChanges','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] AddWaterMark_type_info = new String[]{'AddWaterMark','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] IncludeCert_type_info = new String[]{'IncludeCert','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'ShowChanges','AddWaterMark','IncludeCert'};
    }
    public class RequestTemplateListResponse_element {
        public DocuSignAPI.ArrayOfEnvelopeTemplate RequestTemplateListResult;
        private String[] RequestTemplateListResult_type_info = new String[]{'RequestTemplateListResult','http://www.docusign.net/API/3.0','ArrayOfEnvelopeTemplate','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'RequestTemplateListResult'};
    }
    public class GetFolderItems_element {
        public DocuSignAPI.FolderFilter FolderFilter;
        private String[] FolderFilter_type_info = new String[]{'FolderFilter','http://www.docusign.net/API/3.0','FolderFilter','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'FolderFilter'};
    }
    public class ArrayOfRecipient {
        public DocuSignAPI.Recipient[] Recipient;
        private String[] Recipient_type_info = new String[]{'Recipient','http://www.docusign.net/API/3.0','Recipient','0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'Recipient'};
    }
    public class FilteredEnvelopeStatusChanges {
        public Integer ResultSetSize;
        public DocuSignAPI.ArrayOfEnvelopeStatusChange EnvelopeStatusChanges;
        private String[] ResultSetSize_type_info = new String[]{'ResultSetSize','http://www.w3.org/2001/XMLSchema','int','1','1','false'};
        private String[] EnvelopeStatusChanges_type_info = new String[]{'EnvelopeStatusChanges','http://www.docusign.net/API/3.0','ArrayOfEnvelopeStatusChange','1','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'ResultSetSize','EnvelopeStatusChanges'};
    }
    public class AddressBookPhoneNumber {
        public String PhoneNumber;
        public String Designation;
        private String[] PhoneNumber_type_info = new String[]{'PhoneNumber','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Designation_type_info = new String[]{'Designation','http://www.docusign.net/API/3.0','PhoneNumberDesignation','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'PhoneNumber','Designation'};
    }
    public class MoveEnvelopesArg {
        public DocuSignAPI.ArrayOfString2 EnvelopeIds;
        public String AccountId;
        public DocuSignAPI.FolderTypeInfo FolderFrom;
        public DocuSignAPI.FolderTypeInfo FolderTo;
        private String[] EnvelopeIds_type_info = new String[]{'EnvelopeIds','http://www.docusign.net/API/3.0','ArrayOfString2','0','1','false'};
        private String[] AccountId_type_info = new String[]{'AccountId','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] FolderFrom_type_info = new String[]{'FolderFrom','http://www.docusign.net/API/3.0','FolderTypeInfo','0','1','false'};
        private String[] FolderTo_type_info = new String[]{'FolderTo','http://www.docusign.net/API/3.0','FolderTypeInfo','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'EnvelopeIds','AccountId','FolderFrom','FolderTo'};
    }
    public class ArrayOfFolder {
        public DocuSignAPI.Folder[] Folder;
        private String[] Folder_type_info = new String[]{'Folder','http://www.docusign.net/API/3.0','Folder','0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'Folder'};
    }
    public class EnvelopeAuditEventsResponse_element {
        public DocuSignAPI.EnvelopeAuditEventsResult_element EnvelopeAuditEventsResult;
        private String[] EnvelopeAuditEventsResult_type_info = new String[]{'EnvelopeAuditEventsResult','http://www.docusign.net/API/3.0','EnvelopeAuditEventsResult_element','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'EnvelopeAuditEventsResult'};
    }
    public class MatchBox {
        public Integer PageNumber;
        public Integer XPosition;
        public Integer YPosition;
        public Integer Width;
        public Integer Height;
        private String[] PageNumber_type_info = new String[]{'PageNumber','http://www.w3.org/2001/XMLSchema','positiveInteger','0','1','false'};
        private String[] XPosition_type_info = new String[]{'XPosition','http://www.w3.org/2001/XMLSchema','int','1','1','false'};
        private String[] YPosition_type_info = new String[]{'YPosition','http://www.w3.org/2001/XMLSchema','int','1','1','false'};
        private String[] Width_type_info = new String[]{'Width','http://www.w3.org/2001/XMLSchema','int','1','1','false'};
        private String[] Height_type_info = new String[]{'Height','http://www.w3.org/2001/XMLSchema','int','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'PageNumber','XPosition','YPosition','Width','Height'};
    }
    public class UserInfo {
        public String UserName;
        public String Email;
        private String[] UserName_type_info = new String[]{'UserName','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Email_type_info = new String[]{'Email','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'UserName','Email'};
    }
    public class VoidEnvelopeStatus {
        public Boolean VoidSuccess;
        private String[] VoidSuccess_type_info = new String[]{'VoidSuccess','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'VoidSuccess'};
    }
    public class RecipientSignatureInfo {
        public String SignatureName;
        public String SignatureInitials;
        public String FontStyle;
        private String[] SignatureName_type_info = new String[]{'SignatureName','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] SignatureInitials_type_info = new String[]{'SignatureInitials','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] FontStyle_type_info = new String[]{'FontStyle','http://www.docusign.net/API/3.0','FontStyleCode','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'SignatureName','SignatureInitials','FontStyle'};
    }
    public class ArrayOfTemplateReferenceFieldDataDataValue {
        public DocuSignAPI.TemplateReferenceFieldDataDataValue[] DataValue;
        private String[] DataValue_type_info = new String[]{'DataValue','http://www.docusign.net/API/3.0','TemplateReferenceFieldDataDataValue','0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'DataValue'};
    }
    public class SSN9Information {
        public String SSN9;
        private String[] SSN9_type_info = new String[]{'SSN9','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'SSN9'};
    }
    public class AvailableFolders {
        public DocuSignAPI.ArrayOfFolder Folders;
        private String[] Folders_type_info = new String[]{'Folders','http://www.docusign.net/API/3.0','ArrayOfFolder','1','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'Folders'};
    }
    public class FormDataXfdfField {
        public String value;
        public String name;
        private String[] value_type_info = new String[]{'value','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] name_att_info = new String[]{'name'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'value'};
    }
    public class TemplateReference {
        public String TemplateLocation;
        public String Template;
        public DocuSignAPI.Document Document;
        public DocuSignAPI.ArrayOfTemplateReferenceRoleAssignment RoleAssignments;
        public DocuSignAPI.TemplateReferenceFieldData FieldData;
        public DocuSignAPI.ArrayOfTab AdditionalTabs;
        public Integer Sequence;
        public DocuSignAPI.ArrayOfAttachment TemplateAttachments;
        private String[] TemplateLocation_type_info = new String[]{'TemplateLocation','http://www.docusign.net/API/3.0','TemplateLocationCode','0','1','false'};
        private String[] Template_type_info = new String[]{'Template','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Document_type_info = new String[]{'Document','http://www.docusign.net/API/3.0','Document','0','1','false'};
        private String[] RoleAssignments_type_info = new String[]{'RoleAssignments','http://www.docusign.net/API/3.0','ArrayOfTemplateReferenceRoleAssignment','0','1','false'};
        private String[] FieldData_type_info = new String[]{'FieldData','http://www.docusign.net/API/3.0','TemplateReferenceFieldData','0','1','false'};
        private String[] AdditionalTabs_type_info = new String[]{'AdditionalTabs','http://www.docusign.net/API/3.0','ArrayOfTab','0','1','false'};
        private String[] Sequence_type_info = new String[]{'Sequence','http://www.w3.org/2001/XMLSchema','positiveInteger','0','1','false'};
        private String[] TemplateAttachments_type_info = new String[]{'TemplateAttachments','http://www.docusign.net/API/3.0','ArrayOfAttachment','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'TemplateLocation','Template','Document','RoleAssignments','FieldData','AdditionalTabs','Sequence','TemplateAttachments'};
    }
    public class CreateEnvelopeFromTemplates_element {
        public DocuSignAPI.ArrayOfTemplateReference TemplateReferences;
        public DocuSignAPI.ArrayOfRecipient1 Recipients;
        public DocuSignAPI.EnvelopeInformation EnvelopeInformation;
        public Boolean ActivateEnvelope;
        private String[] TemplateReferences_type_info = new String[]{'TemplateReferences','http://www.docusign.net/API/3.0','ArrayOfTemplateReference','0','1','false'};
        private String[] Recipients_type_info = new String[]{'Recipients','http://www.docusign.net/API/3.0','ArrayOfRecipient1','0','1','false'};
        private String[] EnvelopeInformation_type_info = new String[]{'EnvelopeInformation','http://www.docusign.net/API/3.0','EnvelopeInformation','0','1','false'};
        private String[] ActivateEnvelope_type_info = new String[]{'ActivateEnvelope','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'TemplateReferences','Recipients','EnvelopeInformation','ActivateEnvelope'};
    }
    public class ArrayOfAttachment {
        public DocuSignAPI.Attachment[] Attachment;
        private String[] Attachment_type_info = new String[]{'Attachment','http://www.docusign.net/API/3.0','Attachment','0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'Attachment'};
    }
    public class GetRecipientListResponse_element {
        public DocuSignAPI.RecipientList GetRecipientListResult;
        private String[] GetRecipientListResult_type_info = new String[]{'GetRecipientListResult','http://www.docusign.net/API/3.0','RecipientList','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'GetRecipientListResult'};
    }
    public class GetRecipientList_element {
        public String SenderAccountId;
        public String RecipientEmail;
        private String[] SenderAccountId_type_info = new String[]{'SenderAccountId','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] RecipientEmail_type_info = new String[]{'RecipientEmail','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'SenderAccountId','RecipientEmail'};
    }
    public class DeleteEnvelopes_element {
        public DocuSignAPI.DeleteEnvelopesArg Arg;
        private String[] Arg_type_info = new String[]{'Arg','http://www.docusign.net/API/3.0','DeleteEnvelopesArg','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'Arg'};
    }
    public class ArrayOfDocumentPDF {
        public DocuSignAPI.DocumentPDF[] DocumentPDF;
        private String[] DocumentPDF_type_info = new String[]{'DocumentPDF','http://www.docusign.net/API/3.0','DocumentPDF','0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'DocumentPDF'};
    }
    public class MoveEnvelopesResponse_element {
        public Boolean MoveEnvelopesResult;
        private String[] MoveEnvelopesResult_type_info = new String[]{'MoveEnvelopesResult','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'MoveEnvelopesResult'};
    }
    public class CreateEnvelopeFromTemplatesAndFormsResponse_element {
        public DocuSignAPI.EnvelopeStatus CreateEnvelopeFromTemplatesAndFormsResult;
        private String[] CreateEnvelopeFromTemplatesAndFormsResult_type_info = new String[]{'CreateEnvelopeFromTemplatesAndFormsResult','http://www.docusign.net/API/3.0','EnvelopeStatus','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'CreateEnvelopeFromTemplatesAndFormsResult'};
    }
    public class BrandDefinitions {
        public String BrandDefinitionsFileBytes;
        private String[] BrandDefinitionsFileBytes_type_info = new String[]{'BrandDefinitionsFileBytes','http://www.w3.org/2001/XMLSchema','base64Binary','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'BrandDefinitionsFileBytes'};
    }
    public class InlineTemplate {
        public Integer Sequence;
        public DocuSignAPI.Envelope Envelope;
        private String[] Sequence_type_info = new String[]{'Sequence','http://www.w3.org/2001/XMLSchema','positiveInteger','0','1','false'};
        private String[] Envelope_type_info = new String[]{'Envelope','http://www.docusign.net/API/3.0','Envelope','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'Sequence','Envelope'};
    }
    public class EnvelopeAuditEventsResult_element {
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class UploadTemplateResponse_element {
        public DocuSignAPI.SaveTemplateResult UploadTemplateResult;
        private String[] UploadTemplateResult_type_info = new String[]{'UploadTemplateResult','http://www.docusign.net/API/3.0','SaveTemplateResult','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'UploadTemplateResult'};
    }
    public class PublishConnectFailuresResult {
        public String EnvelopeId;
        public String ConfigId;
        public String ConfigUrl;
        public String Status;
        public String StatusMessage;
        private String[] EnvelopeId_type_info = new String[]{'EnvelopeId','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] ConfigId_type_info = new String[]{'ConfigId','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] ConfigUrl_type_info = new String[]{'ConfigUrl','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Status_type_info = new String[]{'Status','http://www.docusign.net/API/3.0','ConnectPublishStatus','1','1','false'};
        private String[] StatusMessage_type_info = new String[]{'StatusMessage','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'EnvelopeId','ConfigId','ConfigUrl','Status','StatusMessage'};
    }
    public class DeleteAccountBrandsResponse_element {
        public DocuSignAPI.BrandResults DeleteAccountBrandsResult;
        private String[] DeleteAccountBrandsResult_type_info = new String[]{'DeleteAccountBrandsResult','http://www.docusign.net/API/3.0','BrandResults','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'DeleteAccountBrandsResult'};
    }
    public class EnvelopeStatusChangeFilter {
        public String AccountId;
        public DocuSignAPI.UserInfo UserInfo;
        public DateTime StatusChangedSince;
        public DocuSignAPI.ArrayOfEnvelopeStatusCode Statuses;
        private String[] AccountId_type_info = new String[]{'AccountId','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] UserInfo_type_info = new String[]{'UserInfo','http://www.docusign.net/API/3.0','UserInfo','0','1','false'};
        private String[] StatusChangedSince_type_info = new String[]{'StatusChangedSince','http://www.w3.org/2001/XMLSchema','dateTime','1','1','false'};
        private String[] Statuses_type_info = new String[]{'Statuses','http://www.docusign.net/API/3.0','ArrayOfEnvelopeStatusCode','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'AccountId','UserInfo','StatusChangedSince','Statuses'};
    }
    public class CustomField {
        public String Name;
        public String Show;
        public String Required;
        public String Value;
        public String CustomFieldType;
        public String ListItems;
        private String[] Name_type_info = new String[]{'Name','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Show_type_info = new String[]{'Show','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Required_type_info = new String[]{'Required','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Value_type_info = new String[]{'Value','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] CustomFieldType_type_info = new String[]{'CustomFieldType','http://www.docusign.net/API/3.0','CustomFieldType','0','1','false'};
        private String[] ListItems_type_info = new String[]{'ListItems','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'Name','Show','Required','Value','CustomFieldType','ListItems'};
    }
    public class SaveTemplateResponse_element {
        public DocuSignAPI.SaveTemplateResult SaveTemplateResult;
        private String[] SaveTemplateResult_type_info = new String[]{'SaveTemplateResult','http://www.docusign.net/API/3.0','SaveTemplateResult','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'SaveTemplateResult'};
    }
    public class ArrayOfTemplateReferenceRoleAssignment {
        public DocuSignAPI.TemplateReferenceRoleAssignment[] RoleAssignment;
        private String[] RoleAssignment_type_info = new String[]{'RoleAssignment','http://www.docusign.net/API/3.0','TemplateReferenceRoleAssignment','0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'RoleAssignment'};
    }
    public class ArrayOfBrandRequestItem {
        public DocuSignAPI.BrandRequestItem[] BrandRequestItem;
        private String[] BrandRequestItem_type_info = new String[]{'BrandRequestItem','http://www.docusign.net/API/3.0','BrandRequestItem','0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'BrandRequestItem'};
    }
    public class ArrayOfTabStatus {
        public DocuSignAPI.TabStatus[] TabStatus;
        private String[] TabStatus_type_info = new String[]{'TabStatus','http://www.docusign.net/API/3.0','TabStatus','0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'TabStatus'};
    }
    public class TransferEnvelope_element {
        public String EnvelopeID;
        public String AccountID;
        public String UserID;
        private String[] EnvelopeID_type_info = new String[]{'EnvelopeID','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] AccountID_type_info = new String[]{'AccountID','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] UserID_type_info = new String[]{'UserID','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'EnvelopeID','AccountID','UserID'};
    }
    public class PurgeDocuments_element {
        public String EnvelopeID;
        private String[] EnvelopeID_type_info = new String[]{'EnvelopeID','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'EnvelopeID'};
    }
    public class RequestTemplates_element {
        public String AccountID;
        public Boolean IncludeAdvancedTemplates;
        private String[] AccountID_type_info = new String[]{'AccountID','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] IncludeAdvancedTemplates_type_info = new String[]{'IncludeAdvancedTemplates','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'AccountID','IncludeAdvancedTemplates'};
    }
    public class GetAddressBookItemsResponse_element {
        public DocuSignAPI.ArrayOfAddressBookItem GetAddressBookItemsResult;
        private String[] GetAddressBookItemsResult_type_info = new String[]{'GetAddressBookItemsResult','http://www.docusign.net/API/3.0','ArrayOfAddressBookItem','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'GetAddressBookItemsResult'};
    }
    public class AccountSetting {
        public String Name;
        public String Value;
        public String Type_x;
        public String TestSetting;
        private String[] Name_type_info = new String[]{'Name','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Value_type_info = new String[]{'Value','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Type_x_type_info = new String[]{'Type','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] TestSetting_type_info = new String[]{'TestSetting','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'Name','Value','Type_x','TestSetting'};
    }
    public class AddressInformationInput {
        public DocuSignAPI.AddressInformation AddressInformation;
        public String DisplayLevel;
        public Boolean ReceiveInResponse;
        private String[] AddressInformation_type_info = new String[]{'AddressInformation','http://www.docusign.net/API/3.0','AddressInformation','0','1','false'};
        private String[] DisplayLevel_type_info = new String[]{'DisplayLevel','http://www.docusign.net/API/3.0','DisplayLevelCode','0','1','false'};
        private String[] ReceiveInResponse_type_info = new String[]{'ReceiveInResponse','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'AddressInformation','DisplayLevel','ReceiveInResponse'};
    }
    public class TemplateReferenceRoleAssignment {
        public String RoleName;
        public Integer RecipientID;
        private String[] RoleName_type_info = new String[]{'RoleName','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] RecipientID_type_info = new String[]{'RecipientID','http://www.w3.org/2001/XMLSchema','positiveInteger','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'RoleName','RecipientID'};
    }
    public class AccountMembershipFeaturesList {
        public String Email;
        public String UserName;
        public DocuSignAPI.ArrayOfString4 EnabledFeaturesSet;
        private String[] Email_type_info = new String[]{'Email','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] UserName_type_info = new String[]{'UserName','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] EnabledFeaturesSet_type_info = new String[]{'EnabledFeaturesSet','http://www.docusign.net/API/3.0','ArrayOfString4','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'Email','UserName','EnabledFeaturesSet'};
    }
    public class ArrayOfEnvelopeEvent {
        public DocuSignAPI.EnvelopeEvent[] EnvelopeEvent;
        private String[] EnvelopeEvent_type_info = new String[]{'EnvelopeEvent','http://www.docusign.net/API/3.0','EnvelopeEvent','0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'EnvelopeEvent'};
    }
    public class AccountSettingsList {
        public DocuSignAPI.AccountSetting[] AccountSetting;
        private String[] AccountSetting_type_info = new String[]{'AccountSetting','http://www.docusign.net/API/3.0','AccountSetting','0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'AccountSetting'};
    }
    public class PublishConnectFailuresFilter {
        public String AccountId;
        public Boolean Synchronous;
        public DocuSignAPI.ArrayOfString2 EnvelopeIds;
        private String[] AccountId_type_info = new String[]{'AccountId','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Synchronous_type_info = new String[]{'Synchronous','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] EnvelopeIds_type_info = new String[]{'EnvelopeIds','http://www.docusign.net/API/3.0','ArrayOfString2','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'AccountId','Synchronous','EnvelopeIds'};
    }
    public class TransferEnvelopeResponse_element {
        public DocuSignAPI.TransferEnvelopeStatus TransferEnvelopeResult;
        private String[] TransferEnvelopeResult_type_info = new String[]{'TransferEnvelopeResult','http://www.docusign.net/API/3.0','TransferEnvelopeStatus','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'TransferEnvelopeResult'};
    }
    public class SendEnvelopeResponse_element {
        public DocuSignAPI.EnvelopeStatus SendEnvelopeResult;
        private String[] SendEnvelopeResult_type_info = new String[]{'SendEnvelopeResult','http://www.docusign.net/API/3.0','EnvelopeStatus','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'SendEnvelopeResult'};
    }
    public class SSN4InformationInput {
        public DocuSignAPI.SSN4Information SSN4Information;
        public String DisplayLevel;
        public Boolean ReceiveInResponse;
        private String[] SSN4Information_type_info = new String[]{'SSN4Information','http://www.docusign.net/API/3.0','SSN4Information','0','1','false'};
        private String[] DisplayLevel_type_info = new String[]{'DisplayLevel','http://www.docusign.net/API/3.0','DisplayLevelCode','0','1','false'};
        private String[] ReceiveInResponse_type_info = new String[]{'ReceiveInResponse','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'SSN4Information','DisplayLevel','ReceiveInResponse'};
    }
    public class RequestTemplateResponse_element {
        public DocuSignAPI.EnvelopeTemplate RequestTemplateResult;
        private String[] RequestTemplateResult_type_info = new String[]{'RequestTemplateResult','http://www.docusign.net/API/3.0','EnvelopeTemplate','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'RequestTemplateResult'};
    }
    public class RequestStatus_element {
        public String EnvelopeID;
        private String[] EnvelopeID_type_info = new String[]{'EnvelopeID','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'EnvelopeID'};
    }
    public class ArrayOfServerTemplate {
        public DocuSignAPI.ServerTemplate[] ServerTemplate;
        private String[] ServerTemplate_type_info = new String[]{'ServerTemplate','http://www.docusign.net/API/3.0','ServerTemplate','0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'ServerTemplate'};
    }
    public class UploadTemplate_element {
        public String TemplateXML;
        public String AccountID;
        public Boolean Shared;
        private String[] TemplateXML_type_info = new String[]{'TemplateXML','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] AccountID_type_info = new String[]{'AccountID','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Shared_type_info = new String[]{'Shared','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'TemplateXML','AccountID','Shared'};
    }
    public class ConnectFailuresFilter {
        public String AccountId;
        public DateTime DateFrom;
        public DateTime DateTo;
        private String[] AccountId_type_info = new String[]{'AccountId','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] DateFrom_type_info = new String[]{'DateFrom','http://www.w3.org/2001/XMLSchema','dateTime','0','1','false'};
        private String[] DateTo_type_info = new String[]{'DateTo','http://www.w3.org/2001/XMLSchema','dateTime','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'AccountId','DateFrom','DateTo'};
    }
    public class RequestDocumentPDFsResponse_element {
        public DocuSignAPI.DocumentPDFs RequestDocumentPDFsResult;
        private String[] RequestDocumentPDFsResult_type_info = new String[]{'RequestDocumentPDFsResult','http://www.docusign.net/API/3.0','DocumentPDFs','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'RequestDocumentPDFsResult'};
    }
    public class EnvelopePDF {
        public String EnvelopeID;
        public String PDFBytes;
        private String[] EnvelopeID_type_info = new String[]{'EnvelopeID','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] PDFBytes_type_info = new String[]{'PDFBytes','http://www.w3.org/2001/XMLSchema','base64Binary','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'EnvelopeID','PDFBytes'};
    }
    public class RequestPDFNoWaterMarkResponse_element {
        public DocuSignAPI.EnvelopePDF RequestPDFNoWaterMarkResult;
        private String[] RequestPDFNoWaterMarkResult_type_info = new String[]{'RequestPDFNoWaterMarkResult','http://www.docusign.net/API/3.0','EnvelopePDF','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'RequestPDFNoWaterMarkResult'};
    }
    public class FormData {
        public DocuSignAPI.FormDataXfdf xfdf;
        private String[] xfdf_type_info = new String[]{'xfdf','http://www.docusign.net/API/3.0','FormDataXfdf','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'xfdf'};
    }
    public class RequestPDF_element {
        public String EnvelopeID;
        private String[] EnvelopeID_type_info = new String[]{'EnvelopeID','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'EnvelopeID'};
    }
    public class ArrayOfAddressBookItem1 {
        public DocuSignAPI.AddressBookItem[] AddressBookItem;
        private String[] AddressBookItem_type_info = new String[]{'AddressBookItem','http://www.docusign.net/API/3.0','AddressBookItem','0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'AddressBookItem'};
    }
    public class TabStatus {
        public String TabType;
        public String Status;
        public Double XPosition;
        public Double YPosition;
        public DateTime Signed;
        public String TabLabel;
        public String TabName;
        public String TabValue;
        public Integer DocumentID;
        public Integer PageNumber;
        public String OriginalValue;
        public String ValidationPattern;
        public String RoleName;
        public String ListValues;
        public String ListSelectedValue;
        public Decimal ScaleValue;
        public String CustomTabType;
        private String[] TabType_type_info = new String[]{'TabType','http://www.docusign.net/API/3.0','TabTypeCode','1','1','false'};
        private String[] Status_type_info = new String[]{'Status','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] XPosition_type_info = new String[]{'XPosition','http://www.w3.org/2001/XMLSchema','double','1','1','false'};
        private String[] YPosition_type_info = new String[]{'YPosition','http://www.w3.org/2001/XMLSchema','double','1','1','false'};
        private String[] Signed_type_info = new String[]{'Signed','http://www.w3.org/2001/XMLSchema','dateTime','0','1','false'};
        private String[] TabLabel_type_info = new String[]{'TabLabel','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] TabName_type_info = new String[]{'TabName','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] TabValue_type_info = new String[]{'TabValue','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] DocumentID_type_info = new String[]{'DocumentID','http://www.w3.org/2001/XMLSchema','positiveInteger','0','1','false'};
        private String[] PageNumber_type_info = new String[]{'PageNumber','http://www.w3.org/2001/XMLSchema','nonNegativeInteger','0','1','false'};
        private String[] OriginalValue_type_info = new String[]{'OriginalValue','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] ValidationPattern_type_info = new String[]{'ValidationPattern','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] RoleName_type_info = new String[]{'RoleName','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] ListValues_type_info = new String[]{'ListValues','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] ListSelectedValue_type_info = new String[]{'ListSelectedValue','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] ScaleValue_type_info = new String[]{'ScaleValue','http://www.w3.org/2001/XMLSchema','decimal','0','1','false'};
        private String[] CustomTabType_type_info = new String[]{'CustomTabType','http://www.docusign.net/API/3.0','CustomTabType','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'TabType','Status','XPosition','YPosition','Signed','TabLabel','TabName','TabValue','DocumentID','PageNumber','OriginalValue','ValidationPattern','RoleName','ListValues','ListSelectedValue','ScaleValue','CustomTabType'};
    }
    public class FilteredEnvelopeStatuses {
        public Integer ResultSetSize;
        public DocuSignAPI.EnvelopeStatusFilter EnvelopeStatusFilter;
        public DocuSignAPI.ArrayOfEnvelopeStatus EnvelopeStatuses;
        private String[] ResultSetSize_type_info = new String[]{'ResultSetSize','http://www.w3.org/2001/XMLSchema','int','1','1','false'};
        private String[] EnvelopeStatusFilter_type_info = new String[]{'EnvelopeStatusFilter','http://www.docusign.net/API/3.0','EnvelopeStatusFilter','0','1','false'};
        private String[] EnvelopeStatuses_type_info = new String[]{'EnvelopeStatuses','http://www.docusign.net/API/3.0','ArrayOfEnvelopeStatus','1','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'ResultSetSize','EnvelopeStatusFilter','EnvelopeStatuses'};
    }
    public class FoldersFilter {
        public String AccountId;
        public Boolean IncludeHierarchy;
        private String[] AccountId_type_info = new String[]{'AccountId','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] IncludeHierarchy_type_info = new String[]{'IncludeHierarchy','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'AccountId','IncludeHierarchy'};
    }
    public class RequestCertificate_element {
        public String EnvelopeID;
        private String[] EnvelopeID_type_info = new String[]{'EnvelopeID','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'EnvelopeID'};
    }
    public class EnvelopeEvent {
        public String EnvelopeEventStatusCode;
        public Boolean IncludeDocuments;
        private String[] EnvelopeEventStatusCode_type_info = new String[]{'EnvelopeEventStatusCode','http://www.docusign.net/API/3.0','EnvelopeEventStatusCode','1','1','false'};
        private String[] IncludeDocuments_type_info = new String[]{'IncludeDocuments','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'EnvelopeEventStatusCode','IncludeDocuments'};
    }
    public class SaveTemplateResult {
        public Boolean Success;
        public String TemplateID;
        public String Name;
        private String[] Success_type_info = new String[]{'Success','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] TemplateID_type_info = new String[]{'TemplateID','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Name_type_info = new String[]{'Name','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'Success','TemplateID','Name'};
    }
    public class PDFMetaDataTemplate {
        public Integer Sequence;
        private String[] Sequence_type_info = new String[]{'Sequence','http://www.w3.org/2001/XMLSchema','positiveInteger','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'Sequence'};
    }
    public class RequestPDFResponse_element {
        public DocuSignAPI.EnvelopePDF RequestPDFResult;
        private String[] RequestPDFResult_type_info = new String[]{'RequestPDFResult','http://www.docusign.net/API/3.0','EnvelopePDF','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'RequestPDFResult'};
    }
    public class FolderFilter {
        public String AccountId;
        public DocuSignAPI.UserInfo FolderOwner;
        public DocuSignAPI.FolderTypeInfo FolderTypeInfo;
        public Integer StartPosition;
        public DateTime FromDate;
        public DateTime ToDate;
        public String SearchText;
        public String Status;
        private String[] AccountId_type_info = new String[]{'AccountId','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] FolderOwner_type_info = new String[]{'FolderOwner','http://www.docusign.net/API/3.0','UserInfo','0','1','false'};
        private String[] FolderTypeInfo_type_info = new String[]{'FolderTypeInfo','http://www.docusign.net/API/3.0','FolderTypeInfo','0','1','false'};
        private String[] StartPosition_type_info = new String[]{'StartPosition','http://www.w3.org/2001/XMLSchema','int','0','1','false'};
        private String[] FromDate_type_info = new String[]{'FromDate','http://www.w3.org/2001/XMLSchema','dateTime','0','1','false'};
        private String[] ToDate_type_info = new String[]{'ToDate','http://www.w3.org/2001/XMLSchema','dateTime','0','1','false'};
        private String[] SearchText_type_info = new String[]{'SearchText','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Status_type_info = new String[]{'Status','http://www.docusign.net/API/3.0','EnvelopeStatusCode','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'AccountId','FolderOwner','FolderTypeInfo','StartPosition','FromDate','ToDate','SearchText','Status'};
    }
    public class CreateAndSendEnvelopeResponse_element {
        public DocuSignAPI.EnvelopeStatus CreateAndSendEnvelopeResult;
        private String[] CreateAndSendEnvelopeResult_type_info = new String[]{'CreateAndSendEnvelopeResult','http://www.docusign.net/API/3.0','EnvelopeStatus','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'CreateAndSendEnvelopeResult'};
    }
    public class GetAccountMembershipFeaturesList_element {
        public String AccountId;
        private String[] AccountId_type_info = new String[]{'AccountId','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'AccountId'};
    }
    public class GetAddressBookItems_element {
        public String AccountID;
        private String[] AccountID_type_info = new String[]{'AccountID','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'AccountID'};
    }
    public class ArrayOfPositiveInteger {
        public Integer[] DocumentID;
        private String[] DocumentID_type_info = new String[]{'DocumentID','http://www.w3.org/2001/XMLSchema','positiveInteger','0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'DocumentID'};
    }
    public class RequestStatusCodesResponse_element {
        public DocuSignAPI.FilteredEnvelopeStatusChanges RequestStatusCodesResult;
        private String[] RequestStatusCodesResult_type_info = new String[]{'RequestStatusCodesResult','http://www.docusign.net/API/3.0','FilteredEnvelopeStatusChanges','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'RequestStatusCodesResult'};
    }
    public class ArrayOfTemplateReference {
        public DocuSignAPI.TemplateReference[] TemplateReference;
        private String[] TemplateReference_type_info = new String[]{'TemplateReference','http://www.docusign.net/API/3.0','TemplateReference','0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'TemplateReference'};
    }
    public class Attachment {
        public String Data;
        public String Label;
        public String Type_x;
        private String[] Data_type_info = new String[]{'Data','http://www.w3.org/2001/XMLSchema','base64Binary','0','1','false'};
        private String[] Label_type_info = new String[]{'Label','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Type_x_type_info = new String[]{'Type','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'Data','Label','Type_x'};
    }
    public class RequestPDFWithCert_element {
        public String EnvelopeID;
        public Boolean AddWaterMark;
        private String[] EnvelopeID_type_info = new String[]{'EnvelopeID','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] AddWaterMark_type_info = new String[]{'AddWaterMark','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'EnvelopeID','AddWaterMark'};
    }
    public class UpdateAddressBookResult {
        public Boolean Success;
        public DocuSignAPI.ArrayOfAddressBookItem1 AddressBookItems;
        private String[] Success_type_info = new String[]{'Success','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] AddressBookItems_type_info = new String[]{'AddressBookItems','http://www.docusign.net/API/3.0','ArrayOfAddressBookItem1','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'Success','AddressBookItems'};
    }
    public class SSN9InformationInput {
        public DocuSignAPI.SSN9Information SSN9Information;
        public String DisplayLevel;
        private String[] SSN9Information_type_info = new String[]{'SSN9Information','http://www.docusign.net/API/3.0','SSN9Information','0','1','false'};
        private String[] DisplayLevel_type_info = new String[]{'DisplayLevel','http://www.docusign.net/API/3.0','DisplayLevelCode','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'SSN9Information','DisplayLevel'};
    }
    public class RequestEnvelopeResponse_element {
        public DocuSignAPI.Envelope RequestEnvelopeResult;
        private String[] RequestEnvelopeResult_type_info = new String[]{'RequestEnvelopeResult','http://www.docusign.net/API/3.0','Envelope','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'RequestEnvelopeResult'};
    }
    public class TemplateReferenceFieldDataDataValue {
        public String TabLabel;
        public String Value;
        private String[] TabLabel_type_info = new String[]{'TabLabel','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Value_type_info = new String[]{'Value','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'TabLabel','Value'};
    }
    public class MoveEnvelopes_element {
        public DocuSignAPI.MoveEnvelopesArg Arg;
        private String[] Arg_type_info = new String[]{'Arg','http://www.docusign.net/API/3.0','MoveEnvelopesArg','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'Arg'};
    }
    public class AddressBookRemoveItem {
        public String AddressBookID;
        private String[] AddressBookID_type_info = new String[]{'AddressBookID','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'AddressBookID'};
    }
    public class RecipientPhoneAuthentication {
        public Boolean RecipMayProvideNumber;
        public Boolean ValidateRecipProvidedNumber;
        public Boolean RecordVoicePrint;
        public DocuSignAPI.ArrayOfString SenderProvidedNumbers;
        private String[] RecipMayProvideNumber_type_info = new String[]{'RecipMayProvideNumber','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] ValidateRecipProvidedNumber_type_info = new String[]{'ValidateRecipProvidedNumber','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] RecordVoicePrint_type_info = new String[]{'RecordVoicePrint','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] SenderProvidedNumbers_type_info = new String[]{'SenderProvidedNumbers','http://www.docusign.net/API/3.0','ArrayOfString','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'RecipMayProvideNumber','ValidateRecipProvidedNumber','RecordVoicePrint','SenderProvidedNumbers'};
    }
    public class RequestEnvelope_element {
        public String EnvelopeID;
        public Boolean IncludeDocumentBytes;
        private String[] EnvelopeID_type_info = new String[]{'EnvelopeID','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] IncludeDocumentBytes_type_info = new String[]{'IncludeDocumentBytes','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'EnvelopeID','IncludeDocumentBytes'};
    }
    public class AddressBookItem {
        public String AddressBookID;
        public String Email;
        public String UserName;
        public String AccountName;
        public Boolean Shared;
        public DateTime Created;
        public Boolean Owner;
        public DocuSignAPI.AddressBookPhoneNumber Phone1;
        public DocuSignAPI.AddressBookPhoneNumber Phone2;
        public DocuSignAPI.AddressBookPhoneNumber Phone3;
        public DocuSignAPI.AddressBookPhoneNumber Phone4;
        private String[] AddressBookID_type_info = new String[]{'AddressBookID','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Email_type_info = new String[]{'Email','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] UserName_type_info = new String[]{'UserName','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] AccountName_type_info = new String[]{'AccountName','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Shared_type_info = new String[]{'Shared','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] Created_type_info = new String[]{'Created','http://www.w3.org/2001/XMLSchema','dateTime','0','1','false'};
        private String[] Owner_type_info = new String[]{'Owner','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] Phone1_type_info = new String[]{'Phone1','http://www.docusign.net/API/3.0','AddressBookPhoneNumber','0','1','false'};
        private String[] Phone2_type_info = new String[]{'Phone2','http://www.docusign.net/API/3.0','AddressBookPhoneNumber','0','1','false'};
        private String[] Phone3_type_info = new String[]{'Phone3','http://www.docusign.net/API/3.0','AddressBookPhoneNumber','0','1','false'};
        private String[] Phone4_type_info = new String[]{'Phone4','http://www.docusign.net/API/3.0','AddressBookPhoneNumber','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'AddressBookID','Email','UserName','AccountName','Shared','Created','Owner','Phone1','Phone2','Phone3','Phone4'};
    }
    public class SaveTemplate_element {
        public DocuSignAPI.EnvelopeTemplate EnvelopeTemplate;
        private String[] EnvelopeTemplate_type_info = new String[]{'EnvelopeTemplate','http://www.docusign.net/API/3.0','EnvelopeTemplate','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'EnvelopeTemplate'};
    }
    public class RecipientStatusEsignAgreementInformation {
        public String AccountEsignId;
        public String UserEsignId;
        public DateTime AgreementDate;
        private String[] AccountEsignId_type_info = new String[]{'AccountEsignId','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] UserEsignId_type_info = new String[]{'UserEsignId','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] AgreementDate_type_info = new String[]{'AgreementDate','http://www.w3.org/2001/XMLSchema','dateTime','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'AccountEsignId','UserEsignId','AgreementDate'};
    }
    public class GetConnectFailuresResponse_element {
        public DocuSignAPI.ArrayOfConnectFailure GetConnectFailuresResult;
        private String[] GetConnectFailuresResult_type_info = new String[]{'GetConnectFailuresResult','http://www.docusign.net/API/3.0','ArrayOfConnectFailure','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'GetConnectFailuresResult'};
    }
    public class CompositeTemplate {
        public DocuSignAPI.ArrayOfServerTemplate ServerTemplates;
        public DocuSignAPI.ArrayOfInlineTemplate InlineTemplates;
        public DocuSignAPI.PDFMetaDataTemplate PDFMetaDataTemplate;
        public DocuSignAPI.Document Document;
        private String[] ServerTemplates_type_info = new String[]{'ServerTemplates','http://www.docusign.net/API/3.0','ArrayOfServerTemplate','0','1','false'};
        private String[] InlineTemplates_type_info = new String[]{'InlineTemplates','http://www.docusign.net/API/3.0','ArrayOfInlineTemplate','0','1','false'};
        private String[] PDFMetaDataTemplate_type_info = new String[]{'PDFMetaDataTemplate','http://www.docusign.net/API/3.0','PDFMetaDataTemplate','0','1','false'};
        private String[] Document_type_info = new String[]{'Document','http://www.docusign.net/API/3.0','Document','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'ServerTemplates','InlineTemplates','PDFMetaDataTemplate','Document'};
    }
    public class FolderResults {
        public Integer ResultSetSize;
        public Integer StartPosition;
        public Integer EndPosition;
        public DocuSignAPI.FolderTypeInfo FolderTypeInfo;
        public DocuSignAPI.ArrayOfFolderItem FolderItems;
        private String[] ResultSetSize_type_info = new String[]{'ResultSetSize','http://www.w3.org/2001/XMLSchema','int','1','1','false'};
        private String[] StartPosition_type_info = new String[]{'StartPosition','http://www.w3.org/2001/XMLSchema','int','1','1','false'};
        private String[] EndPosition_type_info = new String[]{'EndPosition','http://www.w3.org/2001/XMLSchema','int','1','1','false'};
        private String[] FolderTypeInfo_type_info = new String[]{'FolderTypeInfo','http://www.docusign.net/API/3.0','FolderTypeInfo','0','1','false'};
        private String[] FolderItems_type_info = new String[]{'FolderItems','http://www.docusign.net/API/3.0','ArrayOfFolderItem','1','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'ResultSetSize','StartPosition','EndPosition','FolderTypeInfo','FolderItems'};
    }
    public class PurgeDocumentsResponse_element {
        public DocuSignAPI.PurgeDocumentStatus PurgeDocumentsResult;
        private String[] PurgeDocumentsResult_type_info = new String[]{'PurgeDocumentsResult','http://www.docusign.net/API/3.0','PurgeDocumentStatus','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'PurgeDocumentsResult'};
    }
    public class EnvelopeSettings {
        public Boolean AutoNavigation;
        public Boolean EnvelopeIdStamping;
        private String[] AutoNavigation_type_info = new String[]{'AutoNavigation','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] EnvelopeIdStamping_type_info = new String[]{'EnvelopeIdStamping','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'AutoNavigation','EnvelopeIdStamping'};
    }
    public class DOBInformationInput {
        public DocuSignAPI.DOBInformation DOBInformation;
        public String DisplayLevel;
        public Boolean ReceiveInResponse;
        private String[] DOBInformation_type_info = new String[]{'DOBInformation','http://www.docusign.net/API/3.0','DOBInformation','0','1','false'};
        private String[] DisplayLevel_type_info = new String[]{'DisplayLevel','http://www.docusign.net/API/3.0','DisplayLevelCode','0','1','false'};
        private String[] ReceiveInResponse_type_info = new String[]{'ReceiveInResponse','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'DOBInformation','DisplayLevel','ReceiveInResponse'};
    }
    public class RequestStatusesEx_element {
        public DocuSignAPI.EnvelopeStatusFilter EnvelopeStatusFilter;
        private String[] EnvelopeStatusFilter_type_info = new String[]{'EnvelopeStatusFilter','http://www.docusign.net/API/3.0','EnvelopeStatusFilter','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'EnvelopeStatusFilter'};
    }
    public class RequestDocumentPDFs_element {
        public String EnvelopeID;
        private String[] EnvelopeID_type_info = new String[]{'EnvelopeID','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'EnvelopeID'};
    }
    public class DocumentPDF {
        public String Name;
        public String PDFBytes;
        public Integer DocumentID;
        public String DocumentType;
        private String[] Name_type_info = new String[]{'Name','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] PDFBytes_type_info = new String[]{'PDFBytes','http://www.w3.org/2001/XMLSchema','base64Binary','0','1','false'};
        private String[] DocumentID_type_info = new String[]{'DocumentID','http://www.w3.org/2001/XMLSchema','positiveInteger','0','1','false'};
        private String[] DocumentType_type_info = new String[]{'DocumentType','http://www.docusign.net/API/3.0','DocumentType','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'Name','PDFBytes','DocumentID','DocumentType'};
    }
    public class RequestDocumentPDFsExResponse_element {
        public DocuSignAPI.DocumentPDFs RequestDocumentPDFsExResult;
        private String[] RequestDocumentPDFsExResult_type_info = new String[]{'RequestDocumentPDFsExResult','http://www.docusign.net/API/3.0','DocumentPDFs','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'RequestDocumentPDFsExResult'};
    }
    public class ArrayOfEnvelopeTemplate {
        public DocuSignAPI.EnvelopeTemplate[] EnvelopeTemplate;
        private String[] EnvelopeTemplate_type_info = new String[]{'EnvelopeTemplate','http://www.docusign.net/API/3.0','EnvelopeTemplate','0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'EnvelopeTemplate'};
    }
    public class DocumentPDFs {
        public String EnvelopeId;
        public DocuSignAPI.DocumentPDF[] DocumentPDF;
        private String[] EnvelopeId_type_info = new String[]{'EnvelopeId','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] DocumentPDF_type_info = new String[]{'DocumentPDF','http://www.docusign.net/API/3.0','DocumentPDF','0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'EnvelopeId','DocumentPDF'};
    }
    public class SynchEnvelope_element {
        public String TransactionID;
        public String AccountID;
        public Boolean Block;
        private String[] TransactionID_type_info = new String[]{'TransactionID','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] AccountID_type_info = new String[]{'AccountID','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Block_type_info = new String[]{'Block','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'TransactionID','AccountID','Block'};
    }
    public class EnvelopeAuditEvents_element {
        public String EnvelopeId;
        private String[] EnvelopeId_type_info = new String[]{'EnvelopeId','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'EnvelopeId'};
    }
    public class TemplateReferenceFieldData {
        public DocuSignAPI.ArrayOfTemplateReferenceFieldDataDataValue DataValues;
        private String[] DataValues_type_info = new String[]{'DataValues','http://www.docusign.net/API/3.0','ArrayOfTemplateReferenceFieldDataDataValue','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'DataValues'};
    }
    public class FormDataXfdf {
        public DocuSignAPI.ArrayOfFormDataXfdfField fields;
        private String[] fields_type_info = new String[]{'fields','http://www.docusign.net/API/3.0','ArrayOfFormDataXfdfField','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'fields'};
    }
    public class Notification {
        public Boolean UseAccountDefaults;
        public DocuSignAPI.Reminders Reminders;
        public DocuSignAPI.Expirations Expirations;
        private String[] UseAccountDefaults_type_info = new String[]{'UseAccountDefaults','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] Reminders_type_info = new String[]{'Reminders','http://www.docusign.net/API/3.0','Reminders','0','1','false'};
        private String[] Expirations_type_info = new String[]{'Expirations','http://www.docusign.net/API/3.0','Expirations','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'UseAccountDefaults','Reminders','Expirations'};
    }
    public class AcknowledgeAuthoritativeCopyExport_element {
        public String EnvelopeId;
        public String TransactionId;
        public String checkSumHash;
        private String[] EnvelopeId_type_info = new String[]{'EnvelopeId','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] TransactionId_type_info = new String[]{'TransactionId','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] checkSumHash_type_info = new String[]{'checkSumHash','http://www.w3.org/2001/XMLSchema','base64Binary','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'EnvelopeId','TransactionId','checkSumHash'};
    }
    public class RequestCorrectTokenResponse_element {
        public String RequestCorrectTokenResult;
        private String[] RequestCorrectTokenResult_type_info = new String[]{'RequestCorrectTokenResult','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'RequestCorrectTokenResult'};
    }
    public class AcknowledgeAuthoritativeCopyExportResponse_element {
        public DocuSignAPI.AuthoritativeCopyExportStatus AcknowledgeAuthoritativeCopyExportResult;
        private String[] AcknowledgeAuthoritativeCopyExportResult_type_info = new String[]{'AcknowledgeAuthoritativeCopyExportResult','http://www.docusign.net/API/3.0','AuthoritativeCopyExportStatus','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'AcknowledgeAuthoritativeCopyExportResult'};
    }
    public class VoidEnvelopeResponse_element {
        public DocuSignAPI.VoidEnvelopeStatus VoidEnvelopeResult;
        private String[] VoidEnvelopeResult_type_info = new String[]{'VoidEnvelopeResult','http://www.docusign.net/API/3.0','VoidEnvelopeStatus','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'VoidEnvelopeResult'};
    }
    public class RequestRecipientTokenAuthenticationAssertion {
        public String AssertionID;
        public DateTime AuthenticationInstant;
        public String AuthenticationMethod;
        public String SecurityDomain;
        private String[] AssertionID_type_info = new String[]{'AssertionID','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] AuthenticationInstant_type_info = new String[]{'AuthenticationInstant','http://www.w3.org/2001/XMLSchema','dateTime','1','1','false'};
        private String[] AuthenticationMethod_type_info = new String[]{'AuthenticationMethod','http://www.docusign.net/API/3.0','RequestRecipientTokenAuthenticationAssertionAuthenticationMethod','1','1','false'};
        private String[] SecurityDomain_type_info = new String[]{'SecurityDomain','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'AssertionID','AuthenticationInstant','AuthenticationMethod','SecurityDomain'};
    }
    public class RequestPDFsWithOptionsResponse_element {
        public DocuSignAPI.DocumentPDFs RequestPDFsWithOptionsResult;
        private String[] RequestPDFsWithOptionsResult_type_info = new String[]{'RequestPDFsWithOptionsResult','http://www.docusign.net/API/3.0','DocumentPDFs','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'RequestPDFsWithOptionsResult'};
    }
    public class CorrectAndResendEnvelopeResponse_element {
        public DocuSignAPI.CorrectionStatus CorrectAndResendEnvelopeResult;
        private String[] CorrectAndResendEnvelopeResult_type_info = new String[]{'CorrectAndResendEnvelopeResult','http://www.docusign.net/API/3.0','CorrectionStatus','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'CorrectAndResendEnvelopeResult'};
    }
    public class PDFsOptions {
        public Boolean ShowChanges;
        private String[] ShowChanges_type_info = new String[]{'ShowChanges','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'ShowChanges'};
    }
    public class GetAccountBrandsResponse_element {
        public DocuSignAPI.BrandResults GetAccountBrandsResult;
        private String[] GetAccountBrandsResult_type_info = new String[]{'GetAccountBrandsResult','http://www.docusign.net/API/3.0','BrandResults','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'GetAccountBrandsResult'};
    }
    public class GetAccountSettingsListResponse_element {
        public DocuSignAPI.AccountSettingsList GetAccountSettingsListResult;
        private String[] GetAccountSettingsListResult_type_info = new String[]{'GetAccountSettingsListResult','http://www.docusign.net/API/3.0','AccountSettingsList','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'GetAccountSettingsListResult'};
    }
    public class RecipientCaptiveInfo {
        public String ClientUserId;
        private String[] ClientUserId_type_info = new String[]{'ClientUserId','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'ClientUserId'};
    }
    public class ArrayOfAddressBookRemoveItem {
        public DocuSignAPI.AddressBookRemoveItem[] AddressBookRemoveItem;
        private String[] AddressBookRemoveItem_type_info = new String[]{'AddressBookRemoveItem','http://www.docusign.net/API/3.0','AddressBookRemoveItem','0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'AddressBookRemoveItem'};
    }
    public class ArrayOfBrandResultItem {
        public DocuSignAPI.BrandResultItem[] BrandResultItem;
        private String[] BrandResultItem_type_info = new String[]{'BrandResultItem','http://www.docusign.net/API/3.0','BrandResultItem','0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'BrandResultItem'};
    }
    public class RequestPDFWithCertResponse_element {
        public DocuSignAPI.EnvelopePDF RequestPDFWithCertResult;
        private String[] RequestPDFWithCertResult_type_info = new String[]{'RequestPDFWithCertResult','http://www.docusign.net/API/3.0','EnvelopePDF','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'RequestPDFWithCertResult'};
    }
    public class DOBInformation {
        public DateTime DOB;
        private String[] DOB_type_info = new String[]{'DOB','http://www.w3.org/2001/XMLSchema','dateTime','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'DOB'};
    }
    public class GetStatusInDocuSignConnectFormat_element {
        public String EnvelopeID;
        private String[] EnvelopeID_type_info = new String[]{'EnvelopeID','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'EnvelopeID'};
    }
    public class RequestRecipientTokenClientURLs {
        public String OnSigningComplete;
        public String OnViewingComplete;
        public String OnCancel;
        public String OnDecline;
        public String OnSessionTimeout;
        public String OnTTLExpired;
        public String OnException;
        public String OnAccessCodeFailed;
        public String OnIdCheckFailed;
        public String OnFaxPending;
        public Boolean GenerateSignedDocumentAsynch;
        private String[] OnSigningComplete_type_info = new String[]{'OnSigningComplete','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] OnViewingComplete_type_info = new String[]{'OnViewingComplete','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] OnCancel_type_info = new String[]{'OnCancel','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] OnDecline_type_info = new String[]{'OnDecline','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] OnSessionTimeout_type_info = new String[]{'OnSessionTimeout','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] OnTTLExpired_type_info = new String[]{'OnTTLExpired','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] OnException_type_info = new String[]{'OnException','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] OnAccessCodeFailed_type_info = new String[]{'OnAccessCodeFailed','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] OnIdCheckFailed_type_info = new String[]{'OnIdCheckFailed','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] OnFaxPending_type_info = new String[]{'OnFaxPending','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] GenerateSignedDocumentAsynch_type_info = new String[]{'GenerateSignedDocumentAsynch','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'OnSigningComplete','OnViewingComplete','OnCancel','OnDecline','OnSessionTimeout','OnTTLExpired','OnException','OnAccessCodeFailed','OnIdCheckFailed','OnFaxPending','GenerateSignedDocumentAsynch'};
    }
    public class SynchEnvelopeStatus {
        public String EnvelopeStatus;
        public String EnvelopeID;
        private String[] EnvelopeStatus_type_info = new String[]{'EnvelopeStatus','http://www.docusign.net/API/3.0','EnvelopeStatusCode','1','1','false'};
        private String[] EnvelopeID_type_info = new String[]{'EnvelopeID','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'EnvelopeStatus','EnvelopeID'};
    }
    public class RequestStatusEx_element {
        public String EnvelopeID;
        private String[] EnvelopeID_type_info = new String[]{'EnvelopeID','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'EnvelopeID'};
    }
    public class GetRecipientEsignListResponse_element {
        public DocuSignAPI.RecipientEsignList GetRecipientEsignListResult;
        private String[] GetRecipientEsignListResult_type_info = new String[]{'GetRecipientEsignListResult','http://www.docusign.net/API/3.0','RecipientEsignList','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'GetRecipientEsignListResult'};
    }
    public class RecipientStatus {
        public String Type_x;
        public String Email;
        public String UserName;
        public Integer RoutingOrder;
        public DateTime Sent;
        public DateTime Delivered;
        public DateTime Signed;
        public DateTime Declined;
        public String DeclineReason;
        public String AutoRespondedReason;
        public String Status;
        public String RecipientIPAddress;
        public String ClientUserId;
        public Boolean AutoNavigation;
        public DocuSignAPI.IDCheckInformation IDCheckInformation;
        public DocuSignAPI.AuthenticationStatus RecipientAuthenticationStatus;
        public DocuSignAPI.ArrayOfString1 CustomFields;
        public DocuSignAPI.ArrayOfTabStatus TabStatuses;
        public DocuSignAPI.ArrayOfAttachment RecipientAttachment;
        public String AccountStatus;
        public DocuSignAPI.RecipientStatusEsignAgreementInformation EsignAgreementInformation;
        public DocuSignAPI.FormData FormData;
        public String RecipientId;
        public String DeliveryMethod;
        public String FaxNumber;
        private String[] Type_x_type_info = new String[]{'Type','http://www.docusign.net/API/3.0','RecipientTypeCode','1','1','false'};
        private String[] Email_type_info = new String[]{'Email','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] UserName_type_info = new String[]{'UserName','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] RoutingOrder_type_info = new String[]{'RoutingOrder','http://www.w3.org/2001/XMLSchema','unsignedShort','1','1','false'};
        private String[] Sent_type_info = new String[]{'Sent','http://www.w3.org/2001/XMLSchema','dateTime','0','1','false'};
        private String[] Delivered_type_info = new String[]{'Delivered','http://www.w3.org/2001/XMLSchema','dateTime','0','1','false'};
        private String[] Signed_type_info = new String[]{'Signed','http://www.w3.org/2001/XMLSchema','dateTime','0','1','false'};
        private String[] Declined_type_info = new String[]{'Declined','http://www.w3.org/2001/XMLSchema','dateTime','0','1','false'};
        private String[] DeclineReason_type_info = new String[]{'DeclineReason','http://www.w3.org/2001/XMLSchema','string','1','1','true'};
        private String[] AutoRespondedReason_type_info = new String[]{'AutoRespondedReason','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Status_type_info = new String[]{'Status','http://www.docusign.net/API/3.0','RecipientStatusCode','1','1','false'};
        private String[] RecipientIPAddress_type_info = new String[]{'RecipientIPAddress','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] ClientUserId_type_info = new String[]{'ClientUserId','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] AutoNavigation_type_info = new String[]{'AutoNavigation','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] IDCheckInformation_type_info = new String[]{'IDCheckInformation','http://www.docusign.net/API/3.0','IDCheckInformation','0','1','false'};
        private String[] RecipientAuthenticationStatus_type_info = new String[]{'RecipientAuthenticationStatus','http://www.docusign.net/API/3.0','AuthenticationStatus','0','1','false'};
        private String[] CustomFields_type_info = new String[]{'CustomFields','http://www.docusign.net/API/3.0','ArrayOfString1','0','1','false'};
        private String[] TabStatuses_type_info = new String[]{'TabStatuses','http://www.docusign.net/API/3.0','ArrayOfTabStatus','0','1','false'};
        private String[] RecipientAttachment_type_info = new String[]{'RecipientAttachment','http://www.docusign.net/API/3.0','ArrayOfAttachment','0','1','false'};
        private String[] AccountStatus_type_info = new String[]{'AccountStatus','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] EsignAgreementInformation_type_info = new String[]{'EsignAgreementInformation','http://www.docusign.net/API/3.0','RecipientStatusEsignAgreementInformation','0','1','false'};
        private String[] FormData_type_info = new String[]{'FormData','http://www.docusign.net/API/3.0','FormData','0','1','false'};
        private String[] RecipientId_type_info = new String[]{'RecipientId','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] DeliveryMethod_type_info = new String[]{'DeliveryMethod','http://www.docusign.net/API/3.0','DeliveryMethod','0','1','false'};
        private String[] FaxNumber_type_info = new String[]{'FaxNumber','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'Type_x','Email','UserName','RoutingOrder','Sent','Delivered','Signed','Declined','DeclineReason','AutoRespondedReason','Status','RecipientIPAddress','ClientUserId','AutoNavigation','IDCheckInformation','RecipientAuthenticationStatus','CustomFields','TabStatuses','RecipientAttachment','AccountStatus','EsignAgreementInformation','FormData','RecipientId','DeliveryMethod','FaxNumber'};
    }
    public class RequestStatusChanges_element {
        public DocuSignAPI.EnvelopeStatusChangeFilter EnvelopeStatusChangeFilter;
        private String[] EnvelopeStatusChangeFilter_type_info = new String[]{'EnvelopeStatusChangeFilter','http://www.docusign.net/API/3.0','EnvelopeStatusChangeFilter','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'EnvelopeStatusChangeFilter'};
    }
    public class RequestSenderTokenResponse_element {
        public String RequestSenderTokenResult;
        private String[] RequestSenderTokenResult_type_info = new String[]{'RequestSenderTokenResult','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'RequestSenderTokenResult'};
    }
    public class RequestRecipientFaxTokenResponse_element {
        public String RequestRecipientFaxTokenResult;
        private String[] RequestRecipientFaxTokenResult_type_info = new String[]{'RequestRecipientFaxTokenResult','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'RequestRecipientFaxTokenResult'};
    }
    public class RecipientCorrection {
        public String PreviousUserName;
        public String PreviousEmail;
        public Integer PreviousRoutingOrder;
        public String PreviousSignerName;
        public String CorrectedUserName;
        public String CorrectedSignerName;
        public String CorrectedEmail;
        public DocuSignAPI.RecipientCorrectionCorrectedCaptiveInfo CorrectedCaptiveInfo;
        public String CorrectedAccessCode;
        public Boolean CorrectedAccessCodeRequired;
        public Boolean CorrectedRequireIDLookup;
        public String CorrectedIDCheckConfigurationName;
        public Integer CorrectedRoutingOrder;
        public Boolean CorrectedAutoNavigation;
        public DocuSignAPI.IDCheckInformationInput CorrectedIDCheckInformationInput;
        public Boolean Resend;
        public String CorrectedDeliveryMethod;
        public String CorrectedFaxNumber;
        private String[] PreviousUserName_type_info = new String[]{'PreviousUserName','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] PreviousEmail_type_info = new String[]{'PreviousEmail','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] PreviousRoutingOrder_type_info = new String[]{'PreviousRoutingOrder','http://www.w3.org/2001/XMLSchema','unsignedShort','1','1','false'};
        private String[] PreviousSignerName_type_info = new String[]{'PreviousSignerName','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] CorrectedUserName_type_info = new String[]{'CorrectedUserName','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] CorrectedSignerName_type_info = new String[]{'CorrectedSignerName','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] CorrectedEmail_type_info = new String[]{'CorrectedEmail','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] CorrectedCaptiveInfo_type_info = new String[]{'CorrectedCaptiveInfo','http://www.docusign.net/API/3.0','RecipientCorrectionCorrectedCaptiveInfo','0','1','false'};
        private String[] CorrectedAccessCode_type_info = new String[]{'CorrectedAccessCode','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] CorrectedAccessCodeRequired_type_info = new String[]{'CorrectedAccessCodeRequired','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] CorrectedRequireIDLookup_type_info = new String[]{'CorrectedRequireIDLookup','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] CorrectedIDCheckConfigurationName_type_info = new String[]{'CorrectedIDCheckConfigurationName','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] CorrectedRoutingOrder_type_info = new String[]{'CorrectedRoutingOrder','http://www.w3.org/2001/XMLSchema','unsignedShort','0','1','false'};
        private String[] CorrectedAutoNavigation_type_info = new String[]{'CorrectedAutoNavigation','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] CorrectedIDCheckInformationInput_type_info = new String[]{'CorrectedIDCheckInformationInput','http://www.docusign.net/API/3.0','IDCheckInformationInput','0','1','false'};
        private String[] Resend_type_info = new String[]{'Resend','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] CorrectedDeliveryMethod_type_info = new String[]{'CorrectedDeliveryMethod','http://www.docusign.net/API/3.0','DeliveryMethod','0','1','false'};
        private String[] CorrectedFaxNumber_type_info = new String[]{'CorrectedFaxNumber','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'PreviousUserName','PreviousEmail','PreviousRoutingOrder','PreviousSignerName','CorrectedUserName','CorrectedSignerName','CorrectedEmail','CorrectedCaptiveInfo','CorrectedAccessCode','CorrectedAccessCodeRequired','CorrectedRequireIDLookup','CorrectedIDCheckConfigurationName','CorrectedRoutingOrder','CorrectedAutoNavigation','CorrectedIDCheckInformationInput','Resend','CorrectedDeliveryMethod','CorrectedFaxNumber'};
    }
    public class RequestPDFWithOptionsResponse_element {
        public DocuSignAPI.EnvelopePDF RequestPDFWithOptionsResult;
        private String[] RequestPDFWithOptionsResult_type_info = new String[]{'RequestPDFWithOptionsResult','http://www.docusign.net/API/3.0','EnvelopePDF','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'RequestPDFWithOptionsResult'};
    }
    public class ArrayOfEnvelopeStatusChange {
        public DocuSignAPI.EnvelopeStatusChange[] EnvelopeStatusChange;
        private String[] EnvelopeStatusChange_type_info = new String[]{'EnvelopeStatusChange','http://www.docusign.net/API/3.0','EnvelopeStatusChange','0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'EnvelopeStatusChange'};
    }
    public class RequestStatusesExResponse_element {
        public DocuSignAPI.FilteredEnvelopeStatuses RequestStatusesExResult;
        private String[] RequestStatusesExResult_type_info = new String[]{'RequestStatusesExResult','http://www.docusign.net/API/3.0','FilteredEnvelopeStatuses','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'RequestStatusesExResult'};
    }
    public class RecipientEsign {
        public String UserName;
        public String Email;
        public Boolean Esign;
        public Boolean ReservedRecipientEmail;
        public String ReservedRecipientNames;
        private String[] UserName_type_info = new String[]{'UserName','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Email_type_info = new String[]{'Email','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Esign_type_info = new String[]{'Esign','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] ReservedRecipientEmail_type_info = new String[]{'ReservedRecipientEmail','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] ReservedRecipientNames_type_info = new String[]{'ReservedRecipientNames','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'UserName','Email','Esign','ReservedRecipientEmail','ReservedRecipientNames'};
    }
    public class Envelope {
        public String TransactionID;
        public Boolean Asynchronous;
        public String AccountId;
        public DocuSignAPI.ArrayOfDocument Documents;
        public DocuSignAPI.ArrayOfRecipient Recipients;
        public DocuSignAPI.ArrayOfTab Tabs;
        public String Subject;
        public String EmailBlurb;
        public String SigningLocation;
        public DocuSignAPI.ArrayOfCustomField CustomFields;
        public DocuSignAPI.VaultingOptions VaultingOptions;
        public Boolean AutoNavigation;
        public Boolean EnvelopeIdStamping;
        public Boolean AuthoritativeCopy;
        public DocuSignAPI.Notification Notification;
        public DocuSignAPI.ArrayOfAttachment EnvelopeAttachment;
        public Boolean EnforceSignerVisibility;
        public Boolean EnableWetSign;
        public Boolean AllowMarkup;
        public DocuSignAPI.EventNotification EventNotification;
        public Boolean AllowReassign;
        public String BrandId;
        public Boolean BrandLock;
        private String[] TransactionID_type_info = new String[]{'TransactionID','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Asynchronous_type_info = new String[]{'Asynchronous','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] AccountId_type_info = new String[]{'AccountId','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Documents_type_info = new String[]{'Documents','http://www.docusign.net/API/3.0','ArrayOfDocument','0','1','false'};
        private String[] Recipients_type_info = new String[]{'Recipients','http://www.docusign.net/API/3.0','ArrayOfRecipient','0','1','false'};
        private String[] Tabs_type_info = new String[]{'Tabs','http://www.docusign.net/API/3.0','ArrayOfTab','0','1','false'};
        private String[] Subject_type_info = new String[]{'Subject','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] EmailBlurb_type_info = new String[]{'EmailBlurb','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] SigningLocation_type_info = new String[]{'SigningLocation','http://www.docusign.net/API/3.0','SigningLocationCode','0','1','false'};
        private String[] CustomFields_type_info = new String[]{'CustomFields','http://www.docusign.net/API/3.0','ArrayOfCustomField','0','1','false'};
        private String[] VaultingOptions_type_info = new String[]{'VaultingOptions','http://www.docusign.net/API/3.0','VaultingOptions','0','1','false'};
        private String[] AutoNavigation_type_info = new String[]{'AutoNavigation','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] EnvelopeIdStamping_type_info = new String[]{'EnvelopeIdStamping','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] AuthoritativeCopy_type_info = new String[]{'AuthoritativeCopy','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] Notification_type_info = new String[]{'Notification','http://www.docusign.net/API/3.0','Notification','0','1','false'};
        private String[] EnvelopeAttachment_type_info = new String[]{'EnvelopeAttachment','http://www.docusign.net/API/3.0','ArrayOfAttachment','0','1','false'};
        private String[] EnforceSignerVisibility_type_info = new String[]{'EnforceSignerVisibility','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] EnableWetSign_type_info = new String[]{'EnableWetSign','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] AllowMarkup_type_info = new String[]{'AllowMarkup','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] EventNotification_type_info = new String[]{'EventNotification','http://www.docusign.net/API/3.0','EventNotification','0','1','false'};
        private String[] AllowReassign_type_info = new String[]{'AllowReassign','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] BrandId_type_info = new String[]{'BrandId','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] BrandLock_type_info = new String[]{'BrandLock','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'TransactionID','Asynchronous','AccountId','Documents','Recipients','Tabs','Subject','EmailBlurb','SigningLocation','CustomFields','VaultingOptions','AutoNavigation','EnvelopeIdStamping','AuthoritativeCopy','Notification','EnvelopeAttachment','EnforceSignerVisibility','EnableWetSign','AllowMarkup','EventNotification','AllowReassign','BrandId','BrandLock'};
    }
    public class EnvelopeTemplates {
        public DocuSignAPI.EnvelopeTemplateDefinition[] EnvelopeTemplateDefinition;
        private String[] EnvelopeTemplateDefinition_type_info = new String[]{'EnvelopeTemplateDefinition','http://www.docusign.net/API/3.0','EnvelopeTemplateDefinition','0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'EnvelopeTemplateDefinition'};
    }
    public class PingResponse_element {
        public Boolean PingResult;
        private String[] PingResult_type_info = new String[]{'PingResult','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'PingResult'};
    }
    public class EnvelopeStatusFilterBeginDateTime {
        public String statusQualifier;
        private String[] statusQualifier_att_info = new String[]{'statusQualifier'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class RequestStatuses_element {
        public DocuSignAPI.EnvelopeStatusFilter EnvelopeStatusFilter;
        private String[] EnvelopeStatusFilter_type_info = new String[]{'EnvelopeStatusFilter','http://www.docusign.net/API/3.0','EnvelopeStatusFilter','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'EnvelopeStatusFilter'};
    }
    public class ArrayOfTab {
        public DocuSignAPI.Tab[] Tab;
        private String[] Tab_type_info = new String[]{'Tab','http://www.docusign.net/API/3.0','Tab','0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'Tab'};
    }
    public class VaultingOptions {
        public String VaultingMode;
        public String EODTransactionName;
        public String EODDocumentName;
        public String EODDocumentDescription;
        private String[] VaultingMode_type_info = new String[]{'VaultingMode','http://www.docusign.net/API/3.0','VaultingModeCode','1','1','false'};
        private String[] EODTransactionName_type_info = new String[]{'EODTransactionName','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] EODDocumentName_type_info = new String[]{'EODDocumentName','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] EODDocumentDescription_type_info = new String[]{'EODDocumentDescription','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'VaultingMode','EODTransactionName','EODDocumentName','EODDocumentDescription'};
    }
    public class RemoveAddressBookItemsResponse_element {
        public DocuSignAPI.UpdateAddressBookResult RemoveAddressBookItemsResult;
        private String[] RemoveAddressBookItemsResult_type_info = new String[]{'RemoveAddressBookItemsResult','http://www.docusign.net/API/3.0','UpdateAddressBookResult','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'RemoveAddressBookItemsResult'};
    }
    public class CreateEnvelope_element {
        public DocuSignAPI.Envelope Envelope;
        private String[] Envelope_type_info = new String[]{'Envelope','http://www.docusign.net/API/3.0','Envelope','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'Envelope'};
    }
    public class AddressInformation {
        public String Street1;
        public String Street2;
        public String City;
        public String State;
        public String Zip;
        public String ZipPlus4;
        private String[] Street1_type_info = new String[]{'Street1','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Street2_type_info = new String[]{'Street2','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] City_type_info = new String[]{'City','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] State_type_info = new String[]{'State','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Zip_type_info = new String[]{'Zip','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] ZipPlus4_type_info = new String[]{'ZipPlus4','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'Street1','Street2','City','State','Zip','ZipPlus4'};
    }
    public class AnchorTab {
        public String AnchorTabString;
        public Double XOffset;
        public Double YOffset;
        public String Unit;
        public Boolean IgnoreIfNotPresent;
        private String[] AnchorTabString_type_info = new String[]{'AnchorTabString','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] XOffset_type_info = new String[]{'XOffset','http://www.w3.org/2001/XMLSchema','double','0','1','false'};
        private String[] YOffset_type_info = new String[]{'YOffset','http://www.w3.org/2001/XMLSchema','double','0','1','false'};
        private String[] Unit_type_info = new String[]{'Unit','http://www.docusign.net/API/3.0','UnitTypeCode','0','1','false'};
        private String[] IgnoreIfNotPresent_type_info = new String[]{'IgnoreIfNotPresent','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'AnchorTabString','XOffset','YOffset','Unit','IgnoreIfNotPresent'};
    }
    public class VaultingDetails {
        public String EODTransactionName;
        public String EODTransactionID;
        public String EODDocumentProfileID;
        private String[] EODTransactionName_type_info = new String[]{'EODTransactionName','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] EODTransactionID_type_info = new String[]{'EODTransactionID','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] EODDocumentProfileID_type_info = new String[]{'EODDocumentProfileID','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'EODTransactionName','EODTransactionID','EODDocumentProfileID'};
    }
    public class GetAuthenticationTokenResponse_element {
        public String GetAuthenticationTokenResult;
        private String[] GetAuthenticationTokenResult_type_info = new String[]{'GetAuthenticationTokenResult','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'GetAuthenticationTokenResult'};
    }
    public class RequestRecipientTokenResponse_element {
        public String RequestRecipientTokenResult;
        private String[] RequestRecipientTokenResult_type_info = new String[]{'RequestRecipientTokenResult','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'RequestRecipientTokenResult'};
    }
    public class RequestPDFWithOptions_element {
        public String EnvelopeID;
        public DocuSignAPI.PDFOptions PDFOptions;
        private String[] EnvelopeID_type_info = new String[]{'EnvelopeID','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] PDFOptions_type_info = new String[]{'PDFOptions','http://www.docusign.net/API/3.0','PDFOptions','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'EnvelopeID','PDFOptions'};
    }
    public class ArrayOfAddressBookItem {
        public DocuSignAPI.AddressBookItem[] AddressBookItem;
        private String[] AddressBookItem_type_info = new String[]{'AddressBookItem','http://www.docusign.net/API/3.0','AddressBookItem','0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'AddressBookItem'};
    }
    public class EnvelopeInformation {
        public String TransactionID;
        public Boolean Asynchronous;
        public String AccountId;
        public String EmailBlurb;
        public String Subject;
        public String SigningLocation;
        public DocuSignAPI.ArrayOfCustomField CustomFields;
        public DocuSignAPI.VaultingOptions VaultingOptions;
        public Boolean AutoNavigation;
        public Boolean EnvelopeIdStamping;
        public Boolean AuthoritativeCopy;
        public DocuSignAPI.Notification Notification;
        public Boolean EnforceSignerVisibility;
        public Boolean EnableWetSign;
        public Boolean AllowRecipientRecursion;
        public Boolean AllowMarkup;
        public String BrandId;
        public DocuSignAPI.EventNotification EventNotification;
        public Boolean AllowReassign;
        private String[] TransactionID_type_info = new String[]{'TransactionID','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Asynchronous_type_info = new String[]{'Asynchronous','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] AccountId_type_info = new String[]{'AccountId','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] EmailBlurb_type_info = new String[]{'EmailBlurb','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Subject_type_info = new String[]{'Subject','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] SigningLocation_type_info = new String[]{'SigningLocation','http://www.docusign.net/API/3.0','SigningLocationCode','0','1','false'};
        private String[] CustomFields_type_info = new String[]{'CustomFields','http://www.docusign.net/API/3.0','ArrayOfCustomField','0','1','false'};
        private String[] VaultingOptions_type_info = new String[]{'VaultingOptions','http://www.docusign.net/API/3.0','VaultingOptions','0','1','false'};
        private String[] AutoNavigation_type_info = new String[]{'AutoNavigation','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] EnvelopeIdStamping_type_info = new String[]{'EnvelopeIdStamping','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] AuthoritativeCopy_type_info = new String[]{'AuthoritativeCopy','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] Notification_type_info = new String[]{'Notification','http://www.docusign.net/API/3.0','Notification','0','1','false'};
        private String[] EnforceSignerVisibility_type_info = new String[]{'EnforceSignerVisibility','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] EnableWetSign_type_info = new String[]{'EnableWetSign','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] AllowRecipientRecursion_type_info = new String[]{'AllowRecipientRecursion','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] AllowMarkup_type_info = new String[]{'AllowMarkup','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] BrandId_type_info = new String[]{'BrandId','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] EventNotification_type_info = new String[]{'EventNotification','http://www.docusign.net/API/3.0','EventNotification','0','1','false'};
        private String[] AllowReassign_type_info = new String[]{'AllowReassign','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'TransactionID','Asynchronous','AccountId','EmailBlurb','Subject','SigningLocation','CustomFields','VaultingOptions','AutoNavigation','EnvelopeIdStamping','AuthoritativeCopy','Notification','EnforceSignerVisibility','EnableWetSign','AllowRecipientRecursion','AllowMarkup','BrandId','EventNotification','AllowReassign'};
    }
    public class ArrayOfCustomField {
        public DocuSignAPI.CustomField[] CustomField;
        private String[] CustomField_type_info = new String[]{'CustomField','http://www.docusign.net/API/3.0','CustomField','0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'CustomField'};
    }
    public class ArrayOfEnvelopeStatus {
        public DocuSignAPI.EnvelopeStatus[] EnvelopeStatus;
        private String[] EnvelopeStatus_type_info = new String[]{'EnvelopeStatus','http://www.docusign.net/API/3.0','EnvelopeStatus','0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'EnvelopeStatus'};
    }
    public class ConnectFailure {
        public String EnvelopeId;
        public String AccountId;
        public DateTime Failed;
        public DateTime Retried;
        public Integer RetryCount;
        public String EnvelopeStatus;
        public String Sender;
        public String Email;
        public String Subject;
        public String Error;
        public String ConfigId;
        public String ConfigUrl;
        private String[] EnvelopeId_type_info = new String[]{'EnvelopeId','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] AccountId_type_info = new String[]{'AccountId','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Failed_type_info = new String[]{'Failed','http://www.w3.org/2001/XMLSchema','dateTime','1','1','false'};
        private String[] Retried_type_info = new String[]{'Retried','http://www.w3.org/2001/XMLSchema','dateTime','0','1','false'};
        private String[] RetryCount_type_info = new String[]{'RetryCount','http://www.w3.org/2001/XMLSchema','int','1','1','false'};
        private String[] EnvelopeStatus_type_info = new String[]{'EnvelopeStatus','http://www.docusign.net/API/3.0','EnvelopeStatusCode','1','1','false'};
        private String[] Sender_type_info = new String[]{'Sender','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Email_type_info = new String[]{'Email','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Subject_type_info = new String[]{'Subject','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Error_type_info = new String[]{'Error','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] ConfigId_type_info = new String[]{'ConfigId','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] ConfigUrl_type_info = new String[]{'ConfigUrl','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'EnvelopeId','AccountId','Failed','Retried','RetryCount','EnvelopeStatus','Sender','Email','Subject','Error','ConfigId','ConfigUrl'};
    }
    public class RecipientEmailNotification {
        public String Subject;
        public String EmailBlurb;
        public String Language;
        private String[] Subject_type_info = new String[]{'Subject','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] EmailBlurb_type_info = new String[]{'EmailBlurb','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Language_type_info = new String[]{'Language','http://www.docusign.net/API/3.0','SupportedLanguage','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'Subject','EmailBlurb','Language'};
    }
    public class RequestCertificateResponse_element {
        public DocuSignAPI.DocumentPDFs RequestCertificateResult;
        private String[] RequestCertificateResult_type_info = new String[]{'RequestCertificateResult','http://www.docusign.net/API/3.0','DocumentPDFs','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'RequestCertificateResult'};
    }
    public class DeleteEnvelopesArg {
        public DocuSignAPI.ArrayOfString2 EnvelopeIds;
        public String AccountId;
        public DocuSignAPI.FolderTypeInfo FolderFrom;
        private String[] EnvelopeIds_type_info = new String[]{'EnvelopeIds','http://www.docusign.net/API/3.0','ArrayOfString2','0','1','false'};
        private String[] AccountId_type_info = new String[]{'AccountId','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] FolderFrom_type_info = new String[]{'FolderFrom','http://www.docusign.net/API/3.0','FolderTypeInfo','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'EnvelopeIds','AccountId','FolderFrom'};
    }
    public class ErrorDetails {
        public String ErrorCode;
        public String Message;
        private String[] ErrorCode_type_info = new String[]{'ErrorCode','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Message_type_info = new String[]{'Message','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'ErrorCode','Message'};
    }
    public class BrandResultItem {
        public String BrandId;
        public String BrandName;
        public String BrandCompany;
        public DocuSignAPI.ErrorDetails ErrorDetails;
        private String[] BrandId_type_info = new String[]{'BrandId','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] BrandName_type_info = new String[]{'BrandName','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] BrandCompany_type_info = new String[]{'BrandCompany','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] ErrorDetails_type_info = new String[]{'ErrorDetails','http://www.docusign.net/API/3.0','ErrorDetails','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'BrandId','BrandName','BrandCompany','ErrorDetails'};
    }
    public class EnvelopeTemplate {
        public DocuSignAPI.EnvelopeTemplateDefinition EnvelopeTemplateDefinition;
        public DocuSignAPI.Envelope Envelope;
        private String[] EnvelopeTemplateDefinition_type_info = new String[]{'EnvelopeTemplateDefinition','http://www.docusign.net/API/3.0','EnvelopeTemplateDefinition','0','1','false'};
        private String[] Envelope_type_info = new String[]{'Envelope','http://www.docusign.net/API/3.0','Envelope','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'EnvelopeTemplateDefinition','Envelope'};
    }
    public class DocumentStatus {
        public Integer ID;
        public String Name;
        public String TemplateName;
        public Integer Sequence;
        private String[] ID_type_info = new String[]{'ID','http://www.w3.org/2001/XMLSchema','positiveInteger','0','1','false'};
        private String[] Name_type_info = new String[]{'Name','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] TemplateName_type_info = new String[]{'TemplateName','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Sequence_type_info = new String[]{'Sequence','http://www.w3.org/2001/XMLSchema','positiveInteger','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'ID','Name','TemplateName','Sequence'};
    }
    public class Tab {
        public Integer DocumentID;
        public Integer RecipientID;
        public Integer PageNumber;
        public Integer XPosition;
        public Integer YPosition;
        public Decimal ScaleValue;
        public DocuSignAPI.AnchorTab AnchorTabItem;
        public String Type_x;
        public String Name;
        public String TabLabel;
        public String Value;
        public String CustomTabType;
        public Integer CustomTabWidth;
        public Integer CustomTabHeight;
        public Boolean CustomTabRequired;
        public Boolean CustomTabLocked;
        public Boolean CustomTabDisableAutoSize;
        public String CustomTabListItems;
        public String CustomTabListValues;
        public String CustomTabListSelectedValue;
        public String CustomTabRadioGroupName;
        public String CustomTabValidationPattern;
        public String CustomTabValidationMessage;
        public Boolean TemplateLocked;
        public Boolean TemplateRequired;
        public String ConditionalParentLabel;
        public String ConditionalParentValue;
        public Boolean SharedTab;
        public Boolean RequireInitialOnSharedTabChange;
        public Boolean ConcealValueOnDocument;
        public String Font;
        public Boolean Bold;
        public Boolean Italic;
        public Boolean Underline;
        public String FontColor;
        public String FontSize;
        public String MergeFieldXml;
        public Boolean IncludeNoteInEmail;
        public Boolean IsPaymentAmount;
        public String Formula;
        public Integer RoundDecimalPlaces;
        public Integer MaxLength;
        private String[] DocumentID_type_info = new String[]{'DocumentID','http://www.w3.org/2001/XMLSchema','positiveInteger','0','1','false'};
        private String[] RecipientID_type_info = new String[]{'RecipientID','http://www.w3.org/2001/XMLSchema','positiveInteger','0','1','false'};
        private String[] PageNumber_type_info = new String[]{'PageNumber','http://www.w3.org/2001/XMLSchema','nonNegativeInteger','0','1','false'};
        private String[] XPosition_type_info = new String[]{'XPosition','http://www.w3.org/2001/XMLSchema','nonNegativeInteger','0','1','false'};
        private String[] YPosition_type_info = new String[]{'YPosition','http://www.w3.org/2001/XMLSchema','nonNegativeInteger','0','1','false'};
        private String[] ScaleValue_type_info = new String[]{'ScaleValue','http://www.w3.org/2001/XMLSchema','decimal','0','1','false'};
        private String[] AnchorTabItem_type_info = new String[]{'AnchorTabItem','http://www.docusign.net/API/3.0','AnchorTab','0','1','false'};
        private String[] Type_x_type_info = new String[]{'Type','http://www.docusign.net/API/3.0','TabTypeCode','1','1','false'};
        private String[] Name_type_info = new String[]{'Name','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] TabLabel_type_info = new String[]{'TabLabel','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Value_type_info = new String[]{'Value','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] CustomTabType_type_info = new String[]{'CustomTabType','http://www.docusign.net/API/3.0','CustomTabType','0','1','false'};
        private String[] CustomTabWidth_type_info = new String[]{'CustomTabWidth','http://www.w3.org/2001/XMLSchema','int','0','1','false'};
        private String[] CustomTabHeight_type_info = new String[]{'CustomTabHeight','http://www.w3.org/2001/XMLSchema','int','0','1','false'};
        private String[] CustomTabRequired_type_info = new String[]{'CustomTabRequired','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] CustomTabLocked_type_info = new String[]{'CustomTabLocked','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] CustomTabDisableAutoSize_type_info = new String[]{'CustomTabDisableAutoSize','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] CustomTabListItems_type_info = new String[]{'CustomTabListItems','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] CustomTabListValues_type_info = new String[]{'CustomTabListValues','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] CustomTabListSelectedValue_type_info = new String[]{'CustomTabListSelectedValue','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] CustomTabRadioGroupName_type_info = new String[]{'CustomTabRadioGroupName','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] CustomTabValidationPattern_type_info = new String[]{'CustomTabValidationPattern','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] CustomTabValidationMessage_type_info = new String[]{'CustomTabValidationMessage','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] TemplateLocked_type_info = new String[]{'TemplateLocked','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] TemplateRequired_type_info = new String[]{'TemplateRequired','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] ConditionalParentLabel_type_info = new String[]{'ConditionalParentLabel','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] ConditionalParentValue_type_info = new String[]{'ConditionalParentValue','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] SharedTab_type_info = new String[]{'SharedTab','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] RequireInitialOnSharedTabChange_type_info = new String[]{'RequireInitialOnSharedTabChange','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] ConcealValueOnDocument_type_info = new String[]{'ConcealValueOnDocument','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] Font_type_info = new String[]{'Font','http://www.docusign.net/API/3.0','Font','0','1','false'};
        private String[] Bold_type_info = new String[]{'Bold','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] Italic_type_info = new String[]{'Italic','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] Underline_type_info = new String[]{'Underline','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] FontColor_type_info = new String[]{'FontColor','http://www.docusign.net/API/3.0','FontColor','0','1','false'};
        private String[] FontSize_type_info = new String[]{'FontSize','http://www.docusign.net/API/3.0','FontSize','0','1','false'};
        private String[] MergeFieldXml_type_info = new String[]{'MergeFieldXml','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] IncludeNoteInEmail_type_info = new String[]{'IncludeNoteInEmail','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] IsPaymentAmount_type_info = new String[]{'IsPaymentAmount','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] Formula_type_info = new String[]{'Formula','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] RoundDecimalPlaces_type_info = new String[]{'RoundDecimalPlaces','http://www.w3.org/2001/XMLSchema','int','0','1','false'};
        private String[] MaxLength_type_info = new String[]{'MaxLength','http://www.w3.org/2001/XMLSchema','int','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'DocumentID','RecipientID','PageNumber','XPosition','YPosition','ScaleValue','AnchorTabItem','Type_x','Name','TabLabel','Value','CustomTabType','CustomTabWidth','CustomTabHeight','CustomTabRequired','CustomTabLocked','CustomTabDisableAutoSize','CustomTabListItems','CustomTabListValues','CustomTabListSelectedValue','CustomTabRadioGroupName','CustomTabValidationPattern','CustomTabValidationMessage','TemplateLocked','TemplateRequired','ConditionalParentLabel','ConditionalParentValue','SharedTab','RequireInitialOnSharedTabChange','ConcealValueOnDocument','Font','Bold','Italic','Underline','FontColor','FontSize','MergeFieldXml','IncludeNoteInEmail','IsPaymentAmount','Formula','RoundDecimalPlaces','MaxLength'};
    }
    public class PublishConnectFailuresResponse_element {
        public DocuSignAPI.ArrayOfPublishConnectFailuresResult PublishConnectFailuresResult;
        private String[] PublishConnectFailuresResult_type_info = new String[]{'PublishConnectFailuresResult','http://www.docusign.net/API/3.0','ArrayOfPublishConnectFailuresResult','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'PublishConnectFailuresResult'};
    }
    public class ArrayOfRecipient1 {
        public DocuSignAPI.Recipient[] Recipient;
        private String[] Recipient_type_info = new String[]{'Recipient','http://www.docusign.net/API/3.0','Recipient','0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'Recipient'};
    }
    public class Recipient {
        public Integer ID;
        public String UserName;
        public String SignerName;
        public String Email;
        public String Type_x;
        public String AccessCode;
        public Boolean AddAccessCodeToEmail;
        public Boolean RequireIDLookup;
        public String IDCheckConfigurationName;
        public String DeliveryMethod;
        public String FaxNumber;
        public Boolean LiveIDRecipientAuthentication;
        public Boolean FacebookRecipientAuthentication;
        public Boolean LinkedinRecipientAuthentication;
        public Boolean GoogleRecipientAuthentication;
        public Boolean SalesforceRecipientAuthentication;
        public Boolean TwitterRecipientAuthentication;
        public Boolean YahooRecipientAuthentication;
        public Boolean OpenIDRecipientAuthentication;
        public Boolean AnySocialIDRecipientAuthentication;
        public DocuSignAPI.RecipientPhoneAuthentication PhoneAuthentication;
        public DocuSignAPI.RecipientSignatureInfo SignatureInfo;
        public DocuSignAPI.RecipientCaptiveInfo CaptiveInfo;
        public DocuSignAPI.ArrayOfString1 CustomFields;
        public Integer RoutingOrder;
        public DocuSignAPI.IDCheckInformationInput IDCheckInformationInput;
        public Boolean AutoNavigation;
        public DocuSignAPI.ArrayOfAttachment RecipientAttachment;
        public String Note;
        public String RoleName;
        public Boolean TemplateLocked;
        public Boolean TemplateRequired;
        public Boolean TemplateAccessCodeRequired;
        public Boolean DefaultRecipient;
        public DocuSignAPI.RecipientEmailNotification EmailNotification;
        public Boolean AgentCanEditEmail;
        public Boolean AgentCanEditName;
        public Boolean SignInEachLocation;
        public DocuSignAPI.ArrayOfPositiveInteger ExcludedDocuments;
        public Boolean InheritEmailNotificationConfiguration;
        private String[] ID_type_info = new String[]{'ID','http://www.w3.org/2001/XMLSchema','positiveInteger','0','1','false'};
        private String[] UserName_type_info = new String[]{'UserName','http://www.w3.org/2001/XMLSchema','string','1','1','true'};
        private String[] SignerName_type_info = new String[]{'SignerName','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Email_type_info = new String[]{'Email','http://www.w3.org/2001/XMLSchema','string','1','1','true'};
        private String[] Type_x_type_info = new String[]{'Type','http://www.docusign.net/API/3.0','RecipientTypeCode','1','1','false'};
        private String[] AccessCode_type_info = new String[]{'AccessCode','http://www.w3.org/2001/XMLSchema','string','1','1','true'};
        private String[] AddAccessCodeToEmail_type_info = new String[]{'AddAccessCodeToEmail','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] RequireIDLookup_type_info = new String[]{'RequireIDLookup','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] IDCheckConfigurationName_type_info = new String[]{'IDCheckConfigurationName','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] DeliveryMethod_type_info = new String[]{'DeliveryMethod','http://www.docusign.net/API/3.0','DeliveryMethod','0','1','false'};
        private String[] FaxNumber_type_info = new String[]{'FaxNumber','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] LiveIDRecipientAuthentication_type_info = new String[]{'LiveIDRecipientAuthentication','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] FacebookRecipientAuthentication_type_info = new String[]{'FacebookRecipientAuthentication','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] LinkedinRecipientAuthentication_type_info = new String[]{'LinkedinRecipientAuthentication','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] GoogleRecipientAuthentication_type_info = new String[]{'GoogleRecipientAuthentication','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] SalesforceRecipientAuthentication_type_info = new String[]{'SalesforceRecipientAuthentication','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] TwitterRecipientAuthentication_type_info = new String[]{'TwitterRecipientAuthentication','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] YahooRecipientAuthentication_type_info = new String[]{'YahooRecipientAuthentication','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] OpenIDRecipientAuthentication_type_info = new String[]{'OpenIDRecipientAuthentication','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] AnySocialIDRecipientAuthentication_type_info = new String[]{'AnySocialIDRecipientAuthentication','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] PhoneAuthentication_type_info = new String[]{'PhoneAuthentication','http://www.docusign.net/API/3.0','RecipientPhoneAuthentication','0','1','false'};
        private String[] SignatureInfo_type_info = new String[]{'SignatureInfo','http://www.docusign.net/API/3.0','RecipientSignatureInfo','0','1','false'};
        private String[] CaptiveInfo_type_info = new String[]{'CaptiveInfo','http://www.docusign.net/API/3.0','RecipientCaptiveInfo','0','1','false'};
        private String[] CustomFields_type_info = new String[]{'CustomFields','http://www.docusign.net/API/3.0','ArrayOfString1','0','1','false'};
        private String[] RoutingOrder_type_info = new String[]{'RoutingOrder','http://www.w3.org/2001/XMLSchema','unsignedShort','0','1','false'};
        private String[] IDCheckInformationInput_type_info = new String[]{'IDCheckInformationInput','http://www.docusign.net/API/3.0','IDCheckInformationInput','0','1','false'};
        private String[] AutoNavigation_type_info = new String[]{'AutoNavigation','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] RecipientAttachment_type_info = new String[]{'RecipientAttachment','http://www.docusign.net/API/3.0','ArrayOfAttachment','0','1','false'};
        private String[] Note_type_info = new String[]{'Note','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] RoleName_type_info = new String[]{'RoleName','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] TemplateLocked_type_info = new String[]{'TemplateLocked','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] TemplateRequired_type_info = new String[]{'TemplateRequired','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] TemplateAccessCodeRequired_type_info = new String[]{'TemplateAccessCodeRequired','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] DefaultRecipient_type_info = new String[]{'DefaultRecipient','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] EmailNotification_type_info = new String[]{'EmailNotification','http://www.docusign.net/API/3.0','RecipientEmailNotification','0','1','false'};
        private String[] AgentCanEditEmail_type_info = new String[]{'AgentCanEditEmail','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] AgentCanEditName_type_info = new String[]{'AgentCanEditName','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] SignInEachLocation_type_info = new String[]{'SignInEachLocation','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] ExcludedDocuments_type_info = new String[]{'ExcludedDocuments','http://www.docusign.net/API/3.0','ArrayOfPositiveInteger','0','1','false'};
        private String[] InheritEmailNotificationConfiguration_type_info = new String[]{'InheritEmailNotificationConfiguration','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'ID','UserName','SignerName','Email','Type_x','AccessCode','AddAccessCodeToEmail','RequireIDLookup','IDCheckConfigurationName','DeliveryMethod','FaxNumber','LiveIDRecipientAuthentication','FacebookRecipientAuthentication','LinkedinRecipientAuthentication','GoogleRecipientAuthentication','SalesforceRecipientAuthentication','TwitterRecipientAuthentication','YahooRecipientAuthentication','OpenIDRecipientAuthentication','AnySocialIDRecipientAuthentication','PhoneAuthentication','SignatureInfo','CaptiveInfo','CustomFields','RoutingOrder','IDCheckInformationInput','AutoNavigation','RecipientAttachment','Note','RoleName','TemplateLocked','TemplateRequired','TemplateAccessCodeRequired','DefaultRecipient','EmailNotification','AgentCanEditEmail','AgentCanEditName','SignInEachLocation','ExcludedDocuments','InheritEmailNotificationConfiguration'};
    }
    public class ArrayOfFormDataXfdfField {
        public DocuSignAPI.FormDataXfdfField[] field;
        private String[] field_type_info = new String[]{'field','http://www.docusign.net/API/3.0','FormDataXfdfField','0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'field'};
    }
    public class RequestTemplatesResponse_element {
        public DocuSignAPI.EnvelopeTemplates RequestTemplatesResult;
        private String[] RequestTemplatesResult_type_info = new String[]{'RequestTemplatesResult','http://www.docusign.net/API/3.0','EnvelopeTemplates','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'RequestTemplatesResult'};
    }
    public class ArrayOfRecipientEsign {
        public DocuSignAPI.RecipientEsign[] RecipientEsign;
        private String[] RecipientEsign_type_info = new String[]{'RecipientEsign','http://www.docusign.net/API/3.0','RecipientEsign','0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'RecipientEsign'};
    }
    public class UpdateAddressBookItemsResponse_element {
        public DocuSignAPI.UpdateAddressBookResult UpdateAddressBookItemsResult;
        private String[] UpdateAddressBookItemsResult_type_info = new String[]{'UpdateAddressBookItemsResult','http://www.docusign.net/API/3.0','UpdateAddressBookResult','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'UpdateAddressBookItemsResult'};
    }
    public class ExportAuthoritativeCopy_element {
        public String EnvelopeId;
        private String[] EnvelopeId_type_info = new String[]{'EnvelopeId','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'EnvelopeId'};
    }
    public class RequestRecipientFaxToken_element {
        public String EnvelopeID;
        public String ClientUserID;
        public String Username;
        public String Email;
        public DocuSignAPI.RequestRecipientTokenAuthenticationAssertion AuthenticationAssertion;
        public DocuSignAPI.RequestRecipientTokenClientURLs ClientURLs;
        private String[] EnvelopeID_type_info = new String[]{'EnvelopeID','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] ClientUserID_type_info = new String[]{'ClientUserID','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Username_type_info = new String[]{'Username','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Email_type_info = new String[]{'Email','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] AuthenticationAssertion_type_info = new String[]{'AuthenticationAssertion','http://www.docusign.net/API/3.0','RequestRecipientTokenAuthenticationAssertion','0','1','false'};
        private String[] ClientURLs_type_info = new String[]{'ClientURLs','http://www.docusign.net/API/3.0','RequestRecipientTokenClientURLs','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'EnvelopeID','ClientUserID','Username','Email','AuthenticationAssertion','ClientURLs'};
    }
    public class ArrayOfString {
        public String[] SenderProvidedNumber;
        private String[] SenderProvidedNumber_type_info = new String[]{'SenderProvidedNumber','http://www.w3.org/2001/XMLSchema','string','0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'SenderProvidedNumber'};
    }
    public class RequestTemplate_element {
        public String TemplateID;
        public Boolean IncludeDocumentBytes;
        private String[] TemplateID_type_info = new String[]{'TemplateID','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] IncludeDocumentBytes_type_info = new String[]{'IncludeDocumentBytes','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'TemplateID','IncludeDocumentBytes'};
    }
    public class EnvelopeStatusFilter {
        public DocuSignAPI.UserInfo UserInfo;
        public String AccountId;
        public DocuSignAPI.EnvelopeStatusFilterBeginDateTime BeginDateTime;
        public DateTime EndDateTime;
        public DocuSignAPI.ArrayOfEnvelopeStatusCode Statuses;
        public DocuSignAPI.ArrayOfString2 EnvelopeIds;
        public Integer StartAtIndex;
        public String ACStatus;
        private String[] UserInfo_type_info = new String[]{'UserInfo','http://www.docusign.net/API/3.0','UserInfo','0','1','false'};
        private String[] AccountId_type_info = new String[]{'AccountId','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] BeginDateTime_type_info = new String[]{'BeginDateTime','http://www.docusign.net/API/3.0','EnvelopeStatusFilterBeginDateTime','1','1','true'};
        private String[] EndDateTime_type_info = new String[]{'EndDateTime','http://www.w3.org/2001/XMLSchema','dateTime','0','1','false'};
        private String[] Statuses_type_info = new String[]{'Statuses','http://www.docusign.net/API/3.0','ArrayOfEnvelopeStatusCode','0','1','false'};
        private String[] EnvelopeIds_type_info = new String[]{'EnvelopeIds','http://www.docusign.net/API/3.0','ArrayOfString2','0','1','false'};
        private String[] StartAtIndex_type_info = new String[]{'StartAtIndex','http://www.w3.org/2001/XMLSchema','nonNegativeInteger','1','1','true'};
        private String[] ACStatus_type_info = new String[]{'ACStatus','http://www.docusign.net/API/3.0','EnvelopeACStatusCode','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'UserInfo','AccountId','BeginDateTime','EndDateTime','Statuses','EnvelopeIds','StartAtIndex','ACStatus'};
    }
    public class CorrectionStatus {
        public DocuSignAPI.EnvelopeSettings EnvelopeSettingsCorrectionStatus;
        public DocuSignAPI.ArrayOfRecipientCorrectionStatus RecipientCorrectionStatuses;
        public DocuSignAPI.Reminders Reminders;
        public DocuSignAPI.Expirations Expirations;
        private String[] EnvelopeSettingsCorrectionStatus_type_info = new String[]{'EnvelopeSettingsCorrectionStatus','http://www.docusign.net/API/3.0','EnvelopeSettings','0','1','false'};
        private String[] RecipientCorrectionStatuses_type_info = new String[]{'RecipientCorrectionStatuses','http://www.docusign.net/API/3.0','ArrayOfRecipientCorrectionStatus','0','1','false'};
        private String[] Reminders_type_info = new String[]{'Reminders','http://www.docusign.net/API/3.0','Reminders','0','1','false'};
        private String[] Expirations_type_info = new String[]{'Expirations','http://www.docusign.net/API/3.0','Expirations','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'EnvelopeSettingsCorrectionStatus','RecipientCorrectionStatuses','Reminders','Expirations'};
    }
    public class ArrayOfDocument {
        public DocuSignAPI.Document[] Document;
        private String[] Document_type_info = new String[]{'Document','http://www.docusign.net/API/3.0','Document','0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'Document'};
    }
    public class PurgeDocumentStatus {
        public Boolean PurgeDocumentSuccess;
        public String PurgeDocumentError;
        private String[] PurgeDocumentSuccess_type_info = new String[]{'PurgeDocumentSuccess','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] PurgeDocumentError_type_info = new String[]{'PurgeDocumentError','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'PurgeDocumentSuccess','PurgeDocumentError'};
    }
    public class EnvelopeTemplateDefinition {
        public String TemplateID;
        public String Name;
        public Boolean Shared;
        public String TemplatePassword;
        public String TemplateDescription;
        public DateTime LastModified;
        public Integer PageCount;
        private String[] TemplateID_type_info = new String[]{'TemplateID','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Name_type_info = new String[]{'Name','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Shared_type_info = new String[]{'Shared','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] TemplatePassword_type_info = new String[]{'TemplatePassword','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] TemplateDescription_type_info = new String[]{'TemplateDescription','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] LastModified_type_info = new String[]{'LastModified','http://www.w3.org/2001/XMLSchema','dateTime','0','1','false'};
        private String[] PageCount_type_info = new String[]{'PageCount','http://www.w3.org/2001/XMLSchema','int','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'TemplateID','Name','Shared','TemplatePassword','TemplateDescription','LastModified','PageCount'};
    }
    public class RequestSenderToken_element {
        public String EnvelopeID;
        public String AccountID;
        public String ReturnURL;
        private String[] EnvelopeID_type_info = new String[]{'EnvelopeID','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] AccountID_type_info = new String[]{'AccountID','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] ReturnURL_type_info = new String[]{'ReturnURL','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'EnvelopeID','AccountID','ReturnURL'};
    }
    public class RequestStatusExResponse_element {
        public DocuSignAPI.EnvelopeStatus RequestStatusExResult;
        private String[] RequestStatusExResult_type_info = new String[]{'RequestStatusExResult','http://www.docusign.net/API/3.0','EnvelopeStatus','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'RequestStatusExResult'};
    }
    public class CreateEnvelopeFromTemplatesResponse_element {
        public DocuSignAPI.EnvelopeStatus CreateEnvelopeFromTemplatesResult;
        private String[] CreateEnvelopeFromTemplatesResult_type_info = new String[]{'CreateEnvelopeFromTemplatesResult','http://www.docusign.net/API/3.0','EnvelopeStatus','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'CreateEnvelopeFromTemplatesResult'};
    }
    public class BrandDeleteRequest {
        public DocuSignAPI.ArrayOfBrandRequestItem BrandRequestItems;
        private String[] BrandRequestItems_type_info = new String[]{'BrandRequestItems','http://www.docusign.net/API/3.0','ArrayOfBrandRequestItem','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'BrandRequestItems'};
    }
    public class ArrayOfString3 {
        public String[] RecipientName;
        private String[] RecipientName_type_info = new String[]{'RecipientName','http://www.w3.org/2001/XMLSchema','string','0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'RecipientName'};
    }
    public class ArrayOfString4 {
        public String[] EnabledFeatures;
        private String[] EnabledFeatures_type_info = new String[]{'EnabledFeatures','http://www.w3.org/2001/XMLSchema','string','0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'EnabledFeatures'};
    }
    public class ArrayOfString1 {
        public String[] CustomField;
        private String[] CustomField_type_info = new String[]{'CustomField','http://www.w3.org/2001/XMLSchema','string','0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'CustomField'};
    }
    public class ArrayOfString2 {
        public String[] EnvelopeId;
        private String[] EnvelopeId_type_info = new String[]{'EnvelopeId','http://www.w3.org/2001/XMLSchema','string','0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'EnvelopeId'};
    }
    public class RequestCorrectToken_element {
        public String EnvelopeID;
        public Boolean SuppressNavigation;
        public String ReturnURL;
        private String[] EnvelopeID_type_info = new String[]{'EnvelopeID','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] SuppressNavigation_type_info = new String[]{'SuppressNavigation','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] ReturnURL_type_info = new String[]{'ReturnURL','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'EnvelopeID','SuppressNavigation','ReturnURL'};
    }
    public class ArrayOfString5 {
        public String[] string_x;
        private String[] string_x_type_info = new String[]{'string','http://www.w3.org/2001/XMLSchema','string','0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'string_x'};
    }
    public class AuthenticationStatus {
        public DocuSignAPI.EventResult AccessCodeResult;
        public DocuSignAPI.EventResult IDQuestionsResult;
        public DocuSignAPI.EventResult IDLookupResult;
        public DocuSignAPI.EventResult AgeVerifyResult;
        public DocuSignAPI.EventResult STANPinResult;
        public DocuSignAPI.EventResult OFACResult;
        public DocuSignAPI.EventResult PhoneAuthResult;
        public DocuSignAPI.EventResult LiveIDResult;
        public DocuSignAPI.EventResult FacebookResult;
        public DocuSignAPI.EventResult GoogleResult;
        public DocuSignAPI.EventResult LinkedinResult;
        public DocuSignAPI.EventResult SalesforceResult;
        public DocuSignAPI.EventResult TwitterResult;
        public DocuSignAPI.EventResult OpenIDResult;
        public DocuSignAPI.EventResult AnySocialIDResult;
        public DocuSignAPI.EventResult YahooResult;
        private String[] AccessCodeResult_type_info = new String[]{'AccessCodeResult','http://www.docusign.net/API/3.0','EventResult','0','1','false'};
        private String[] IDQuestionsResult_type_info = new String[]{'IDQuestionsResult','http://www.docusign.net/API/3.0','EventResult','0','1','false'};
        private String[] IDLookupResult_type_info = new String[]{'IDLookupResult','http://www.docusign.net/API/3.0','EventResult','0','1','false'};
        private String[] AgeVerifyResult_type_info = new String[]{'AgeVerifyResult','http://www.docusign.net/API/3.0','EventResult','0','1','false'};
        private String[] STANPinResult_type_info = new String[]{'STANPinResult','http://www.docusign.net/API/3.0','EventResult','0','1','false'};
        private String[] OFACResult_type_info = new String[]{'OFACResult','http://www.docusign.net/API/3.0','EventResult','0','1','false'};
        private String[] PhoneAuthResult_type_info = new String[]{'PhoneAuthResult','http://www.docusign.net/API/3.0','EventResult','0','1','false'};
        private String[] LiveIDResult_type_info = new String[]{'LiveIDResult','http://www.docusign.net/API/3.0','EventResult','0','1','false'};
        private String[] FacebookResult_type_info = new String[]{'FacebookResult','http://www.docusign.net/API/3.0','EventResult','0','1','false'};
        private String[] GoogleResult_type_info = new String[]{'GoogleResult','http://www.docusign.net/API/3.0','EventResult','0','1','false'};
        private String[] LinkedinResult_type_info = new String[]{'LinkedinResult','http://www.docusign.net/API/3.0','EventResult','0','1','false'};
        private String[] SalesforceResult_type_info = new String[]{'SalesforceResult','http://www.docusign.net/API/3.0','EventResult','0','1','false'};
        private String[] TwitterResult_type_info = new String[]{'TwitterResult','http://www.docusign.net/API/3.0','EventResult','0','1','false'};
        private String[] OpenIDResult_type_info = new String[]{'OpenIDResult','http://www.docusign.net/API/3.0','EventResult','0','1','false'};
        private String[] AnySocialIDResult_type_info = new String[]{'AnySocialIDResult','http://www.docusign.net/API/3.0','EventResult','0','1','false'};
        private String[] YahooResult_type_info = new String[]{'YahooResult','http://www.docusign.net/API/3.0','EventResult','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'AccessCodeResult','IDQuestionsResult','IDLookupResult','AgeVerifyResult','STANPinResult','OFACResult','PhoneAuthResult','LiveIDResult','FacebookResult','GoogleResult','LinkedinResult','SalesforceResult','TwitterResult','OpenIDResult','AnySocialIDResult','YahooResult'};
    }
    public class DeleteAccountBrands_element {
        public String AccountId;
        public DocuSignAPI.BrandDeleteRequest BrandDeleteRequest;
        private String[] AccountId_type_info = new String[]{'AccountId','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] BrandDeleteRequest_type_info = new String[]{'BrandDeleteRequest','http://www.docusign.net/API/3.0','BrandDeleteRequest','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'AccountId','BrandDeleteRequest'};
    }
    public class Ping_element {
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class GetConnectFailures_element {
        public DocuSignAPI.ConnectFailuresFilter ConnectFailuresFilter;
        private String[] ConnectFailuresFilter_type_info = new String[]{'ConnectFailuresFilter','http://www.docusign.net/API/3.0','ConnectFailuresFilter','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'ConnectFailuresFilter'};
    }
    public class ArrayOfCompositeTemplate {
        public DocuSignAPI.CompositeTemplate[] CompositeTemplate;
        private String[] CompositeTemplate_type_info = new String[]{'CompositeTemplate','http://www.docusign.net/API/3.0','CompositeTemplate','0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'CompositeTemplate'};
    }
    public class GetAccountBrands_element {
        public String AccountId;
        private String[] AccountId_type_info = new String[]{'AccountId','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'AccountId'};
    }
    public class Correction {
        public String EnvelopeID;
        public DocuSignAPI.EnvelopeSettings EnvelopeSettingsCorrection;
        public DocuSignAPI.ArrayOfRecipientCorrection RecipientCorrections;
        public DocuSignAPI.Reminders Reminders;
        public DocuSignAPI.Expirations Expirations;
        private String[] EnvelopeID_type_info = new String[]{'EnvelopeID','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] EnvelopeSettingsCorrection_type_info = new String[]{'EnvelopeSettingsCorrection','http://www.docusign.net/API/3.0','EnvelopeSettings','0','1','false'};
        private String[] RecipientCorrections_type_info = new String[]{'RecipientCorrections','http://www.docusign.net/API/3.0','ArrayOfRecipientCorrection','0','1','false'};
        private String[] Reminders_type_info = new String[]{'Reminders','http://www.docusign.net/API/3.0','Reminders','0','1','false'};
        private String[] Expirations_type_info = new String[]{'Expirations','http://www.docusign.net/API/3.0','Expirations','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'EnvelopeID','EnvelopeSettingsCorrection','RecipientCorrections','Reminders','Expirations'};
    }
    public class RequestStatusChangesResponse_element {
        public DocuSignAPI.FilteredEnvelopeStatusChanges RequestStatusChangesResult;
        private String[] RequestStatusChangesResult_type_info = new String[]{'RequestStatusChangesResult','http://www.docusign.net/API/3.0','FilteredEnvelopeStatusChanges','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'RequestStatusChangesResult'};
    }
    public class Document {
        public Integer ID;
        public String Name;
        public String PDFBytes;
        public String Password;
        public Boolean TransformPdfFields;
        public String FileExtension;
        public DocuSignAPI.ArrayOfMatchBox MatchBoxes;
        public String AttachmentDescription;
        private String[] ID_type_info = new String[]{'ID','http://www.w3.org/2001/XMLSchema','positiveInteger','0','1','false'};
        private String[] Name_type_info = new String[]{'Name','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] PDFBytes_type_info = new String[]{'PDFBytes','http://www.w3.org/2001/XMLSchema','base64Binary','0','1','false'};
        private String[] Password_type_info = new String[]{'Password','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] TransformPdfFields_type_info = new String[]{'TransformPdfFields','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] FileExtension_type_info = new String[]{'FileExtension','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] MatchBoxes_type_info = new String[]{'MatchBoxes','http://www.docusign.net/API/3.0','ArrayOfMatchBox','0','1','false'};
        private String[] AttachmentDescription_type_info = new String[]{'AttachmentDescription','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'ID','Name','PDFBytes','Password','TransformPdfFields','FileExtension','MatchBoxes','AttachmentDescription'};
    }
    public class EventNotification {
        public String URL;
        public Boolean LoggingEnabled;
        public Boolean RequireAcknowledgment;
        public Boolean UseSoapInterface;
        public String SoapNameSpace;
        public Boolean IncludeCertificateWithSoap;
        public DocuSignAPI.ArrayOfEnvelopeEvent EnvelopeEvents;
        private String[] URL_type_info = new String[]{'URL','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] LoggingEnabled_type_info = new String[]{'LoggingEnabled','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] RequireAcknowledgment_type_info = new String[]{'RequireAcknowledgment','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] UseSoapInterface_type_info = new String[]{'UseSoapInterface','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] SoapNameSpace_type_info = new String[]{'SoapNameSpace','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] IncludeCertificateWithSoap_type_info = new String[]{'IncludeCertificateWithSoap','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] EnvelopeEvents_type_info = new String[]{'EnvelopeEvents','http://www.docusign.net/API/3.0','ArrayOfEnvelopeEvent','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'URL','LoggingEnabled','RequireAcknowledgment','UseSoapInterface','SoapNameSpace','IncludeCertificateWithSoap','EnvelopeEvents'};
    }
    public class Folder {
        public DocuSignAPI.UserInfo FolderOwner;
        public DocuSignAPI.FolderTypeInfo FolderTypeInfo;
        private String[] FolderOwner_type_info = new String[]{'FolderOwner','http://www.docusign.net/API/3.0','UserInfo','0','1','false'};
        private String[] FolderTypeInfo_type_info = new String[]{'FolderTypeInfo','http://www.docusign.net/API/3.0','FolderTypeInfo','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'FolderOwner','FolderTypeInfo'};
    }
    public class RequestStatusResponse_element {
        public DocuSignAPI.EnvelopeStatus RequestStatusResult;
        private String[] RequestStatusResult_type_info = new String[]{'RequestStatusResult','http://www.docusign.net/API/3.0','EnvelopeStatus','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'RequestStatusResult'};
    }
    public class EnvelopeStatusChange {
        public String EnvelopeID;
        public String Status;
        public DateTime StatusChanged;
        private String[] EnvelopeID_type_info = new String[]{'EnvelopeID','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Status_type_info = new String[]{'Status','http://www.docusign.net/API/3.0','EnvelopeStatusCode','1','1','false'};
        private String[] StatusChanged_type_info = new String[]{'StatusChanged','http://www.w3.org/2001/XMLSchema','dateTime','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'EnvelopeID','Status','StatusChanged'};
    }
    public class FolderTypeInfo {
        public String FolderType;
        public String FolderName;
        public String FolderPath;
        public String FolderId;
        private String[] FolderType_type_info = new String[]{'FolderType','http://www.docusign.net/API/3.0','FolderType','0','1','false'};
        private String[] FolderName_type_info = new String[]{'FolderName','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] FolderPath_type_info = new String[]{'FolderPath','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] FolderId_type_info = new String[]{'FolderId','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'FolderType','FolderName','FolderPath','FolderId'};
    }
    public class ArrayOfPublishConnectFailuresResult {
        public DocuSignAPI.PublishConnectFailuresResult[] PublishConnectFailuresResult;
        private String[] PublishConnectFailuresResult_type_info = new String[]{'PublishConnectFailuresResult','http://www.docusign.net/API/3.0','PublishConnectFailuresResult','0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'PublishConnectFailuresResult'};
    }
    public class GetAccountMembershipFeaturesListResponse_element {
        public DocuSignAPI.AccountMembershipFeaturesList GetAccountMembershipFeaturesListResult;
        private String[] GetAccountMembershipFeaturesListResult_type_info = new String[]{'GetAccountMembershipFeaturesListResult','http://www.docusign.net/API/3.0','AccountMembershipFeaturesList','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'GetAccountMembershipFeaturesListResult'};
    }
    public class CorrectAndResendEnvelope_element {
        public DocuSignAPI.Correction Correction;
        private String[] Correction_type_info = new String[]{'Correction','http://www.docusign.net/API/3.0','Correction','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'Correction'};
    }
    public class GetAuthenticationToken_element {
        public String GoToEnvelopeID;
        private String[] GoToEnvelopeID_type_info = new String[]{'GoToEnvelopeID','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'GoToEnvelopeID'};
    }
    public class ArrayOfRecipientStatus {
        public DocuSignAPI.RecipientStatus[] RecipientStatus;
        private String[] RecipientStatus_type_info = new String[]{'RecipientStatus','http://www.docusign.net/API/3.0','RecipientStatus','0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'RecipientStatus'};
    }
    public class GetFolderItemsResponse_element {
        public DocuSignAPI.FolderResults GetFolderItemsResult;
        private String[] GetFolderItemsResult_type_info = new String[]{'GetFolderItemsResult','http://www.docusign.net/API/3.0','FolderResults','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'GetFolderItemsResult'};
    }
    public class ArrayOfRecipientCorrection {
        public DocuSignAPI.RecipientCorrection[] RecipientCorrection;
        private String[] RecipientCorrection_type_info = new String[]{'RecipientCorrection','http://www.docusign.net/API/3.0','RecipientCorrection','0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'RecipientCorrection'};
    }
    public class APIServiceSoap {
        public String endpoint_x = 'http://www.docusign.net/api/3.0/dsapi.asmx';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'http://www.docusign.net/API/3.0', 'DocuSignAPI'};
        public DocuSignAPI.AccountSettingsList GetAccountSettingsList(String AccountId) {
            DocuSignAPI.GetAccountSettingsList_element request_x = new DocuSignAPI.GetAccountSettingsList_element();
            DocuSignAPI.GetAccountSettingsListResponse_element response_x;
            request_x.AccountId = AccountId;
            Map<String, DocuSignAPI.GetAccountSettingsListResponse_element> response_map_x = new Map<String, DocuSignAPI.GetAccountSettingsListResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://www.docusign.net/API/3.0/GetAccountSettingsList',
              'http://www.docusign.net/API/3.0',
              'GetAccountSettingsList',
              'http://www.docusign.net/API/3.0',
              'GetAccountSettingsListResponse',
              'DocuSignAPI.GetAccountSettingsListResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.GetAccountSettingsListResult;
        }
        public DocuSignAPI.EnvelopeStatus RequestStatusEx(String EnvelopeID) {
            DocuSignAPI.RequestStatusEx_element request_x = new DocuSignAPI.RequestStatusEx_element();
            DocuSignAPI.RequestStatusExResponse_element response_x;
            request_x.EnvelopeID = EnvelopeID;
            Map<String, DocuSignAPI.RequestStatusExResponse_element> response_map_x = new Map<String, DocuSignAPI.RequestStatusExResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://www.docusign.net/API/3.0/RequestStatusEx',
              'http://www.docusign.net/API/3.0',
              'RequestStatusEx',
              'http://www.docusign.net/API/3.0',
              'RequestStatusExResponse',
              'DocuSignAPI.RequestStatusExResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.RequestStatusExResult;
        }
        public DocuSignAPI.ArrayOfAddressBookItem GetAddressBookItems(String AccountID) {
            DocuSignAPI.GetAddressBookItems_element request_x = new DocuSignAPI.GetAddressBookItems_element();
            DocuSignAPI.GetAddressBookItemsResponse_element response_x;
            request_x.AccountID = AccountID;
            Map<String, DocuSignAPI.GetAddressBookItemsResponse_element> response_map_x = new Map<String, DocuSignAPI.GetAddressBookItemsResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://www.docusign.net/API/3.0/GetAddressBookItems',
              'http://www.docusign.net/API/3.0',
              'GetAddressBookItems',
              'http://www.docusign.net/API/3.0',
              'GetAddressBookItemsResponse',
              'DocuSignAPI.GetAddressBookItemsResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.GetAddressBookItemsResult;
        }
        public DocuSignAPI.ArrayOfPublishConnectFailuresResult PublishConnectFailures(DocuSignAPI.PublishConnectFailuresFilter PublishConnectFailuresFilter) {
            DocuSignAPI.PublishConnectFailures_element request_x = new DocuSignAPI.PublishConnectFailures_element();
            DocuSignAPI.PublishConnectFailuresResponse_element response_x;
            request_x.PublishConnectFailuresFilter = PublishConnectFailuresFilter;
            Map<String, DocuSignAPI.PublishConnectFailuresResponse_element> response_map_x = new Map<String, DocuSignAPI.PublishConnectFailuresResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://www.docusign.net/API/3.0/PublishConnectFailures',
              'http://www.docusign.net/API/3.0',
              'PublishConnectFailures',
              'http://www.docusign.net/API/3.0',
              'PublishConnectFailuresResponse',
              'DocuSignAPI.PublishConnectFailuresResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.PublishConnectFailuresResult;
        }
        public DocuSignAPI.DocuSignEnvelopeInformation GetStatusInDocuSignConnectFormat(String EnvelopeID) {
            DocuSignAPI.GetStatusInDocuSignConnectFormat_element request_x = new DocuSignAPI.GetStatusInDocuSignConnectFormat_element();
            DocuSignAPI.GetStatusInDocuSignConnectFormatResponse_element response_x;
            request_x.EnvelopeID = EnvelopeID;
            Map<String, DocuSignAPI.GetStatusInDocuSignConnectFormatResponse_element> response_map_x = new Map<String, DocuSignAPI.GetStatusInDocuSignConnectFormatResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://www.docusign.net/API/3.0/GetStatusInDocuSignConnectFormat',
              'http://www.docusign.net/API/3.0',
              'GetStatusInDocuSignConnectFormat',
              'http://www.docusign.net/API/3.0',
              'GetStatusInDocuSignConnectFormatResponse',
              'DocuSignAPI.GetStatusInDocuSignConnectFormatResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.GetStatusInDocuSignConnectFormatResult;
        }
        public DocuSignAPI.PurgeDocumentStatus PurgeDocuments(String EnvelopeID) {
            DocuSignAPI.PurgeDocuments_element request_x = new DocuSignAPI.PurgeDocuments_element();
            DocuSignAPI.PurgeDocumentsResponse_element response_x;
            request_x.EnvelopeID = EnvelopeID;
            Map<String, DocuSignAPI.PurgeDocumentsResponse_element> response_map_x = new Map<String, DocuSignAPI.PurgeDocumentsResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://www.docusign.net/API/3.0/PurgeDocuments',
              'http://www.docusign.net/API/3.0',
              'PurgeDocuments',
              'http://www.docusign.net/API/3.0',
              'PurgeDocumentsResponse',
              'DocuSignAPI.PurgeDocumentsResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.PurgeDocumentsResult;
        }
        public DocuSignAPI.EnvelopePDF RequestPDF(String EnvelopeID) {
            DocuSignAPI.RequestPDF_element request_x = new DocuSignAPI.RequestPDF_element();
            DocuSignAPI.RequestPDFResponse_element response_x;
            request_x.EnvelopeID = EnvelopeID;
            Map<String, DocuSignAPI.RequestPDFResponse_element> response_map_x = new Map<String, DocuSignAPI.RequestPDFResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://www.docusign.net/API/3.0/RequestPDF',
              'http://www.docusign.net/API/3.0',
              'RequestPDF',
              'http://www.docusign.net/API/3.0',
              'RequestPDFResponse',
              'DocuSignAPI.RequestPDFResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.RequestPDFResult;
        }
        public DocuSignAPI.EnvelopePDF RequestPDFWithCert(String EnvelopeID,Boolean AddWaterMark) {
            DocuSignAPI.RequestPDFWithCert_element request_x = new DocuSignAPI.RequestPDFWithCert_element();
            DocuSignAPI.RequestPDFWithCertResponse_element response_x;
            request_x.EnvelopeID = EnvelopeID;
            request_x.AddWaterMark = AddWaterMark;
            Map<String, DocuSignAPI.RequestPDFWithCertResponse_element> response_map_x = new Map<String, DocuSignAPI.RequestPDFWithCertResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://www.docusign.net/API/3.0/RequestPDFWithCert',
              'http://www.docusign.net/API/3.0',
              'RequestPDFWithCert',
              'http://www.docusign.net/API/3.0',
              'RequestPDFWithCertResponse',
              'DocuSignAPI.RequestPDFWithCertResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.RequestPDFWithCertResult;
        }
        public DocuSignAPI.VoidEnvelopeStatus VoidEnvelope(String EnvelopeID,String Reason) {
            DocuSignAPI.VoidEnvelope_element request_x = new DocuSignAPI.VoidEnvelope_element();
            DocuSignAPI.VoidEnvelopeResponse_element response_x;
            request_x.EnvelopeID = EnvelopeID;
            request_x.Reason = Reason;
            Map<String, DocuSignAPI.VoidEnvelopeResponse_element> response_map_x = new Map<String, DocuSignAPI.VoidEnvelopeResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://www.docusign.net/API/3.0/VoidEnvelope',
              'http://www.docusign.net/API/3.0',
              'VoidEnvelope',
              'http://www.docusign.net/API/3.0',
              'VoidEnvelopeResponse',
              'DocuSignAPI.VoidEnvelopeResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.VoidEnvelopeResult;
        }
        public DocuSignAPI.FilteredEnvelopeStatuses RequestStatusesEx(DocuSignAPI.EnvelopeStatusFilter EnvelopeStatusFilter) {
            DocuSignAPI.RequestStatusesEx_element request_x = new DocuSignAPI.RequestStatusesEx_element();
            DocuSignAPI.RequestStatusesExResponse_element response_x;
            request_x.EnvelopeStatusFilter = EnvelopeStatusFilter;
            Map<String, DocuSignAPI.RequestStatusesExResponse_element> response_map_x = new Map<String, DocuSignAPI.RequestStatusesExResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://www.docusign.net/API/3.0/RequestStatusesEx',
              'http://www.docusign.net/API/3.0',
              'RequestStatusesEx',
              'http://www.docusign.net/API/3.0',
              'RequestStatusesExResponse',
              'DocuSignAPI.RequestStatusesExResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.RequestStatusesExResult;
        }
        public DocuSignAPI.TransferEnvelopeStatus TransferEnvelope(String EnvelopeID,String AccountID,String UserID) {
            DocuSignAPI.TransferEnvelope_element request_x = new DocuSignAPI.TransferEnvelope_element();
            DocuSignAPI.TransferEnvelopeResponse_element response_x;
            request_x.EnvelopeID = EnvelopeID;
            request_x.AccountID = AccountID;
            request_x.UserID = UserID;
            Map<String, DocuSignAPI.TransferEnvelopeResponse_element> response_map_x = new Map<String, DocuSignAPI.TransferEnvelopeResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://www.docusign.net/API/3.0/TransferEnvelope',
              'http://www.docusign.net/API/3.0',
              'TransferEnvelope',
              'http://www.docusign.net/API/3.0',
              'TransferEnvelopeResponse',
              'DocuSignAPI.TransferEnvelopeResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.TransferEnvelopeResult;
        }
        public DocuSignAPI.AuthoritativeCopyExportDocuments ExportAuthoritativeCopy(String EnvelopeId) {
            DocuSignAPI.ExportAuthoritativeCopy_element request_x = new DocuSignAPI.ExportAuthoritativeCopy_element();
            DocuSignAPI.ExportAuthoritativeCopyResponse_element response_x;
            request_x.EnvelopeId = EnvelopeId;
            Map<String, DocuSignAPI.ExportAuthoritativeCopyResponse_element> response_map_x = new Map<String, DocuSignAPI.ExportAuthoritativeCopyResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://www.docusign.net/API/3.0/ExportAuthoritativeCopy',
              'http://www.docusign.net/API/3.0',
              'ExportAuthoritativeCopy',
              'http://www.docusign.net/API/3.0',
              'ExportAuthoritativeCopyResponse',
              'DocuSignAPI.ExportAuthoritativeCopyResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.ExportAuthoritativeCopyResult;
        }
        public DocuSignAPI.EnvelopeStatus CreateEnvelopeFromTemplatesAndForms(DocuSignAPI.EnvelopeInformation EnvelopeInformation,DocuSignAPI.ArrayOfCompositeTemplate CompositeTemplates,Boolean ActivateEnvelope) {
            DocuSignAPI.CreateEnvelopeFromTemplatesAndForms_element request_x = new DocuSignAPI.CreateEnvelopeFromTemplatesAndForms_element();
            DocuSignAPI.CreateEnvelopeFromTemplatesAndFormsResponse_element response_x;
            request_x.EnvelopeInformation = EnvelopeInformation;
            request_x.CompositeTemplates = CompositeTemplates;
            request_x.ActivateEnvelope = ActivateEnvelope;
            Map<String, DocuSignAPI.CreateEnvelopeFromTemplatesAndFormsResponse_element> response_map_x = new Map<String, DocuSignAPI.CreateEnvelopeFromTemplatesAndFormsResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://www.docusign.net/API/3.0/CreateEnvelopeFromTemplatesAndForms',
              'http://www.docusign.net/API/3.0',
              'CreateEnvelopeFromTemplatesAndForms',
              'http://www.docusign.net/API/3.0',
              'CreateEnvelopeFromTemplatesAndFormsResponse',
              'DocuSignAPI.CreateEnvelopeFromTemplatesAndFormsResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.CreateEnvelopeFromTemplatesAndFormsResult;
        }
        public DocuSignAPI.ArrayOfEnvelopeTemplate RequestTemplateList(DocuSignAPI.ArrayOfString5 TemplateIDs,Boolean IncludeDocumentBytes) {
            DocuSignAPI.RequestTemplateList_element request_x = new DocuSignAPI.RequestTemplateList_element();
            DocuSignAPI.RequestTemplateListResponse_element response_x;
            request_x.TemplateIDs = TemplateIDs;
            request_x.IncludeDocumentBytes = IncludeDocumentBytes;
            Map<String, DocuSignAPI.RequestTemplateListResponse_element> response_map_x = new Map<String, DocuSignAPI.RequestTemplateListResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://www.docusign.net/API/3.0/RequestTemplateList',
              'http://www.docusign.net/API/3.0',
              'RequestTemplateList',
              'http://www.docusign.net/API/3.0',
              'RequestTemplateListResponse',
              'DocuSignAPI.RequestTemplateListResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.RequestTemplateListResult;
        }
        public DocuSignAPI.RecipientEsignList GetRecipientEsignList(String UserName,String SenderEmail,String SenderAccountId,String RecipientEmail) {
            DocuSignAPI.GetRecipientEsignList_element request_x = new DocuSignAPI.GetRecipientEsignList_element();
            DocuSignAPI.GetRecipientEsignListResponse_element response_x;
            request_x.UserName = UserName;
            request_x.SenderEmail = SenderEmail;
            request_x.SenderAccountId = SenderAccountId;
            request_x.RecipientEmail = RecipientEmail;
            Map<String, DocuSignAPI.GetRecipientEsignListResponse_element> response_map_x = new Map<String, DocuSignAPI.GetRecipientEsignListResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://www.docusign.net/API/3.0/GetRecipientEsignList',
              'http://www.docusign.net/API/3.0',
              'GetRecipientEsignList',
              'http://www.docusign.net/API/3.0',
              'GetRecipientEsignListResponse',
              'DocuSignAPI.GetRecipientEsignListResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.GetRecipientEsignListResult;
        }
        public DocuSignAPI.EnvelopeStatus CreateEnvelope(DocuSignAPI.Envelope Envelope) {
            DocuSignAPI.CreateEnvelope_element request_x = new DocuSignAPI.CreateEnvelope_element();
            DocuSignAPI.CreateEnvelopeResponse_element response_x;
            request_x.Envelope = Envelope;
            Map<String, DocuSignAPI.CreateEnvelopeResponse_element> response_map_x = new Map<String, DocuSignAPI.CreateEnvelopeResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://www.docusign.net/API/3.0/CreateEnvelope',
              'http://www.docusign.net/API/3.0',
              'CreateEnvelope',
              'http://www.docusign.net/API/3.0',
              'CreateEnvelopeResponse',
              'DocuSignAPI.CreateEnvelopeResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.CreateEnvelopeResult;
        }
        public DocuSignAPI.EnvelopeTemplates RequestTemplates(String AccountID,Boolean IncludeAdvancedTemplates) {
            DocuSignAPI.RequestTemplates_element request_x = new DocuSignAPI.RequestTemplates_element();
            DocuSignAPI.RequestTemplatesResponse_element response_x;
            request_x.AccountID = AccountID;
            request_x.IncludeAdvancedTemplates = IncludeAdvancedTemplates;
            Map<String, DocuSignAPI.RequestTemplatesResponse_element> response_map_x = new Map<String, DocuSignAPI.RequestTemplatesResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://www.docusign.net/API/3.0/RequestTemplates',
              'http://www.docusign.net/API/3.0',
              'RequestTemplates',
              'http://www.docusign.net/API/3.0',
              'RequestTemplatesResponse',
              'DocuSignAPI.RequestTemplatesResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.RequestTemplatesResult;
        }
        public DocuSignAPI.SynchEnvelopeStatus SynchEnvelope(String TransactionID,String AccountID,Boolean Block) {
            DocuSignAPI.SynchEnvelope_element request_x = new DocuSignAPI.SynchEnvelope_element();
            DocuSignAPI.SynchEnvelopeResponse_element response_x;
            request_x.TransactionID = TransactionID;
            request_x.AccountID = AccountID;
            request_x.Block = Block;
            Map<String, DocuSignAPI.SynchEnvelopeResponse_element> response_map_x = new Map<String, DocuSignAPI.SynchEnvelopeResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://www.docusign.net/API/3.0/SynchEnvelope',
              'http://www.docusign.net/API/3.0',
              'SynchEnvelope',
              'http://www.docusign.net/API/3.0',
              'SynchEnvelopeResponse',
              'DocuSignAPI.SynchEnvelopeResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.SynchEnvelopeResult;
        }
        public DocuSignAPI.EnvelopeStatus RequestStatus(String EnvelopeID) {
            DocuSignAPI.RequestStatus_element request_x = new DocuSignAPI.RequestStatus_element();
            DocuSignAPI.RequestStatusResponse_element response_x;
            request_x.EnvelopeID = EnvelopeID;
            Map<String, DocuSignAPI.RequestStatusResponse_element> response_map_x = new Map<String, DocuSignAPI.RequestStatusResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://www.docusign.net/API/3.0/RequestStatus',
              'http://www.docusign.net/API/3.0',
              'RequestStatus',
              'http://www.docusign.net/API/3.0',
              'RequestStatusResponse',
              'DocuSignAPI.RequestStatusResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.RequestStatusResult;
        }
        public String RequestSenderToken(String EnvelopeID,String AccountID,String ReturnURL) {
            DocuSignAPI.RequestSenderToken_element request_x = new DocuSignAPI.RequestSenderToken_element();
            DocuSignAPI.RequestSenderTokenResponse_element response_x;
            request_x.EnvelopeID = EnvelopeID;
            request_x.AccountID = AccountID;
            request_x.ReturnURL = ReturnURL;
            Map<String, DocuSignAPI.RequestSenderTokenResponse_element> response_map_x = new Map<String, DocuSignAPI.RequestSenderTokenResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://www.docusign.net/API/3.0/RequestSenderToken',
              'http://www.docusign.net/API/3.0',
              'RequestSenderToken',
              'http://www.docusign.net/API/3.0',
              'RequestSenderTokenResponse',
              'DocuSignAPI.RequestSenderTokenResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.RequestSenderTokenResult;
        }
        public DocuSignAPI.AuthoritativeCopyExportStatus AcknowledgeAuthoritativeCopyExport(String EnvelopeId,String TransactionId,String checkSumHash) {
            DocuSignAPI.AcknowledgeAuthoritativeCopyExport_element request_x = new DocuSignAPI.AcknowledgeAuthoritativeCopyExport_element();
            DocuSignAPI.AcknowledgeAuthoritativeCopyExportResponse_element response_x;
            request_x.EnvelopeId = EnvelopeId;
            request_x.TransactionId = TransactionId;
            request_x.checkSumHash = checkSumHash;
            Map<String, DocuSignAPI.AcknowledgeAuthoritativeCopyExportResponse_element> response_map_x = new Map<String, DocuSignAPI.AcknowledgeAuthoritativeCopyExportResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://www.docusign.net/API/3.0/AcknowledgeAuthoritativeCopyExport',
              'http://www.docusign.net/API/3.0',
              'AcknowledgeAuthoritativeCopyExport',
              'http://www.docusign.net/API/3.0',
              'AcknowledgeAuthoritativeCopyExportResponse',
              'DocuSignAPI.AcknowledgeAuthoritativeCopyExportResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.AcknowledgeAuthoritativeCopyExportResult;
        }
        public DocuSignAPI.ArrayOfConnectFailure GetConnectFailures(DocuSignAPI.ConnectFailuresFilter ConnectFailuresFilter) {
            DocuSignAPI.GetConnectFailures_element request_x = new DocuSignAPI.GetConnectFailures_element();
            DocuSignAPI.GetConnectFailuresResponse_element response_x;
            request_x.ConnectFailuresFilter = ConnectFailuresFilter;
            Map<String, DocuSignAPI.GetConnectFailuresResponse_element> response_map_x = new Map<String, DocuSignAPI.GetConnectFailuresResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://www.docusign.net/API/3.0/GetConnectFailures',
              'http://www.docusign.net/API/3.0',
              'GetConnectFailures',
              'http://www.docusign.net/API/3.0',
              'GetConnectFailuresResponse',
              'DocuSignAPI.GetConnectFailuresResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.GetConnectFailuresResult;
        }
        public DocuSignAPI.UpdateAddressBookResult RemoveAddressBookItems(DocuSignAPI.ArrayOfAddressBookRemoveItem AddressBookRemoveItems,Boolean ReturnAddressBook) {
            DocuSignAPI.RemoveAddressBookItems_element request_x = new DocuSignAPI.RemoveAddressBookItems_element();
            DocuSignAPI.RemoveAddressBookItemsResponse_element response_x;
            request_x.AddressBookRemoveItems = AddressBookRemoveItems;
            request_x.ReturnAddressBook = ReturnAddressBook;
            Map<String, DocuSignAPI.RemoveAddressBookItemsResponse_element> response_map_x = new Map<String, DocuSignAPI.RemoveAddressBookItemsResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://www.docusign.net/API/3.0/RemoveAddressBookItems',
              'http://www.docusign.net/API/3.0',
              'RemoveAddressBookItems',
              'http://www.docusign.net/API/3.0',
              'RemoveAddressBookItemsResponse',
              'DocuSignAPI.RemoveAddressBookItemsResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.RemoveAddressBookItemsResult;
        }
        public DocuSignAPI.FilteredEnvelopeStatuses RequestStatuses(DocuSignAPI.EnvelopeStatusFilter EnvelopeStatusFilter) {
            DocuSignAPI.RequestStatuses_element request_x = new DocuSignAPI.RequestStatuses_element();
            DocuSignAPI.RequestStatusesResponse_element response_x;
            request_x.EnvelopeStatusFilter = EnvelopeStatusFilter;
            Map<String, DocuSignAPI.RequestStatusesResponse_element> response_map_x = new Map<String, DocuSignAPI.RequestStatusesResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://www.docusign.net/API/3.0/RequestStatuses',
              'http://www.docusign.net/API/3.0',
              'RequestStatuses',
              'http://www.docusign.net/API/3.0',
              'RequestStatusesResponse',
              'DocuSignAPI.RequestStatusesResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.RequestStatusesResult;
        }
        public Boolean Ping() {
            DocuSignAPI.Ping_element request_x = new DocuSignAPI.Ping_element();
            DocuSignAPI.PingResponse_element response_x;
            Map<String, DocuSignAPI.PingResponse_element> response_map_x = new Map<String, DocuSignAPI.PingResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://www.docusign.net/API/3.0/Ping',
              'http://www.docusign.net/API/3.0',
              'Ping',
              'http://www.docusign.net/API/3.0',
              'PingResponse',
              'DocuSignAPI.PingResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.PingResult;
        }
        public DocuSignAPI.BrandResults DeleteAccountBrands(String AccountId,DocuSignAPI.BrandDeleteRequest BrandDeleteRequest) {
            DocuSignAPI.DeleteAccountBrands_element request_x = new DocuSignAPI.DeleteAccountBrands_element();
            DocuSignAPI.DeleteAccountBrandsResponse_element response_x;
            request_x.AccountId = AccountId;
            request_x.BrandDeleteRequest = BrandDeleteRequest;
            Map<String, DocuSignAPI.DeleteAccountBrandsResponse_element> response_map_x = new Map<String, DocuSignAPI.DeleteAccountBrandsResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://www.docusign.net/API/3.0/DeleteAccountBrands',
              'http://www.docusign.net/API/3.0',
              'DeleteAccountBrands',
              'http://www.docusign.net/API/3.0',
              'DeleteAccountBrandsResponse',
              'DocuSignAPI.DeleteAccountBrandsResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.DeleteAccountBrandsResult;
        }
        public DocuSignAPI.DocumentPDFs RequestDocumentPDFs(String EnvelopeID) {
            DocuSignAPI.RequestDocumentPDFs_element request_x = new DocuSignAPI.RequestDocumentPDFs_element();
            DocuSignAPI.RequestDocumentPDFsResponse_element response_x;
            request_x.EnvelopeID = EnvelopeID;
            Map<String, DocuSignAPI.RequestDocumentPDFsResponse_element> response_map_x = new Map<String, DocuSignAPI.RequestDocumentPDFsResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://www.docusign.net/API/3.0/RequestDocumentPDFs',
              'http://www.docusign.net/API/3.0',
              'RequestDocumentPDFs',
              'http://www.docusign.net/API/3.0',
              'RequestDocumentPDFsResponse',
              'DocuSignAPI.RequestDocumentPDFsResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.RequestDocumentPDFsResult;
        }
        public DocuSignAPI.BrandResults CreateAccountBrands(String AccountId,DocuSignAPI.BrandDefinitions BrandDefinitions) {
            DocuSignAPI.CreateAccountBrands_element request_x = new DocuSignAPI.CreateAccountBrands_element();
            DocuSignAPI.CreateAccountBrandsResponse_element response_x;
            request_x.AccountId = AccountId;
            request_x.BrandDefinitions = BrandDefinitions;
            Map<String, DocuSignAPI.CreateAccountBrandsResponse_element> response_map_x = new Map<String, DocuSignAPI.CreateAccountBrandsResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://www.docusign.net/API/3.0/CreateAccountBrands',
              'http://www.docusign.net/API/3.0',
              'CreateAccountBrands',
              'http://www.docusign.net/API/3.0',
              'CreateAccountBrandsResponse',
              'DocuSignAPI.CreateAccountBrandsResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.CreateAccountBrandsResult;
        }
        public DocuSignAPI.RecipientList GetRecipientList(String SenderAccountId,String RecipientEmail) {
            DocuSignAPI.GetRecipientList_element request_x = new DocuSignAPI.GetRecipientList_element();
            DocuSignAPI.GetRecipientListResponse_element response_x;
            request_x.SenderAccountId = SenderAccountId;
            request_x.RecipientEmail = RecipientEmail;
            Map<String, DocuSignAPI.GetRecipientListResponse_element> response_map_x = new Map<String, DocuSignAPI.GetRecipientListResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://www.docusign.net/API/3.0/GetRecipientList',
              'http://www.docusign.net/API/3.0',
              'GetRecipientList',
              'http://www.docusign.net/API/3.0',
              'GetRecipientListResponse',
              'DocuSignAPI.GetRecipientListResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.GetRecipientListResult;
        }
        public DocuSignAPI.FilteredEnvelopeStatusChanges RequestStatusChanges(DocuSignAPI.EnvelopeStatusChangeFilter EnvelopeStatusChangeFilter) {
            DocuSignAPI.RequestStatusChanges_element request_x = new DocuSignAPI.RequestStatusChanges_element();
            DocuSignAPI.RequestStatusChangesResponse_element response_x;
            request_x.EnvelopeStatusChangeFilter = EnvelopeStatusChangeFilter;
            Map<String, DocuSignAPI.RequestStatusChangesResponse_element> response_map_x = new Map<String, DocuSignAPI.RequestStatusChangesResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://www.docusign.net/API/3.0/RequestStatusChanges',
              'http://www.docusign.net/API/3.0',
              'RequestStatusChanges',
              'http://www.docusign.net/API/3.0',
              'RequestStatusChangesResponse',
              'DocuSignAPI.RequestStatusChangesResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.RequestStatusChangesResult;
        }
        public Boolean DeleteEnvelopes(DocuSignAPI.DeleteEnvelopesArg Arg) {
            DocuSignAPI.DeleteEnvelopes_element request_x = new DocuSignAPI.DeleteEnvelopes_element();
            DocuSignAPI.DeleteEnvelopesResponse_element response_x;
            request_x.Arg = Arg;
            Map<String, DocuSignAPI.DeleteEnvelopesResponse_element> response_map_x = new Map<String, DocuSignAPI.DeleteEnvelopesResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://www.docusign.net/API/3.0/DeleteEnvelopes',
              'http://www.docusign.net/API/3.0',
              'DeleteEnvelopes',
              'http://www.docusign.net/API/3.0',
              'DeleteEnvelopesResponse',
              'DocuSignAPI.DeleteEnvelopesResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.DeleteEnvelopesResult;
        }
        public String GetAuthenticationToken(String GoToEnvelopeID) {
            DocuSignAPI.GetAuthenticationToken_element request_x = new DocuSignAPI.GetAuthenticationToken_element();
            DocuSignAPI.GetAuthenticationTokenResponse_element response_x;
            request_x.GoToEnvelopeID = GoToEnvelopeID;
            Map<String, DocuSignAPI.GetAuthenticationTokenResponse_element> response_map_x = new Map<String, DocuSignAPI.GetAuthenticationTokenResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://www.docusign.net/API/3.0/GetAuthenticationToken',
              'http://www.docusign.net/API/3.0',
              'GetAuthenticationToken',
              'http://www.docusign.net/API/3.0',
              'GetAuthenticationTokenResponse',
              'DocuSignAPI.GetAuthenticationTokenResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.GetAuthenticationTokenResult;
        }
        public DocuSignAPI.EnvelopePDF RequestPDFNoWaterMark(String EnvelopeID) {
            DocuSignAPI.RequestPDFNoWaterMark_element request_x = new DocuSignAPI.RequestPDFNoWaterMark_element();
            DocuSignAPI.RequestPDFNoWaterMarkResponse_element response_x;
            request_x.EnvelopeID = EnvelopeID;
            Map<String, DocuSignAPI.RequestPDFNoWaterMarkResponse_element> response_map_x = new Map<String, DocuSignAPI.RequestPDFNoWaterMarkResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://www.docusign.net/API/3.0/RequestPDFNoWaterMark',
              'http://www.docusign.net/API/3.0',
              'RequestPDFNoWaterMark',
              'http://www.docusign.net/API/3.0',
              'RequestPDFNoWaterMarkResponse',
              'DocuSignAPI.RequestPDFNoWaterMarkResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.RequestPDFNoWaterMarkResult;
        }
        public String RequestRecipientToken(String EnvelopeID,String ClientUserID,String Username,String Email,DocuSignAPI.RequestRecipientTokenAuthenticationAssertion AuthenticationAssertion,DocuSignAPI.RequestRecipientTokenClientURLs ClientURLs) {
            DocuSignAPI.RequestRecipientToken_element request_x = new DocuSignAPI.RequestRecipientToken_element();
            DocuSignAPI.RequestRecipientTokenResponse_element response_x;
            request_x.EnvelopeID = EnvelopeID;
            request_x.ClientUserID = ClientUserID;
            request_x.Username = Username;
            request_x.Email = Email;
            request_x.AuthenticationAssertion = AuthenticationAssertion;
            request_x.ClientURLs = ClientURLs;
            Map<String, DocuSignAPI.RequestRecipientTokenResponse_element> response_map_x = new Map<String, DocuSignAPI.RequestRecipientTokenResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://www.docusign.net/API/3.0/RequestRecipientToken',
              'http://www.docusign.net/API/3.0',
              'RequestRecipientToken',
              'http://www.docusign.net/API/3.0',
              'RequestRecipientTokenResponse',
              'DocuSignAPI.RequestRecipientTokenResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.RequestRecipientTokenResult;
        }
        public DocuSignAPI.UpdateAddressBookResult UpdateAddressBookItems(DocuSignAPI.ArrayOfAddressBookItem AddressBookItems,Boolean ReturnAddressBook) {
            DocuSignAPI.UpdateAddressBookItems_element request_x = new DocuSignAPI.UpdateAddressBookItems_element();
            DocuSignAPI.UpdateAddressBookItemsResponse_element response_x;
            request_x.AddressBookItems = AddressBookItems;
            request_x.ReturnAddressBook = ReturnAddressBook;
            Map<String, DocuSignAPI.UpdateAddressBookItemsResponse_element> response_map_x = new Map<String, DocuSignAPI.UpdateAddressBookItemsResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://www.docusign.net/API/3.0/UpdateAddressBookItems',
              'http://www.docusign.net/API/3.0',
              'UpdateAddressBookItems',
              'http://www.docusign.net/API/3.0',
              'UpdateAddressBookItemsResponse',
              'DocuSignAPI.UpdateAddressBookItemsResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.UpdateAddressBookItemsResult;
        }
        public DocuSignAPI.EnvelopeAuditEventsResult_element EnvelopeAuditEvents(String EnvelopeId) {
            DocuSignAPI.EnvelopeAuditEvents_element request_x = new DocuSignAPI.EnvelopeAuditEvents_element();
            DocuSignAPI.EnvelopeAuditEventsResponse_element response_x;
            request_x.EnvelopeId = EnvelopeId;
            Map<String, DocuSignAPI.EnvelopeAuditEventsResponse_element> response_map_x = new Map<String, DocuSignAPI.EnvelopeAuditEventsResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://www.docusign.net/API/3.0/EnvelopeAuditEvents',
              'http://www.docusign.net/API/3.0',
              'EnvelopeAuditEvents',
              'http://www.docusign.net/API/3.0',
              'EnvelopeAuditEventsResponse',
              'DocuSignAPI.EnvelopeAuditEventsResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.EnvelopeAuditEventsResult;
        }
        public DocuSignAPI.SaveTemplateResult SaveTemplate(DocuSignAPI.EnvelopeTemplate EnvelopeTemplate) {
            DocuSignAPI.SaveTemplate_element request_x = new DocuSignAPI.SaveTemplate_element();
            DocuSignAPI.SaveTemplateResponse_element response_x;
            request_x.EnvelopeTemplate = EnvelopeTemplate;
            Map<String, DocuSignAPI.SaveTemplateResponse_element> response_map_x = new Map<String, DocuSignAPI.SaveTemplateResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://www.docusign.net/API/3.0/SaveTemplate',
              'http://www.docusign.net/API/3.0',
              'SaveTemplate',
              'http://www.docusign.net/API/3.0',
              'SaveTemplateResponse',
              'DocuSignAPI.SaveTemplateResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.SaveTemplateResult;
        }
        public DocuSignAPI.EnvelopeStatus CreateAndSendEnvelope(DocuSignAPI.Envelope Envelope) {
            DocuSignAPI.CreateAndSendEnvelope_element request_x = new DocuSignAPI.CreateAndSendEnvelope_element();
            DocuSignAPI.CreateAndSendEnvelopeResponse_element response_x;
            request_x.timeout_x = 120000;
            request_x.Envelope = Envelope;
            Map<String, DocuSignAPI.CreateAndSendEnvelopeResponse_element> response_map_x = new Map<String, DocuSignAPI.CreateAndSendEnvelopeResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://www.docusign.net/API/3.0/CreateAndSendEnvelope',
              'http://www.docusign.net/API/3.0',
              'CreateAndSendEnvelope',
              'http://www.docusign.net/API/3.0',
              'CreateAndSendEnvelopeResponse',
              'DocuSignAPI.CreateAndSendEnvelopeResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.CreateAndSendEnvelopeResult;
        }
        public DocuSignAPI.DocumentPDFs RequestDocumentPDFsEx(String EnvelopeID) {
            DocuSignAPI.RequestDocumentPDFsEx_element request_x = new DocuSignAPI.RequestDocumentPDFsEx_element();
            DocuSignAPI.RequestDocumentPDFsExResponse_element response_x;
            request_x.EnvelopeID = EnvelopeID;
            Map<String, DocuSignAPI.RequestDocumentPDFsExResponse_element> response_map_x = new Map<String, DocuSignAPI.RequestDocumentPDFsExResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://www.docusign.net/API/3.0/RequestDocumentPDFsEx',
              'http://www.docusign.net/API/3.0',
              'RequestDocumentPDFsEx',
              'http://www.docusign.net/API/3.0',
              'RequestDocumentPDFsExResponse',
              'DocuSignAPI.RequestDocumentPDFsExResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.RequestDocumentPDFsExResult;
        }
        public DocuSignAPI.EnvelopePDF RequestPDFWithOptions(String EnvelopeID,DocuSignAPI.PDFOptions PDFOptions) {
            DocuSignAPI.RequestPDFWithOptions_element request_x = new DocuSignAPI.RequestPDFWithOptions_element();
            DocuSignAPI.RequestPDFWithOptionsResponse_element response_x;
            request_x.EnvelopeID = EnvelopeID;
            request_x.PDFOptions = PDFOptions;
            Map<String, DocuSignAPI.RequestPDFWithOptionsResponse_element> response_map_x = new Map<String, DocuSignAPI.RequestPDFWithOptionsResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://www.docusign.net/API/3.0/RequestPDFWithOptions',
              'http://www.docusign.net/API/3.0',
              'RequestPDFWithOptions',
              'http://www.docusign.net/API/3.0',
              'RequestPDFWithOptionsResponse',
              'DocuSignAPI.RequestPDFWithOptionsResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.RequestPDFWithOptionsResult;
        }
        public DocuSignAPI.SaveTemplateResult UploadTemplate(String TemplateXML,String AccountID,Boolean Shared) {
            DocuSignAPI.UploadTemplate_element request_x = new DocuSignAPI.UploadTemplate_element();
            DocuSignAPI.UploadTemplateResponse_element response_x;
            request_x.TemplateXML = TemplateXML;
            request_x.AccountID = AccountID;
            request_x.Shared = Shared;
            Map<String, DocuSignAPI.UploadTemplateResponse_element> response_map_x = new Map<String, DocuSignAPI.UploadTemplateResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://www.docusign.net/API/3.0/UploadTemplate',
              'http://www.docusign.net/API/3.0',
              'UploadTemplate',
              'http://www.docusign.net/API/3.0',
              'UploadTemplateResponse',
              'DocuSignAPI.UploadTemplateResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.UploadTemplateResult;
        }
        public Boolean MoveEnvelopes(DocuSignAPI.MoveEnvelopesArg Arg) {
            DocuSignAPI.MoveEnvelopes_element request_x = new DocuSignAPI.MoveEnvelopes_element();
            DocuSignAPI.MoveEnvelopesResponse_element response_x;
            request_x.Arg = Arg;
            Map<String, DocuSignAPI.MoveEnvelopesResponse_element> response_map_x = new Map<String, DocuSignAPI.MoveEnvelopesResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://www.docusign.net/API/3.0/MoveEnvelopes',
              'http://www.docusign.net/API/3.0',
              'MoveEnvelopes',
              'http://www.docusign.net/API/3.0',
              'MoveEnvelopesResponse',
              'DocuSignAPI.MoveEnvelopesResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.MoveEnvelopesResult;
        }
        public DocuSignAPI.DocumentPDFs RequestPDFsWithOptions(String EnvelopeID,DocuSignAPI.PDFsOptions PDFsOptions) {
            DocuSignAPI.RequestPDFsWithOptions_element request_x = new DocuSignAPI.RequestPDFsWithOptions_element();
            DocuSignAPI.RequestPDFsWithOptionsResponse_element response_x;
            request_x.EnvelopeID = EnvelopeID;
            request_x.PDFsOptions = PDFsOptions;
            Map<String, DocuSignAPI.RequestPDFsWithOptionsResponse_element> response_map_x = new Map<String, DocuSignAPI.RequestPDFsWithOptionsResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://www.docusign.net/API/3.0/RequestPDFsWithOptions',
              'http://www.docusign.net/API/3.0',
              'RequestPDFsWithOptions',
              'http://www.docusign.net/API/3.0',
              'RequestPDFsWithOptionsResponse',
              'DocuSignAPI.RequestPDFsWithOptionsResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.RequestPDFsWithOptionsResult;
        }
        public DocuSignAPI.BrandResults GetAccountBrands(String AccountId) {
            DocuSignAPI.GetAccountBrands_element request_x = new DocuSignAPI.GetAccountBrands_element();
            DocuSignAPI.GetAccountBrandsResponse_element response_x;
            request_x.AccountId = AccountId;
            Map<String, DocuSignAPI.GetAccountBrandsResponse_element> response_map_x = new Map<String, DocuSignAPI.GetAccountBrandsResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://www.docusign.net/API/3.0/GetAccountBrands',
              'http://www.docusign.net/API/3.0',
              'GetAccountBrands',
              'http://www.docusign.net/API/3.0',
              'GetAccountBrandsResponse',
              'DocuSignAPI.GetAccountBrandsResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.GetAccountBrandsResult;
        }
        public DocuSignAPI.DocumentPDFs RequestCertificate(String EnvelopeID) {
            DocuSignAPI.RequestCertificate_element request_x = new DocuSignAPI.RequestCertificate_element();
            DocuSignAPI.RequestCertificateResponse_element response_x;
            request_x.EnvelopeID = EnvelopeID;
            Map<String, DocuSignAPI.RequestCertificateResponse_element> response_map_x = new Map<String, DocuSignAPI.RequestCertificateResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://www.docusign.net/API/3.0/RequestCertificate',
              'http://www.docusign.net/API/3.0',
              'RequestCertificate',
              'http://www.docusign.net/API/3.0',
              'RequestCertificateResponse',
              'DocuSignAPI.RequestCertificateResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.RequestCertificateResult;
        }
        public String RequestCorrectToken(String EnvelopeID,Boolean SuppressNavigation,String ReturnURL) {
            DocuSignAPI.RequestCorrectToken_element request_x = new DocuSignAPI.RequestCorrectToken_element();
            DocuSignAPI.RequestCorrectTokenResponse_element response_x;
            request_x.EnvelopeID = EnvelopeID;
            request_x.SuppressNavigation = SuppressNavigation;
            request_x.ReturnURL = ReturnURL;
            Map<String, DocuSignAPI.RequestCorrectTokenResponse_element> response_map_x = new Map<String, DocuSignAPI.RequestCorrectTokenResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://www.docusign.net/API/3.0/RequestCorrectToken',
              'http://www.docusign.net/API/3.0',
              'RequestCorrectToken',
              'http://www.docusign.net/API/3.0',
              'RequestCorrectTokenResponse',
              'DocuSignAPI.RequestCorrectTokenResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.RequestCorrectTokenResult;
        }
        public DocuSignAPI.Envelope RequestEnvelope(String EnvelopeID,Boolean IncludeDocumentBytes) {
            DocuSignAPI.RequestEnvelope_element request_x = new DocuSignAPI.RequestEnvelope_element();
            DocuSignAPI.RequestEnvelopeResponse_element response_x;
            request_x.EnvelopeID = EnvelopeID;
            request_x.IncludeDocumentBytes = IncludeDocumentBytes;
            Map<String, DocuSignAPI.RequestEnvelopeResponse_element> response_map_x = new Map<String, DocuSignAPI.RequestEnvelopeResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://www.docusign.net/API/3.0/RequestEnvelope',
              'http://www.docusign.net/API/3.0',
              'RequestEnvelope',
              'http://www.docusign.net/API/3.0',
              'RequestEnvelopeResponse',
              'DocuSignAPI.RequestEnvelopeResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.RequestEnvelopeResult;
        }
        public DocuSignAPI.FilteredEnvelopeStatusChanges RequestStatusCodes(DocuSignAPI.EnvelopeStatusFilter EnvelopeStatusFilter) {
            DocuSignAPI.RequestStatusCodes_element request_x = new DocuSignAPI.RequestStatusCodes_element();
            DocuSignAPI.RequestStatusCodesResponse_element response_x;
            request_x.EnvelopeStatusFilter = EnvelopeStatusFilter;
            Map<String, DocuSignAPI.RequestStatusCodesResponse_element> response_map_x = new Map<String, DocuSignAPI.RequestStatusCodesResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://www.docusign.net/API/3.0/RequestStatusCodes',
              'http://www.docusign.net/API/3.0',
              'RequestStatusCodes',
              'http://www.docusign.net/API/3.0',
              'RequestStatusCodesResponse',
              'DocuSignAPI.RequestStatusCodesResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.RequestStatusCodesResult;
        }
        public DocuSignAPI.AccountMembershipFeaturesList GetAccountMembershipFeaturesList(String AccountId) {
            DocuSignAPI.GetAccountMembershipFeaturesList_element request_x = new DocuSignAPI.GetAccountMembershipFeaturesList_element();
            DocuSignAPI.GetAccountMembershipFeaturesListResponse_element response_x;
            request_x.AccountId = AccountId;
            Map<String, DocuSignAPI.GetAccountMembershipFeaturesListResponse_element> response_map_x = new Map<String, DocuSignAPI.GetAccountMembershipFeaturesListResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://www.docusign.net/API/3.0/GetAccountMembershipFeaturesList',
              'http://www.docusign.net/API/3.0',
              'GetAccountMembershipFeaturesList',
              'http://www.docusign.net/API/3.0',
              'GetAccountMembershipFeaturesListResponse',
              'DocuSignAPI.GetAccountMembershipFeaturesListResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.GetAccountMembershipFeaturesListResult;
        }
        public DocuSignAPI.AvailableFolders GetFolderList(DocuSignAPI.FoldersFilter FoldersFilter) {
            DocuSignAPI.GetFolderList_element request_x = new DocuSignAPI.GetFolderList_element();
            DocuSignAPI.GetFolderListResponse_element response_x;
            request_x.FoldersFilter = FoldersFilter;
            Map<String, DocuSignAPI.GetFolderListResponse_element> response_map_x = new Map<String, DocuSignAPI.GetFolderListResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://www.docusign.net/API/3.0/GetFolderList',
              'http://www.docusign.net/API/3.0',
              'GetFolderList',
              'http://www.docusign.net/API/3.0',
              'GetFolderListResponse',
              'DocuSignAPI.GetFolderListResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.GetFolderListResult;
        }
        public String RequestRecipientFaxToken(String EnvelopeID,String ClientUserID,String Username,String Email,DocuSignAPI.RequestRecipientTokenAuthenticationAssertion AuthenticationAssertion,DocuSignAPI.RequestRecipientTokenClientURLs ClientURLs) {
            DocuSignAPI.RequestRecipientFaxToken_element request_x = new DocuSignAPI.RequestRecipientFaxToken_element();
            DocuSignAPI.RequestRecipientFaxTokenResponse_element response_x;
            request_x.EnvelopeID = EnvelopeID;
            request_x.ClientUserID = ClientUserID;
            request_x.Username = Username;
            request_x.Email = Email;
            request_x.AuthenticationAssertion = AuthenticationAssertion;
            request_x.ClientURLs = ClientURLs;
            Map<String, DocuSignAPI.RequestRecipientFaxTokenResponse_element> response_map_x = new Map<String, DocuSignAPI.RequestRecipientFaxTokenResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://www.docusign.net/API/3.0/RequestRecipientFaxToken',
              'http://www.docusign.net/API/3.0',
              'RequestRecipientFaxToken',
              'http://www.docusign.net/API/3.0',
              'RequestRecipientFaxTokenResponse',
              'DocuSignAPI.RequestRecipientFaxTokenResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.RequestRecipientFaxTokenResult;
        }
        public DocuSignAPI.EnvelopeStatus CreateEnvelopeFromTemplates(DocuSignAPI.ArrayOfTemplateReference TemplateReferences,DocuSignAPI.ArrayOfRecipient1 Recipients,DocuSignAPI.EnvelopeInformation EnvelopeInformation,Boolean ActivateEnvelope) {
            DocuSignAPI.CreateEnvelopeFromTemplates_element request_x = new DocuSignAPI.CreateEnvelopeFromTemplates_element();
            DocuSignAPI.CreateEnvelopeFromTemplatesResponse_element response_x;
            request_x.TemplateReferences = TemplateReferences;
            request_x.Recipients = Recipients;
            request_x.EnvelopeInformation = EnvelopeInformation;
            request_x.ActivateEnvelope = ActivateEnvelope;
            Map<String, DocuSignAPI.CreateEnvelopeFromTemplatesResponse_element> response_map_x = new Map<String, DocuSignAPI.CreateEnvelopeFromTemplatesResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://www.docusign.net/API/3.0/CreateEnvelopeFromTemplates',
              'http://www.docusign.net/API/3.0',
              'CreateEnvelopeFromTemplates',
              'http://www.docusign.net/API/3.0',
              'CreateEnvelopeFromTemplatesResponse',
              'DocuSignAPI.CreateEnvelopeFromTemplatesResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.CreateEnvelopeFromTemplatesResult;
        }
        public DocuSignAPI.CorrectionStatus CorrectAndResendEnvelope(DocuSignAPI.Correction Correction) {
            DocuSignAPI.CorrectAndResendEnvelope_element request_x = new DocuSignAPI.CorrectAndResendEnvelope_element();
            DocuSignAPI.CorrectAndResendEnvelopeResponse_element response_x;
            request_x.Correction = Correction;
            Map<String, DocuSignAPI.CorrectAndResendEnvelopeResponse_element> response_map_x = new Map<String, DocuSignAPI.CorrectAndResendEnvelopeResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://www.docusign.net/API/3.0/CorrectAndResendEnvelope',
              'http://www.docusign.net/API/3.0',
              'CorrectAndResendEnvelope',
              'http://www.docusign.net/API/3.0',
              'CorrectAndResendEnvelopeResponse',
              'DocuSignAPI.CorrectAndResendEnvelopeResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.CorrectAndResendEnvelopeResult;
        }
        public DocuSignAPI.EnvelopeStatus SendEnvelope(String EnvelopeId,String AccountId) {
            DocuSignAPI.SendEnvelope_element request_x = new DocuSignAPI.SendEnvelope_element();
            DocuSignAPI.SendEnvelopeResponse_element response_x;
            request_x.EnvelopeId = EnvelopeId;
            request_x.AccountId = AccountId;
            Map<String, DocuSignAPI.SendEnvelopeResponse_element> response_map_x = new Map<String, DocuSignAPI.SendEnvelopeResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://www.docusign.net/API/3.0/SendEnvelope',
              'http://www.docusign.net/API/3.0',
              'SendEnvelope',
              'http://www.docusign.net/API/3.0',
              'SendEnvelopeResponse',
              'DocuSignAPI.SendEnvelopeResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.SendEnvelopeResult;
        }
        public DocuSignAPI.FolderResults GetFolderItems(DocuSignAPI.FolderFilter FolderFilter) {
            DocuSignAPI.GetFolderItems_element request_x = new DocuSignAPI.GetFolderItems_element();
            DocuSignAPI.GetFolderItemsResponse_element response_x;
            request_x.FolderFilter = FolderFilter;
            Map<String, DocuSignAPI.GetFolderItemsResponse_element> response_map_x = new Map<String, DocuSignAPI.GetFolderItemsResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://www.docusign.net/API/3.0/GetFolderItems',
              'http://www.docusign.net/API/3.0',
              'GetFolderItems',
              'http://www.docusign.net/API/3.0',
              'GetFolderItemsResponse',
              'DocuSignAPI.GetFolderItemsResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.GetFolderItemsResult;
        }
        public DocuSignAPI.EnvelopeTemplate RequestTemplate(String TemplateID,Boolean IncludeDocumentBytes) {
            DocuSignAPI.RequestTemplate_element request_x = new DocuSignAPI.RequestTemplate_element();
            DocuSignAPI.RequestTemplateResponse_element response_x;
            request_x.TemplateID = TemplateID;
            request_x.IncludeDocumentBytes = IncludeDocumentBytes;
            Map<String, DocuSignAPI.RequestTemplateResponse_element> response_map_x = new Map<String, DocuSignAPI.RequestTemplateResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://www.docusign.net/API/3.0/RequestTemplate',
              'http://www.docusign.net/API/3.0',
              'RequestTemplate',
              'http://www.docusign.net/API/3.0',
              'RequestTemplateResponse',
              'DocuSignAPI.RequestTemplateResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.RequestTemplateResult;
        }
        public DocuSignAPI.DocumentPDFs RequestDocumentPDFsRecipientsView(String EnvelopeID,String RecipientName,String RecipientEmail) {
            DocuSignAPI.RequestDocumentPDFsRecipientsView_element request_x = new DocuSignAPI.RequestDocumentPDFsRecipientsView_element();
            DocuSignAPI.RequestDocumentPDFsRecipientsViewResponse_element response_x;
            request_x.EnvelopeID = EnvelopeID;
            request_x.RecipientName = RecipientName;
            request_x.RecipientEmail = RecipientEmail;
            Map<String, DocuSignAPI.RequestDocumentPDFsRecipientsViewResponse_element> response_map_x = new Map<String, DocuSignAPI.RequestDocumentPDFsRecipientsViewResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://www.docusign.net/API/3.0/RequestDocumentPDFsRecipientsView',
              'http://www.docusign.net/API/3.0',
              'RequestDocumentPDFsRecipientsView',
              'http://www.docusign.net/API/3.0',
              'RequestDocumentPDFsRecipientsViewResponse',
              'DocuSignAPI.RequestDocumentPDFsRecipientsViewResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.RequestDocumentPDFsRecipientsViewResult;
        }
    }
    public class AuthoritativeCopyExportDocuments {
        public String EnvelopeId;
        public String TransactionId;
        public Integer Count;
        public DocuSignAPI.DocumentPDF[] DocumentPDF;
        private String[] EnvelopeId_type_info = new String[]{'EnvelopeId','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] TransactionId_type_info = new String[]{'TransactionId','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Count_type_info = new String[]{'Count','http://www.w3.org/2001/XMLSchema','int','1','1','false'};
        private String[] DocumentPDF_type_info = new String[]{'DocumentPDF','http://www.docusign.net/API/3.0','DocumentPDF','0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'EnvelopeId','TransactionId','Count','DocumentPDF'};
    }
    public class GetFolderListResponse_element {
        public DocuSignAPI.AvailableFolders GetFolderListResult;
        private String[] GetFolderListResult_type_info = new String[]{'GetFolderListResult','http://www.docusign.net/API/3.0','AvailableFolders','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'GetFolderListResult'};
    }
    public class ExportAuthoritativeCopyResponse_element {
        public DocuSignAPI.AuthoritativeCopyExportDocuments ExportAuthoritativeCopyResult;
        private String[] ExportAuthoritativeCopyResult_type_info = new String[]{'ExportAuthoritativeCopyResult','http://www.docusign.net/API/3.0','AuthoritativeCopyExportDocuments','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'ExportAuthoritativeCopyResult'};
    }
    public class GetAccountSettingsList_element {
        public String AccountId;
        private String[] AccountId_type_info = new String[]{'AccountId','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'AccountId'};
    }
    public class ArrayOfRecipientCorrectionStatus {
        public DocuSignAPI.RecipientCorrectionStatus[] RecipientCorrectionStatus;
        private String[] RecipientCorrectionStatus_type_info = new String[]{'RecipientCorrectionStatus','http://www.docusign.net/API/3.0','RecipientCorrectionStatus','0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.docusign.net/API/3.0','true','false'};
        private String[] field_order_type_info = new String[]{'RecipientCorrectionStatus'};
    }
}