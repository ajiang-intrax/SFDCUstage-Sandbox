public class IGI_TIPP_Controller{
    public Match__c sMatch {get;set;}
    public Match__c m {get;set;}
    public List<Position_Info__c> nPos { get; set;}
    public Position_Info__c rPos {get; set;}
    public Development_Plan__c new_plan {get; set;}
    public list<Development_Plan__c> selectedPlans {get;set;}
    public string SelectedPlanId { get; set; }
    public boolean bool_Plan {get; set{ bool_plan=false;} }
    public User user { get; set;}
    public Position_Info__c c_posInfo{get;set;}
    public boolean customMessage {get;set;}
    public String validate {get;set;}
    public IGI_TIPP_Controller()
    {
      rPos= new Position_Info__c();
      selectedPlans = new List<Development_Plan__c>();
      new_plan= new Development_Plan__c();
      c_posInfo =new Position_Info__c();
      customMessage = false;
      m=new Match__c();
    }
    public IGI_TIPP_Controller(ApexPages.StandardController controller) {
      user = [SELECT id,  localesidkey FROM User
                    WHERE id = :UserInfo.getUserId()];
      sObject theObject = controller.getRecord();
        if (theObject.getSObjectType() == Match__c.SObjectType){
            sMatch = (Match__c)controller.getRecord();
        }
        else if (theObject.getSObjectType() == Development_Plan__c.SObjectType)
            new_Plan = (Development_Plan__c)controller.getRecord();
                   
    }
    public Position_Info__c getPositionInfo()
    {
    if(rPos!=null)
     {
       return rPos;
     }
     else
       return null;
    }
   public Id gethosMatchId()
   {
     return sMatch.id;
   }
  
   public Id getMatchId()
    {
     Id m= Id.valueof(ApexPages.currentPage().getParameters().get('mId'));
     return m;
    }
    public Id getposId()
    {
     return rPos.Id;
    }
   public Development_plan__c getPlan()
   {
       return new_plan;
   }
   public Pagereference preLoad()
   {
     if(ApexPages.currentPage().getParameters().get('val') !=null)
     {
        validate=ApexPages.currentPage().getParameters().get('val');
      }
     if(ApexPages.currentPage().getParameters().get('mId') != null) {
            //Populating list with the Development Plan records       
          String a= ApexPages.currentPage().getParameters().get('mId');
          sMatch.id = Id.valueOf(a);
        }
     sMatch = [select Id,Name, Participant_Id__r.Name,Participant_Id__r.LastName,Participant_Id__r.FirstName,Participant_Id__r.Middle_Name__pc,Position_Name__r.Intrax_Program__c,Position_Name__r.Intrax_Program_Options__c,
            Position_Name__r.Functional_Areas__c,Position_Name__r.Compensation_Type__c,Position_Name__r.Hours_Per_Week__c,Position_Name__r.Host_Company_Id__r.Website,
            Position_Name__r.Position_Supervisor__r.Title,Position_Name__r.Position_Supervisor__r.FirstName,Position_Name__r.Position_Supervisor__r.LastName,
            Position_Name__r.Position_Supervisor__r.Phone,Position_Name__r.Position_Supervisor__r.Email,
            Position_Name__r.Host_Company_Id__r.Worker_Comp_Provider__c, Position_Name__r.Host_Company_Id__r.Name,Position_Name__r.Host_Company_Id__r.EIN__c,
            Position_Name__r.Host_Company_Id__r.Company_Annual_Revenue__c,Position_Name__r.Host_Company_Id__r.NumberOfEmployees,   
            Engagement__r.SEVIS_Program__c,Engagement__r.Engagement_Start__c,Engagement__r.Engagement_End__c,Position_Name__r.Pay_rate__c,Position_Name__r.Pay_Rate_Basis__c,
            Position_Name__r.Host_Company_Id__r.Fax,Position_Name__r.Workers_Comp_Coverage__c,Position_Name__r.Non_Monetary_Comp_Value__c,
            Position_Name__r.Non_Monetary_Comp_Description__c,Position_Name__r.Host_Company_Id__r.Has_Workers_Comp__c,
            Position_Name__r.Street__c, Position_Name__r.Street_2__c,Position_Name__r.City__c,Position_Name__r.State__c,
            Position_Name__r.Postal_Code__c,Current_TIPP_Editor__c,Intrax_Program__c
            from Match__c where id=:sMatch.id limit 1]; 
       if(sMatch.Intrax_Program__c=='Internship' && (sMatch.Current_TIPP_Editor__c == null || sMatch.Current_TIPP_Editor__c == ' ')){
           sMatch.Current_TIPP_Editor__c='Intrax Office';
           update sMatch;
       }
     nPos=[select id,Status__c,Name,Company_Name__c,Company_Street_1__c,Company_Street_2__c,Company_City__c,Worker_Comp_Provider__c,Number_of_Employees__c,Supervisor_Title__c,
                Supervisor_First_Name__c,Supervisor_Last_Name__c ,Supervisor_Phone__c,Supervisor_Email__c,Functional_Areas__c,
                Company_State__c,Company_Postal_Code__c,Company_Website__c,EIN__c,Hours_Per_Week__c,Compensation_Type__c,Pay_rate__c,Pay_Rate_Basis__c,
                Non_Monetary_Comp_Value__c,Non_Monetary_Comp_Description__c,Workers_Comp_Coverage__c,Has_Workers_Comp__c,Supervisor_Fax__c,Company_Annual_Revenue__c,Review_Comments__c 
                from Position_Info__c where Match__c =:sMatch.id limit 1];
      if((nPos!=null) && (nPos.size() ==1))
      {
       rPos=nPos[0];
       if(nPos[0].Status__c.equals('In-Review')||nPos[0].Status__c.equals('Accepted'))
       {
          Pagereference p = new Pagereference('/apex/igi_tipp_thanks');
          p.getParameters().put('Status',nPos[0].Status__c);
          p.setRedirect(true);
          return p;
       }
      }
      else {
      Position_Info__c new_pos=new Position_Info__c();
      nPos.add(new_pos);
      loaddata();
      createPositionInfo();
      rpos=nPos[0];
     }
     if(ApexPages.currentPage().getParameters().get('mId') != null) {
         selectedPlans = [Select ID, Name, Phase__c, Start__c, End__c,Match_Name__c
                                FROM Development_Plan__c 
                                WHERE
                                Match_Name__r.Id =: sMatch.id order by Phase__c];
     }
    return null;
    }
    public void loadplan() {
     if(ApexPages.currentPage().getParameters().get('val') !=null)
     {
        validate=ApexPages.currentPage().getParameters().get('val');
      }
     Id m_id = Id.valueof(ApexPages.currentPage().getParameters().get('mId'));
     m= [select id, Development_Plan_Phases__c,Engagement__r.Engagement_Start__c,Engagement__r.Engagement_End__c from Match__c where id =: m_id limit 1];
     new_plan.Phase__c = (m.Development_Plan_Phases__c +1);
    }
   public void LoadSelectedPlan()
   {
     if(ApexPages.currentPage().getParameters().get('val') !=null)
     {
        validate=ApexPages.currentPage().getParameters().get('val');
      }
     Id dp_id = Id.valueof(ApexPages.currentPage().getParameters().get('dpid'));
     new_plan = [select id, Name, Phase__c, Start__c, End__c,Match_Name__c,Description__c,Goal__c,Supervision__c,Cultural_Component__c,Learning_Outcome__c,
                               Match_Name__r.Id, Instructional_Methods__c,Evaluation_Methods__c,Review_Comments__c,Supervisor_Last_Name__c,
                               Supervisor_First_Name__c,Supervisor_Title__c,Supervisor_Email__c,Supervisor_Phone__c,Position_Info__r.Status__c,Additional_Remarks__c
                               FROM Development_Plan__c  where id =: dp_id limit 1]; 
     m= [select id, Engagement__r.Engagement_Start__c,Engagement__r.Engagement_End__c from Match__c where id =: new_plan.Match_name__c limit 1];
   }
   public void deletePlan()
   {
    // if for any reason we are missing the reference 
      if (SelectedPlanId == null) { 
         return;
      }
   // find the Plan record within the collection
      Development_Plan__c tobeDeleted = null;
       for(Development_Plan__c dp : selectedPlans){
       if (dp.Id == SelectedPlanId) {
          tobeDeleted = dp;
          break;
       }
      }
      if (tobeDeleted != null) {
       Delete tobeDeleted;
      }
     
      //refresh the data
      preload();
   }           
   public void loadData()
   {
     Application_Constants__c ac = Application_Constants__c.getInstance('RT_Position_Info_TIPP');
     nPos[0].Name='TrainingPlan '+ sMatch.Participant_Id__r.Name;
     nPos[0].Match__c= sMatch.id;
     //nPos[0].RecordTypeId= Constants.TrainingPlan_Id;
       if (ac.Value__c != null){
     	nPos[0].RecordTypeId= ac.value__c;
       }
     nPos[0].status__c = 'Working';
     nPos[0].Company_Country__c ='United States';
     nPos[0].Company_Name__c =sMatch.Position_Name__r.Host_Company_Id__r.Name;
     nPos[0].Company_Website__c=sMatch.Position_Name__r.Host_Company_Id__r.Website;
     nPos[0].Compensation_Type__c = sMatch.Position_Name__r.Compensation_Type__c;
     nPos[0].Supervisor_Title__c = sMatch.Position_Name__r.Position_Supervisor__r.Title;
     nPos[0].Supervisor_First_Name__c = sMatch.Position_Name__r.Position_Supervisor__r.FirstName;
     nPos[0].Supervisor_Last_Name__c = sMatch.Position_Name__r.Position_Supervisor__r.LastName;
     nPos[0].Supervisor_Phone__c = sMatch.Position_Name__r.Position_Supervisor__r.Phone;
     nPos[0].Supervisor_Email__c = sMatch.Position_Name__r.Position_Supervisor__r.Email;
     nPos[0].Worker_Comp_Provider__c =sMatch.Position_Name__r.Host_Company_Id__r.Worker_Comp_Provider__c;
     nPos[0].EIN__c= sMatch.Position_Name__r.Host_Company_Id__r.EIN__c;
     nPos[0].Intrax_Program__c= sMatch.Position_Name__r.Intrax_Program__c;
     nPos[0].Intrax_Program_Option__c = sMatch.Position_Name__r.Intrax_Program_Options__c;
     nPos[0].Functional_Areas__c = sMatch.Position_Name__r.Functional_Areas__c;
     nPos[0].Hours_Per_Week__c = sMatch.Position_Name__r.Hours_Per_Week__c;
     nPos[0].Pay_rate__c = sMatch.Position_Name__r.Pay_rate__c;
     nPos[0].Pay_Rate_Basis__c = sMatch.Position_Name__r.Pay_Rate_Basis__c ;
     nPos[0].Company_Annual_Revenue__c = sMatch.Position_Name__r.Host_Company_Id__r.Company_Annual_Revenue__c;
     nPos[0].Number_of_Employees__c = sMatch.Position_Name__r.Host_Company_Id__r.NumberOfEmployees;
     nPos[0].Has_Workers_Comp__c= sMatch.Position_Name__r.Host_Company_Id__r.Has_Workers_Comp__c;
     nPos[0].Non_Monetary_Comp_Description__c=sMatch.Position_Name__r.Non_Monetary_Comp_Description__c;
     nPos[0].Non_Monetary_Comp_Value__c=sMatch.Position_Name__r.Non_Monetary_Comp_Value__c;
     nPos[0].Workers_Comp_Coverage__c =sMatch.Position_Name__r.Workers_Comp_Coverage__c;
     nPos[0].Supervisor_Fax__c = sMatch.Position_Name__r.Host_Company_Id__r.Fax;
     nPos[0].Company_Street_1__c =sMatch.Position_Name__r.Street__c;
     nPos[0].Company_Street_2__c =sMatch.Position_Name__r.Street_2__c;
     nPos[0].Company_City__c =sMatch.Position_Name__r.City__c;
     nPos[0].Company_State__c =sMatch.Position_Name__r.State__c;
     nPos[0].Company_Postal_Code__c =sMatch.Position_Name__r.Postal_Code__c;
   }
   public void createPositionInfo()
   {
     insert nPos[0];
     System.debug('Inserted***');
   }
    public void updatePositionInfo()
   {
     if(rPos.Compensation_Type__c.equals('Unpaid')){
           rPos.Pay_rate__c = null;
           rPos.Pay_Rate_Basis__c = null;
       }
       if(!rPos.Has_Workers_Comp__c)
       {
          rPos.Worker_Comp_Provider__c = null;
       }
       update rPos;
     System.debug('Updated****');
   }
   public void getPosInfo()
   {
     if(ApexPages.currentPage().getParameters().get('mId') != null)
    {
     c_posInfo=[select id,status__c from Position_Info__c where Match__c =:Id.valueof(ApexPages.currentPage().getParameters().get('mId'))limit 1];
     }
   }   
     
   public String updatePosStatus()
   {
    if((ApexPages.currentPage().getParameters().get('pId') != null) && (ApexPages.currentPage().getParameters().get('val') =='d_v'))
    {
       getPosInfo();
       c_posInfo.status__c = 'In-Review';
       update c_posInfo;
       return c_posInfo.status__c;
    }
     return null;           
   }
   
   public Pagereference navigator()
   {
    
    if(ApexPages.currentPage().getParameters().get('pInfo')=='true')
    {
     updatePositionInfo();
    }
     PageReference retParam;
     if(ApexPages.currentPage().getParameters().get('nextPage') != null)
     {
       retParam= new PageReference(ApexPages.currentPage().getParameters().get('nextPage'));
       String pageref= ApexPages.currentPage().getParameters().get('mId');
       if(ApexPages.currentPage().getParameters().get('mId') != null)
       {
           retParam= new PageReference(ApexPages.currentPage().getParameters().get('nextPage')+'?mId='+pageref+'&val='+validate); 
            if(ApexPages.currentPage().getParameters().get('nPlan')=='true'){
                  new_plan.Match_Name__c =  Id.valueof(ApexPages.currentPage().getParameters().get('mId')) ;
                  getPosInfo();
                  new_plan.Position_Info__c = c_posInfo.id;
                  insert new_plan;
               }
            if(ApexPages.currentPage().getParameters().get('up_plan')=='true'){
                 update new_plan;
               }
       }
       if(ApexPages.currentPage().getParameters().get('pId') != null)
       {
           String s=updatePosStatus();
           retParam= new PageReference(ApexPages.currentPage().getParameters().get('nextPage')+'?Status='+s); 
       }
       if(ApexPages.currentPage().getParameters().get('reDirectPage') == 'true') {
       retParam.setRedirect(true);
       }
     }
     else {
      retParam=null;
     }
    return retParam;   
   }
   public pageReference validator(){
       if((ApexPages.currentPage().getParameters().get('val')=='d_v') &&(selectedPlans.size() >= 1))
       {
         return navigator();
        }
       else if(ApexPages.currentPage().getParameters().get('val')=='n_v'){
           ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please submit Host Company Details Page'); 
           ApexPages.addMessage(msg);
            customMessage=true;
            return null;
           }
        else if(selectedPlans.size() < 1){  
           ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please submit at least one Phase'); 
           ApexPages.addMessage(msg);
            customMessage=true;
            return null;
         }
      return null;
    }
    public pageReference validatorhost(){
      if(rPos.Company_State__c.length() != 2){
          ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Enter Two Letter State Code'); 
          ApexPages.addMessage(msg);
          customMessage=true;
          return null;
        }
        else if(rPos.Company_Postal_Code__c.length() != 5){
          ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Enter 5 digit Zip'); 
          ApexPages.addMessage(msg);
          customMessage=true;
          return null;
        }
        else if(rPos.EIN__c.length() != 9){
          ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Invalid EIN'); 
          ApexPages.addMessage(msg);
          customMessage=true;
          return null;
        }
        else if((rPos.Non_Monetary_Comp_Value__c != null) && (rPos.Non_Monetary_Comp_Description__c == null))
        {
          ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Non-Monetary Compensation Description is required when its value is given'); 
          ApexPages.addMessage(msg);
          customMessage=true;
          return null;            
        }
        else {
            validate='d_v';
            return navigator();  
        } 
    }
    public boolean getcheckstartdate()
    {
     if((new_plan.start__c >= m.Engagement__r.Engagement_Start__c) && (new_plan.start__c < m.Engagement__r.Engagement_End__c))
       {
           return false;
       }
      return true;  
    }
     public boolean getcheckEnddate()
    {
      if((new_plan.End__c > m.Engagement__r.Engagement_Start__c) && (new_plan.start__c < new_plan.End__c ) && (new_plan.End__c <= m.Engagement__r.Engagement_End__c))
       {
           return false;
       }
      return true;  
    }
    public Pagereference validate_phasedate()
    {
       if((getcheckstartdate())||(getcheckEnddate()))
       {
          ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please correct the following'); 
          ApexPages.addMessage(msg);
          customMessage=true;
          return null; 
       }
        return navigator();
    }

}