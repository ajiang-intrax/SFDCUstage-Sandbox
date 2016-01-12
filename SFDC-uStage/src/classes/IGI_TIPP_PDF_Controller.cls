public class IGI_TIPP_PDF_Controller {
     public Match__c sMatch {get;set;}
     public Position_Info__c posInfo {get;set;}
     public List<Position_Info__c> list_posInfo;
     public list<Development_Plan__c> selectedPlans {get;set;}   
     public IGI_TIPP_PDF_Controller(ApexPages.StandardController controller) {
            sMatch = (Match__c)controller.getRecord();
            selectedPlans = new List<Development_Plan__c>();   
            list_posInfo = new List<Position_Info__c>();         
            posInfo =new Position_Info__c();    
    }
   
   public void preLoad()
   {
         system.debug('IGI_TIPP_PDF_Controller ------>preLoad');
         if(ApexPages.currentPage().getParameters().get('id') != null) {           
          String a= ApexPages.currentPage().getParameters().get('id');
           system.debug('IGI_TIPP_PDF_Controller  Match Id'+a);
          sMatch.id = Id.valueOf(a);
          sMatch = [ select Name, Participant_Id__r.Name,Participant_Id__r.LastName,Participant_Id__r.FirstName,Participant_Id__r.Middle_Name__pc,Participant_Id__r.PersonEmail,Position_Name__r.Intrax_Program__c,Position_Name__r.Intrax_Program_Options__c,
            Position_Name__r.Name,Position_Name__r.State__c,Position_Name__r.Street__c,Position_Name__r.City__c,Position_Name__r.Country__c,Position_Name__r.Postal_Code__c,Position_Name__r.Street_2__c,Position_Name__r.Functional_Areas__c,Position_Name__r.Non_Monetary_Comp_Value__c,Position_Name__r.Compensation_Type__c,Position_Name__r.Employment_Hrs_Wk__c,
            Position_Name__r.Position_Supervisor__r.Title,Position_Name__r.Position_Supervisor__r.FirstName,Position_Name__r.Position_Supervisor__r.LastName,
            Position_Name__r.Position_Supervisor__r.Phone,Position_Name__r.Position_Supervisor__r.Email,
            Position_Name__r.Host_Company_Id__r.Fax,Position_Name__r.Host_Company_Id__r.Worker_Comp_Provider__c,Position_Name__r.Workers_Comp_Coverage__c,Position_Name__r.Pay_Rate__c, Position_Name__r.Host_Company_Id__r.Name,Position_Name__r.Host_Company_Id__r.EIN__c, Position_Name__r.Host_Company_Id__r.Company_Annual_Revenue__c,Position_Name__r.Hours_Per_Week__c,
            Position_Name__r.Host_Company_Id__r.AnnualRevenue,Position_Name__r.Host_Company_Id__r.Has_Workers_Comp__c,Position_Name__r.Host_Company_Id__r.NumberOfEmployees,   
            Engagement__r.SEVIS_Program__c,Engagement__r.Engagement_Start__c,Engagement__r.Engagement_End__c,Position_Name__r.Pay_Rate_Basis__c,Position_Name__r.Non_Monetary_Comp_Description__c,
            Engagement__r.Intrax_Program__c,Engagement__r.Intrax_Program_Options__c,Position_Name__r.Host_Company_Id__r.Website,
            Engagement__r.Years_of_Experience__c,Engagement__r.Education_Program_Type__c,Engagement__r.Graduation_Date__c,Engagement__r.SEVIS_Occupation__c,Engagement__r.SEVIS_Field_of_Study__c,Engagement__r.SEVIS_Degree_Type__c
            
            from Match__c where id=:sMatch.id limit 1];
              
           selectedPlans = [Select ID, Name, Phase__c, Start__c, End__c,Match_Name__c,Description__c,Goal__c,Supervision__c,Cultural_Component__c,Learning_Outcome__c,
                               Match_Name__r.Id, Instructional_Methods__c,Evaluation_Methods__c,Review_Comments__c,Supervisor_Last_Name__c,
                               Supervisor_First_Name__c,Supervisor_Title__c,Supervisor_Email__c,Supervisor_Phone__c,Position_Info__r.Status__c,Additional_Remarks__c,Match_Name__r.Position_Name__r.Functional_Areas__c,Match_Name__r.Position_Name__r.Site_Name__c,Match_Name__r.Position_Name__r.Street__c,Match_Name__r.Position_Name__r.Street_2__c,Match_Name__r.Position_Name__r.City__c,Match_Name__r.Position_Name__r.State__c,Match_Name__r.Position_Name__r.Postal_Code__c
                               
                              FROM Development_Plan__c 
                              WHERE
                              Match_Name__r.Id =: sMatch.id order by Phase__c];
          list_posInfo=[Select id,Name,Status__c,Company_Name__c,Match__c,RecordType.Name,Company_Street_1__c,Company_Street_2__c,Company_City__c, Company_State__c ,Company_Postal_Code__c ,
          Company_Website__c,EIN__c,Hours_Per_Week__c,Compensation_Type__c,Pay_Rate__c,Pay_Rate_Basis__c,Non_Monetary_Comp_Value__c ,Non_Monetary_Comp_Description__c,Has_Workers_Comp__c,Worker_Comp_Provider__c,Workers_Comp_Coverage__c, 
          Number_of_Employees__c, Company_Annual_Revenue__c, Supervisor_First_Name__c, Supervisor_Last_Name__c, Supervisor_Title__c, Supervisor_Phone__c, Supervisor_Fax__c, Supervisor_Email__c
         from Position_Info__c where Match__c=:sMatch.id and RecordType.Name='Training Plan' limit 1];
         if(list_posInfo!=null && list_posInfo.size()>=1){
         	posInfo=list_posInfo[0];
         }
     }    
   }              
}