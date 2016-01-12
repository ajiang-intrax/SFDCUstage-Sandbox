/*
Purpose         :   Helper class for Trigger_DSRStatus.

Created Date    :   04/16/2012

Current Version :   v1.0

Revision Log    :   V_1.1 Created

*/
public with sharing class DSRStatusTriggerHelper{
    
    /**
* Description   :   This method checks for all the DSStatus and update the related Applicant Info. 
* @args         :   List of DSStatuses
* @return       :   void
*/
    public static void updateApplicantInfoFk(List<dsfs__DocuSign_Recipient_Status__c> lstDSRStatus) {
        
        //Property to hold match related opportunities id
        Set<Id> statusIds = new Set<Id>();
        Person_Info__c personInfo=new Person_Info__c ();
        
        List<dsfs__DocuSign_Recipient_Status__c > StatusesToBeUpdated = new List<dsfs__DocuSign_Recipient_Status__c >();
        
        //loop through the matche and get the related id
        if(lstDSRStatus!=null)
        {
            for(dsfs__DocuSign_Recipient_Status__c status: lstDSRStatus) {
                
                If (status.Person_Info__c != null && status.Applicant_Info__c == null) { 
                    personInfo=[select Applicant_Info__c from Person_Info__c where id=:status.Person_Info__c ];  
                    system.debug('personInfo');           
                    status.Applicant_Info__c = personInfo.Applicant_Info__c;
                    
                }
                
            }
        }
        
    } 
   
    public static void updateHostAccount(List<dsfs__DocuSign_Recipient_Status__c> lstDSRStatus) {
      if(lstDSRStatus!=null)
      {
             // Set<Id> statusIds = new Set<Id>();
        Account acc=new Account();
        Application_Constants__c app = Application_Constants__c.getInstance('DocuSignDatePSTMap');
        String s_tz = app.value__c;
        Timezone tz = Timezone.getTimeZone(s_tz);
         List<dsfs__DocuSign_Recipient_Status__c> DocSignRecStat = new List<dsfs__DocuSign_Recipient_Status__c>();
        //Set<Id> lstDRSStatus = new Set<Id> {'a0r540000008Oc9'};   
        DocsignRecStat= [Select Id, Name,dsfs__Date_Signed__c,dsfs__Parent_Status_Record__c,dsfs__Parent_Status_Record__r.dsfs__Company__c,dsfs__Parent_Status_Record__r.dsfs__Subject__c from dsfs__DocuSign_Recipient_Status__c 
                   where id in :lstDSRStatus];
        //System.debug('docusign status'+docsignRecStat[0].dsfs__Parent_Status_Record__r.dsfs__Company__c);
        
            for(dsfs__DocuSign_Recipient_Status__c status: DocsignRecStat) {
                If (status.dsfs__Date_Signed__c!=null && status.dsfs__Parent_Status_Record__r.dsfs__Company__c != null && status.dsfs__Parent_Status_Record__r.dsfs__Subject__c == 'IGI Host Company Agreement') { 
                    acc=[select id,name,INT_Agreement_Received__c,INT_Agreement_Expires__c from Account where id=:status.dsfs__Parent_Status_Record__r.dsfs__Company__c ];  
                    system.debug('host company account');           
                    acc.INT_Agreement_Received__c =Date.Valueof(DateTime.newInstance((status.dsfs__Date_Signed__c).getTime() + tz.getOffset(System.Now())));//status.dsfs__Date_Signed__c.date();
                    acc.INT_Agreement_Expires__c=Date.Valueof(DateTime.newInstance((status.dsfs__Date_Signed__c).getTime() + tz.getOffset(System.Now())))+365;//(status.dsfs__Date_Signed__c.date()+365;
                    update acc;
                  }
                
            }
        }
        
    }
    
    public static void updateDevelopmentPlan(List<dsfs__DocuSign_Recipient_Status__c> lstDRStatus) {
        
        List<Match__c> MatToUpdate = new List<Match__c>();
        List<String> MatRec = new List<String>();
        List<Match__c> Matchs = new List<Match__c>();
        List<dsfs__DocuSign_Status__c> DocSignStat = new List<dsfs__DocuSign_Status__c>();
        List<Development_Plan__c> DevPlanRec = new List<Development_Plan__c>();
        List<Development_Plan__c> DplToUpdate = new List<Development_Plan__c>();
        List<SEVIS_Responsible_Officers__c> SevisOfficers = new List<SEVIS_Responsible_Officers__c>();
        SevisOfficers = [Select Email__c,Intrax_Programs__c,Official_Name__c, SEVIS_Username__c from SEVIS_Responsible_Officers__c];
        Application_Constants__c app = Application_Constants__c.getInstance('DocuSignDatePSTMap');
        String s_tz = app.value__c;
        Timezone tz = Timezone.getTimeZone(s_tz);
        if(lstDRStatus!=null)
        {
         DocSignStat = [Select Id, Name,Match__c from dsfs__DocuSign_Status__c where Match__c != null];
            for(dsfs__DocuSign_Recipient_Status__c status: lstDRStatus) {
                if (status.dsfs__Date_Signed__c !=null)
                {                 
                 for(dsfs__DocuSign_Status__c dss : DocSignStat)
                  {        
                   if(status.dsfs__Parent_Status_Record__c == dss.Id)
                   {
                   MatRec.add(dss.Match__c);
                   }
                  
                  }
                  
                }
            }
            if(MatRec !=null && MatRec.size()>0)
            {
             DevPlanRec = [Select Id,Name,Match_Name__c,Supervisor_Email__c,Supervisor_Signed_TIPP__c from Development_Plan__c where Match_Name__c IN:MatRec];
             Matchs = [Select Id, Name,PT_Signed_TIPP__c,ARO_Signed_TIPP_Name__c,ARO_Signed_TIPP__c,Participant_Id__r.PersonEmail,Participant_Id__r.Name from Match__c where id IN:MatRec and RecordType.Name = 'Internship'];
            }
            
        }
        
        if(DevPlanRec !=null && DevPlanRec.size()>0){
         for(Development_Plan__c Dpl: DevPlanRec){
            for(dsfs__DocuSign_Recipient_Status__c status: lstDRStatus) {
                if(status.dsfs__DocuSign_Recipient_Email__c == Dpl.Supervisor_Email__c)
                {
                  if(Dpl.Supervisor_Signed_TIPP__c == null)
                  {
                    //Dpl.Supervisor_Signed_TIPP__c = Date.ValueOf(status.dsfs__Date_Signed__c);
                    //DplToUpdate.add(Dpl);
                    Dpl.Supervisor_Signed_TIPP__c = Date.Valueof(DateTime.newInstance((status.dsfs__Date_Signed__c).getTime() + tz.getOffset(System.Now()))); 
                    update Dpl;
                    system.debug('Supervisor signed TIPP date' +Dpl.Supervisor_Signed_TIPP__c);
                  }
                }
                
               }
            
        }}
       
       
        for(dsfs__DocuSign_Recipient_Status__c status: lstDRStatus) {
              // DocSignStat = [Select Id, Name,Match__c from dsfs__DocuSign_Status__c where Match__c != null];
                  for(Match__c m:Matchs)
                    {
                     if(m.PT_Signed_TIPP__c == null)
                      {
                       if(status.dsfs__DocuSign_Recipient_Email__c == m.Participant_Id__r.PersonEmail)
                       {
                      // m.PT_Signed_TIPP__c = Date.ValueOf(status.dsfs__Date_Signed__c);
                       m.PT_Signed_TIPP__c = Date.Valueof(DateTime.newInstance((status.dsfs__Date_Signed__c).getTime() + tz.getOffset(System.Now()))); 
                       MatToUpdate.add(m);
                       system.debug('PT Signed TIPP' +m.PT_Signed_TIPP__c);
                       }
                      }
                    
                      String email = status.dsfs__DocuSign_Recipient_Email__c;
                      
                       if(m.ARO_Signed_TIPP__c == null)
                      {
                       for (SEVIS_Responsible_Officers__c s:SevisOfficers)
                       {
                        if(s.Email__c == email)
                        {
                          m.ARO_Signed_TIPP_Name__c = s.Official_Name__c;
                         // m.ARO_Signed_TIPP__c = Date.ValueOf(status.dsfs__Date_Signed__c);
                         m.ARO_Signed_TIPP__c =Date.Valueof(DateTime.newInstance((status.dsfs__Date_Signed__c).getTime() + tz.getOffset(System.Now())));
                          MatToUpdate.add(m);
                          system.debug('ARO Signed TIPP' + m.ARO_Signed_TIPP__c);
                        }
                        }
                       }
                      
                    }
       
           }
           if(MatToUpdate!=null && MatToUpdate.size()>0)
           {
            system.debug('MatToUpdate' +MatToUpdate);
            update MatToUpdate;
           }
        
    }  
    
    
    
}