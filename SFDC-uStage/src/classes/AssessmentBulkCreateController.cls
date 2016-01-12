/**
 * An apex page controller that exposes the bulk creation functionality for Assessment Instances
  */
public with sharing class AssessmentBulkCreateController {    
    public Match__c match{get; set;}
    public Match__c confMatch{get; set;}
    public Account participantAccount{get; set;}
    public Account hostAccount{get; set;}
    public integer count{get;set;}
    public integer extended_count{get;set;}
    public integer extended_SCcount{get;set;}
     public integer DiffCount{get;set;}
    public integer DiffSCcount{get;set;}
    public integer SCcount{get;set;}
    public string StartMonth;
    public Integer StartMonthNumber;
    public string ExtendedMonth;
    public Integer ExtendedMonthNumber;
    public List<Assessment__c> lstAssessment = new List<Assessment__c>();
   
    public List<Assessment__c> lstMatchAssessment = new List<Assessment__c>();
        
    public AssessmentBulkCreateController() { }
      public Integer GetSCExtendedCount(Match__c match,String ExtendedMonth){
         Integer intCount;
         if(match.Engagement__r.Prog_Duration_Extended__c == true)
         {
             if (ExtendedMonth == 'August'||ExtendedMonth == 'September')
            intCount = 2;
            else if (ExtendedMonth == 'October'||ExtendedMonth == 'November')
            intCount = 1;
            else
            intcount= 2;
         }
         return intCount;
      }
    public Integer GetSCStartingCount(Match__c match,String StartMonth){
        Integer intCount;
       
        if(match.Engagement__r.Program_Duration__c == 'Academic Year')
        {
            if (StartMonth == 'August'||StartMonth == 'September')
            intCount = 4;
            else if (StartMonth == 'October'||StartMonth == 'November')
            intCount = 3;
            else if (StartMonth == 'December'||StartMonth == 'January'||StartMonth == 'February')
            intCount = 2; 
            else if (StartMonth == 'March'||StartMonth == 'April'||StartMonth == 'May')
            intCount = 1;                
            else 
            intCount = 4;
        }
        //AA Adding SC Spring Semester 
        else if (match.Engagement__r.Program_Duration__c == 'Spring Semester'){
            if (StartMonth == 'December'||StartMonth == 'January'||StartMonth == 'February')
            intCount = 2; 
            else if (StartMonth == 'March'||StartMonth == 'April'||StartMonth == 'May')
            intCount = 1;
            else
            intcount= 2;
        }

        //AA Adding SC Fall Semester
        else if (match.Engagement__r.Program_Duration__c == 'Fall Semester'){
            if (StartMonth == 'August'||StartMonth == 'September')
            intCount = 2;
            else if (StartMonth == 'October'||StartMonth == 'November')
            intCount = 1;
            else
            intcount= 2;
        }
         
        return intcount;
       }   
        public Integer GetExtendedCount(Match__c match,String ExtendedMonth)
        {
            Integer intCount;
         if(match.Engagement__r.Prog_Duration_Extended__c == true)
         {
             if (ExtendedMonth == 'August')
            intCount = 6;
            else if (ExtendedMonth == 'September')
            intCount = 5;
            else if (ExtendedMonth == 'October')
            intCount = 4;
            else if (ExtendedMonth == 'November')
            intCount = 3;
            else if (ExtendedMonth == 'December')
            intCount = 2;
            else if (ExtendedMonth == 'January')
            intCount = 1;
            else
            intCount=6;
         }
         return intCount;
        } 
      public Integer GetStartingCount(Match__c match,String StartMonth)
      {
        Integer intCount;
        
        if(match.Engagement__r.Program_Duration__c == 'Academic Year' )
        {
            if (StartMonth == 'August')
            intCount = 11;
            else if (StartMonth == 'September')
            intCount = 10;
            else if (StartMonth == 'October')
            intCount = 9;
            else if (StartMonth == 'November')
            intCount = 8;
            else if (StartMonth == 'December')
            intCount = 7;
            else if (StartMonth == 'January')
            intCount = 6;
            else if (StartMonth == 'February')
            intCount = 5;
            else if (StartMonth == 'March')
            intCount = 4;
            else if (StartMonth == 'April')
            intCount = 3;
            else if (StartMonth == 'May')
            intCount = 2;
            else if (StartMonth == 'June')
            intCount = 1;     
            else
            intCount = 11;      
            
        }
        else if (match.Engagement__r.Program_Duration__c == 'Spring Semester'){
        if (StartMonth == 'January')
            intCount = 6;
            else if (StartMonth == 'February')
            intCount = 5;
            else if (StartMonth == 'March')
            intCount = 4;
            else if (StartMonth == 'April')
            intCount = 3;
            else if (StartMonth == 'May')
            intCount = 2;
            else if (StartMonth == 'June')
            intCount = 1;
            else
            intCount = 6;            
        }
         else if (match.Engagement__r.Program_Duration__c == 'Fall Semester') 
        {
           if (StartMonth == 'August')
            intCount = 6;
            else if (StartMonth == 'September')
            intCount = 5;
            else if (StartMonth == 'October')
            intCount = 4;
            else if (StartMonth == 'November')
            intCount = 3;
            else if (StartMonth == 'December')
            intCount = 2;
            else if (StartMonth == 'January')
            intCount = 1;
            else
            intCount=6;
        }
         
        return intCount;
      }
        public string GetSCExtendedTimePeriod(Match__c match,Integer intCountDown)
      { 
          string monthName;
          if(intCountDown == 2)
         monthName = 'September';
         else if(intCountDown == 1)
         monthName = 'November';
          return monthName;
      }
       public string GetSCTimePeriod(Match__c match,Integer intCountDown)
      {
         string monthName;
        if(match.Engagement__r.Program_Duration__c == 'Academic Year')
        {
        if(intCountDown == 4)
         monthName = 'September'; 
        else if(intCountDown == 3)
         monthName = 'November'; 
        else if(intCountDown == 2)
         monthName = 'February'; 
        else if(intCountDown == 1)
         monthName = 'May'; 
        }
        
        //AA Adding SC Fall andSpring conditions
        
        else if (match.Engagement__r.Program_Duration__c == 'Spring Semester'){
         if(intCountDown == 2)
         monthName = 'February';
         else if(intCountDown == 1)
         monthName = 'May';
        }
        else if (match.Engagement__r.Program_Duration__c == 'Fall Semester'){
         if(intCountDown == 2)
         monthName = 'September';
         else if(intCountDown == 1)
         monthName = 'November';
        }
        
        return monthName;
      }
        public String GetAssRecordTypeId(Match__c match,String TimePeriod,String RecordTypeGroup)
      {
        String subRecordType;
        if(match.Engagement__r.Program_Duration__c == 'Academic Year' && RecordTypeGroup == 'AY HF Contact')
        {
             if(Constants.ASS_HF_CONTACT_YEAR_RECORDTYPES.containsKey(TimePeriod)) 
              {
                subRecordType=Constants.ASS_HF_CONTACT_YEAR_RECORDTYPES.get(TimePeriod);
                System.debug('####### subRecordType' +subRecordType); 
              }                  
        } 
        else if(match.Engagement__r.Program_Duration__c == 'Academic Year' && RecordTypeGroup == 'AY PT Contact')
        {
             if(Constants.ASS_PT_CONTACT_YEAR_RECORDTYPES.containsKey(TimePeriod)) 
              {
                subRecordType=Constants.ASS_PT_CONTACT_YEAR_RECORDTYPES.get(TimePeriod);
                System.debug('####### subRecordType' +subRecordType); 
              }                  
        }  
        else if(match.Engagement__r.Program_Duration__c == 'Academic Year' && RecordTypeGroup == 'AY SC Contact')
        {
             if(Constants.ASS_SC_CONTACT_RECORDTYPES.containsKey(TimePeriod)) 
              {
                subRecordType=Constants.ASS_SC_CONTACT_RECORDTYPES.get(TimePeriod);
                System.debug('####### subRecordType' +subRecordType); 
              }                  
        }  
        else if(match.Engagement__r.Program_Duration__c == 'Spring Semester' && RecordTypeGroup == 'AY HF Contact')
        {
             if(Constants.ASS_HF_CONTACT_S2_RECORDTYPES.containsKey(TimePeriod)) 
              {
                subRecordType=Constants.ASS_HF_CONTACT_S2_RECORDTYPES.get(TimePeriod);
                System.debug('####### subRecordType' +subRecordType); 
              }                  
        }  
        else if(match.Engagement__r.Program_Duration__c == 'Spring Semester' && RecordTypeGroup == 'AY PT Contact')
        {
             if(Constants.ASS_PT_CONTACT_S2_RECORDTYPES.containsKey(TimePeriod)) 
              {
                subRecordType=Constants.ASS_PT_CONTACT_S2_RECORDTYPES.get(TimePeriod);
                System.debug('####### subRecordType' +subRecordType); 
              }                  
        } 
        
        //AA Adding Spring Semester for AY SC Contact
        else if(match.Engagement__r.Program_Duration__c == 'Spring Semester' && RecordTypeGroup == 'AY SC Contact')
        {
             if(Constants.ASS_SC_CONTACT_S2_RECORDTYPES.containsKey(TimePeriod)) 
              {
                subRecordType=Constants.ASS_SC_CONTACT_S2_RECORDTYPES.get(TimePeriod);
                System.debug('####### subRecordType' +subRecordType); 
              }                  
        }  
        else if(match.Engagement__r.Program_Duration__c == 'Fall Semester' && RecordTypeGroup == 'AY HF Contact')
        {
             if(Constants.ASS_HF_CONTACT_S1_RECORDTYPES.containsKey(TimePeriod)) 
              {
                subRecordType=Constants.ASS_HF_CONTACT_S1_RECORDTYPES.get(TimePeriod);
                System.debug('####### subRecordType' +subRecordType); 
              }                  
        }      
        else if(match.Engagement__r.Program_Duration__c == 'Fall Semester' && RecordTypeGroup == 'AY PT Contact')
        {
             if(Constants.ASS_PT_CONTACT_S1_RECORDTYPES.containsKey(TimePeriod)) 
              {
                subRecordType=Constants.ASS_PT_CONTACT_S1_RECORDTYPES.get(TimePeriod);
                System.debug('####### subRecordType' +subRecordType); 
              }                  
        }
        
        //AA Adding Fall Semester for AY SC Contact
        else if(match.Engagement__r.Program_Duration__c == 'Fall Semester' && RecordTypeGroup == 'AY SC Contact')
        {
             if(Constants.ASS_SC_CONTACT_S1_RECORDTYPES.containsKey(TimePeriod)) 
              {
                subRecordType=Constants.ASS_SC_CONTACT_S1_RECORDTYPES.get(TimePeriod);
                System.debug('####### subRecordType' +subRecordType); 
              }                  
        } 
              
                 
        return subRecordType;    
        
      }
      public string GetExtendedMonthName(Match__c match,Integer intCountDown)
      {
        string monthName;       
          if(intCountDown >= 6)
         monthName = 'August'; 
        else if(intCountDown == 5)
         monthName = 'September'; 
        else if(intCountDown == 4)
         monthName = 'October'; 
        else if(intCountDown == 3)
         monthName = 'November'; 
        else if(intCountDown == 2)
         monthName = 'December'; 
        else if(intCountDown == 1)
         monthName = 'January';  
         
         return monthName;              
      }
      public string GetMonthName(Match__c match,Integer intCountDown)
      {
        string monthName;
       
        if(match.Engagement__r.Program_Duration__c == 'Spring Semester' || match.Engagement__r.Program_Duration__c == 'Academic Year')
        {
        if(intCountDown == 11)
         monthName = 'August'; 
        else if(intCountDown == 10)
         monthName = 'September'; 
        else if(intCountDown == 9)
         monthName = 'October'; 
        else if(intCountDown == 8)
         monthName = 'November'; 
        else if(intCountDown == 7)
         monthName = 'December'; 
        else if(intCountDown == 6)
         monthName = 'January'; 
        else if(intCountDown == 5)
         monthName = 'February'; 
        else if(intCountDown == 4)
         monthName = 'March'; 
        else if(intCountDown == 3)
         monthName = 'April'; 
        else if(intCountDown == 2)
         monthName = 'May'; 
        else if(intCountDown == 1)
         monthName = 'June'; 
        }
        else if(match.Engagement__r.Program_Duration__c == 'Fall Semester') 
        {
            if(intCountDown == 6)
             monthName = 'August'; 
            else if(intCountDown == 5)
             monthName = 'September'; 
            else if(intCountDown == 4)
             monthName = 'October'; 
            else if(intCountDown == 3)
             monthName = 'November'; 
            else if(intCountDown == 2)
             monthName = 'December'; 
           else if(intCountDown == 1)
             monthName = 'January'; 
        
        }
        return monthName;
      }
       public string GetStartMonthName(Integer StartMonthNumber)
      {
        string startMonthName;
        if(StartMonthNumber == 12)
        startMonthName = 'December';
        else if(StartMonthNumber == 11)
        startMonthName = 'November';
         else if(StartMonthNumber == 10)
        startMonthName = 'October';
         else if(StartMonthNumber == 9)
        startMonthName = 'September';
         else if(StartMonthNumber == 8)
        startMonthName = 'August';
         else if(StartMonthNumber == 7)
        startMonthName = 'July';
         else if(StartMonthNumber == 6)
        startMonthName = 'June';
         else if(StartMonthNumber == 5)
        startMonthName = 'May';
         else if(StartMonthNumber == 4)
        startMonthName = 'April';
         else if(StartMonthNumber == 3)
        startMonthName = 'March';
         else if(StartMonthNumber == 2)
        startMonthName = 'February';
         else if(StartMonthNumber == 1)
        startMonthName = 'January';
       
       return startMonthName;
        }
     
      public Assessment__c CreatePTAssessment(Match__c match,Integer Countdown, Id Owner)
      {
         string TimePeriod ;
          // if(match.Engagement__r.Prog_Duration_Extended__c)           
          //  TimePeriod = GetExtendedMonthName(match,Countdown);           
         //  else
            TimePeriod = GetMonthName(match,Countdown);
             system.debug('*****TimePeriod*****'+TimePeriod);
              Assessment__c ObjAssessmentPT = new  Assessment__c();
               ObjAssessmentPT.Match_Name__c =match.id;
               ObjAssessmentPT.Engagement__c = match.Engagement__c;
               ObjAssessmentPT.Position_Name__c = match.Position_Name__r.Id;
               ObjAssessmentPT.Participant_Name__c = match.Participant_Id__c;
               ObjAssessmentPT.Host_Name__c = match.Position_Name__r.Host_Company_Id__c;
               ObjAssessmentPT.Count_Down__c = Countdown;             
               ObjAssessmentPT.Time_Period__c = TimePeriod;
               ObjAssessmentPT.OwnerId = Owner;
               system.debug('*****Time_Period__c*********'+TimePeriod);                     
               ObjAssessmentPT.Name = match.Name + ' PTC';  
               ObjAssessmentPT.Record_Type_Group__c = 'AY PT Contact'; 
               ObjAssessmentPT.RecordTypeId = GetAssRecordTypeId(match,TimePeriod,'AY PT Contact');              
               return ObjAssessmentPT;
      }
        public Assessment__c CreateSCAssessment(Match__c match,Integer Countdown, Id Owner)
      {
               string TimePeriod;
                //  if(match.Engagement__r.Prog_Duration_Extended__c)           
                //    TimePeriod =  GetSCExtendedTimePeriod(match,Countdown);            
                 //  else
                    TimePeriod =  GetSCTimePeriod(match,Countdown); 
             
              Assessment__c ObjAssessmentSC = new  Assessment__c();
               ObjAssessmentSC.Match_Name__c =match.id;
               ObjAssessmentSC.Engagement__c = match.Engagement__c;
               ObjAssessmentSC.Position_Name__c = match.Position_Name__r.Id;
               ObjAssessmentSC.Participant_Name__c = match.Participant_Id__c;
               ObjAssessmentSC.Host_Name__c = match.Position_Name__r.Host_Company_Id__c;
               ObjAssessmentSC.Count_Down__c = Countdown;             
               ObjAssessmentSC.Time_Period__c = TimePeriod;  
               ObjAssessmentSC.Name = match.Name + ' SCC';         
               ObjAssessmentSC.Record_Type_Group__c = 'AY SC Contact';
               ObjAssessmentSC.RecordTypeId = GetAssRecordTypeId(match,TimePeriod,'AY SC Contact');  
               ObjAssessmentSC.OwnerId = Owner;
               return ObjAssessmentSC;
      }
        public Assessment__c UpdatePTAssessment(Match__c match,Integer Countdown,Id Owner)
      {              
               string TimePeriod;
          if(match.Engagement__r.Prog_Duration_Extended__c)           
            TimePeriod = GetExtendedMonthName(match,Countdown);           
           else
            TimePeriod = GetMonthName(match,Countdown);
              
              system.debug('*****TimePeriod*****'+TimePeriod);
               system.debug('*****Countdown*****'+Countdown);
              List<Assessment__c> ObjAssessmentPT;
              ObjAssessmentPT =[Select a.Wrap_Up_Complete_Indicated__c, a.Wrap_Up_Complete_Description__c, a.Validation_Counter__c, 
              a.Upcoming_Separation_Positive__c, a.Upcoming_Separation_Description__c, a.Travel_Arrangements_Indicated__c, a.Time_Period__c, a.SystemModstamp, a.Study_Area__c, a.Storage_Area__c, a.School_Curriculum_Positive__c, a.School_Adjustment_Positive__c, a.School_Adjustment_Description__c, a.Safety_Hazards__c, a.Safety_Hazards_Description__c, a.Return_Expectations__c, a.Return_Challenges__c, a.Resident_Total__c,
              a.Resident_Participants__c, a.Resident_Change_Indicated__c, a.Resident_Change_Description__c, a.Resident_Adults__c,
              a.Representative__c, a.Repeat_Interest_Indicated__c, a.Repeat_Interest_Description__c,a.Record_Type_Group__c,a.Program_Satisfaction_Positive__c,
              a.Program_Satisfaction_Description__c, a.Program_Impact_Description__c, a.Program_End_Feeling__c, a.Position_Name__c, a.Participant_change_Description__c,
              a.Participant_Name__c, a.Participant_Change_Positive__c, a.Participant_Advice__c, a.OwnerId, a.Overall_Assessment__c, a.Name, a.Month_Number__c, 
              a.Match_Name__c, a.Last_School_Day__c, a.LastModifiedDate, a.LastModifiedById, a.IsDeleted, a.Insurance_Info_Received__c, a.Initial_Impressions__c, a.Initial_Experience_Positive__c,
              a.Initial_Experience_Description__c, a.In_Touch_Balance_Positive__c, a.In_Touch_Balance_Description__c, a.Id, a.IEW_Participation_Indicated__c, a.Host_Name__c, a.Host_Memories__c,
              a.Holiday_Planning_Positive__c, a.Holiday_Planning_Description__c, a.Future_Contact_Plan_Positive__c, a.Friendship_Development_Positive__c, a.Friendship_Development_Description__c, a.First_Return_Activity__c,
              a.Feeling_Uncomfortable__c, a.Feeling_Uncomfortable_Description__c, a.Feeling_Homesick__c, a.Family_Dynamics_Positive__c, a.Family_Bonding_Positive__c, a.Family_Bonding_Description__c, a.Expectations_for_Year__c,
              a.Exchange_Learning_Positive__c, a.Exchange_Learning_Description__c, a.Exchange_Experience_Summary__c, a.Engagement__c, a.Departure_Ready_Indicated__c, a.CurrencyIsoCode, a.CreatedDate, a.CreatedById, a.Count_Down__c,
              a.Contact_Type__c, a.ConnectionSentId, a.ConnectionReceivedId, a.Community_Service_Indicated__c, a.Community_Service_Description__c, a.Communication_Description__c, a.Comments__c, a.Cleanliness__c, a.Cleanliness_Description__c,
              a.Bedroom_Sharing__c, a.Bedroom_Privacy__c, a.Bed_Type__c, a.Assessment_Date__c,a.Airport__c, a.Adjusting_Positive__c,
              a.Adjusting_Description__c,a.ManualShareExists__c, a.Additional_Support_Requested__c, a.Additional_Support_Description__c From Assessment__c a where a.Participant_Name__c=:match.Participant_Id__c  and a.count_down__c=:Countdown and a.Record_Type_Group__c ='AY PT Contact' and (a.status__c!='Confirmed' or a.status__c!='Completed') limit 1];
               system.debug('*****ObjAssessmentPT*****'+ObjAssessmentPT);
              if(ObjAssessmentPT!=null && ObjAssessmentPT.size()>0)
              {              
               ObjAssessmentPT[0].Match_Name__c =match.id;
               ObjAssessmentPT[0].Engagement__c = match.Engagement__c;
               ObjAssessmentPT[0].Position_Name__c = match.Position_Name__r.Id;
               ObjAssessmentPT[0].Participant_Name__c = match.Participant_Id__c;
               ObjAssessmentPT[0].Host_Name__c = match.Position_Name__r.Host_Company_Id__c;
               ObjAssessmentPT[0].Record_Type_Group__c = 'AY PT Contact';
               ObjAssessmentPT[0].Count_Down__c = Countdown;              
               ObjAssessmentPT[0].Time_Period__c = TimePeriod;
               ObjAssessmentPT[0].Name = match.Name + ' PTC'; 
               ObjAssessmentPT[0].ManualShareExists__c = false; 
               ObjAssessmentPT[0].OwnerId = Owner;
               ObjAssessmentPT[0].RecordTypeId = GetAssRecordTypeId(match,TimePeriod,'AY PT Contact');
              return ObjAssessmentPT[0];
              }                     
               else
               {
                 system.debug('*****ObjAssessmentPT*****'+ObjAssessmentPT);      
                return null;
               }
      }
          public Assessment__c  UpdateSCAssessment(Match__c match,Integer Countdown,string prevPTHost,Id Owner)
      {
                 string TimePeriod;
          if(match.Engagement__r.Prog_Duration_Extended__c)           
            TimePeriod = GetSCExtendedTimePeriod(match,Countdown);           
           else
            TimePeriod = GetSCTimePeriod(match,Countdown);
             List<Assessment__c> ObjAssessmentSC;
             ObjAssessmentSC =[Select a.Wrap_Up_Complete_Indicated__c, a.Wrap_Up_Complete_Description__c, a.Validation_Counter__c, 
              a.Upcoming_Separation_Positive__c, a.Upcoming_Separation_Description__c, a.Travel_Arrangements_Indicated__c, a.Time_Period__c, a.SystemModstamp, a.Study_Area__c, a.Storage_Area__c, a.School_Curriculum_Positive__c, a.School_Adjustment_Positive__c, a.School_Adjustment_Description__c, a.Safety_Hazards__c, a.Safety_Hazards_Description__c, a.Return_Expectations__c, a.Return_Challenges__c, a.Resident_Total__c,
              a.Resident_Participants__c, a.Resident_Change_Indicated__c, a.Resident_Change_Description__c, a.Resident_Adults__c,
              a.Representative__c, a.Repeat_Interest_Indicated__c, a.Repeat_Interest_Description__c,a.Record_Type_Group__c,a.Program_Satisfaction_Positive__c,
              a.Program_Satisfaction_Description__c, a.Program_Impact_Description__c, a.Program_End_Feeling__c, a.Position_Name__c, a.Participant_change_Description__c,
              a.Participant_Name__c, a.Participant_Change_Positive__c, a.Participant_Advice__c, a.OwnerId, a.Overall_Assessment__c, a.Name, a.Month_Number__c, 
              a.Match_Name__c, a.Last_School_Day__c, a.LastModifiedDate, a.LastModifiedById, a.IsDeleted, a.Insurance_Info_Received__c, a.Initial_Impressions__c, a.Initial_Experience_Positive__c,
              a.Initial_Experience_Description__c, a.In_Touch_Balance_Positive__c, a.In_Touch_Balance_Description__c, a.Id, a.IEW_Participation_Indicated__c, a.Host_Name__c, a.Host_Memories__c,
              a.Holiday_Planning_Positive__c, a.Holiday_Planning_Description__c, a.Future_Contact_Plan_Positive__c, a.Friendship_Development_Positive__c, a.Friendship_Development_Description__c, a.First_Return_Activity__c,
              a.Feeling_Uncomfortable__c, a.Feeling_Uncomfortable_Description__c, a.Feeling_Homesick__c, a.Family_Dynamics_Positive__c, a.Family_Bonding_Positive__c, a.Family_Bonding_Description__c, a.Expectations_for_Year__c,
              a.Exchange_Learning_Positive__c, a.Exchange_Learning_Description__c, a.Exchange_Experience_Summary__c, a.Engagement__c, a.Departure_Ready_Indicated__c, a.CurrencyIsoCode, a.CreatedDate, a.CreatedById, a.Count_Down__c,
              a.Contact_Type__c, a.ConnectionSentId, a.ConnectionReceivedId, a.Community_Service_Indicated__c, a.Community_Service_Description__c, a.Communication_Description__c, a.Comments__c, a.Cleanliness__c, a.Cleanliness_Description__c,
              a.Bedroom_Sharing__c, a.Bedroom_Privacy__c, a.Bed_Type__c, a.Assessment_Date__c,a.Airport__c, a.Adjusting_Positive__c,
              a.Adjusting_Description__c,a.ManualShareExists__c, a.Additional_Support_Requested__c, a.Additional_Support_Description__c From Assessment__c a where a.Participant_Name__c=:match.Participant_Id__c  and a.Host_Name__c=:prevPTHost and a.count_down__c=:Countdown and a.Record_Type_Group__c ='AY SC Contact' and (a.status__c!='Confirmed' or a.status__c!='Completed')];
               
             if(ObjAssessmentSC!=null && ObjAssessmentSC.size()>0)
             {              
               ObjAssessmentSC[0].Match_Name__c =match.id;
               ObjAssessmentSC[0].Engagement__c = match.Engagement__c;
               ObjAssessmentSC[0].Position_Name__c = match.Position_Name__r.Id;
               ObjAssessmentSC[0].Participant_Name__c = match.Participant_Id__c;
               ObjAssessmentSC[0].Host_Name__c = match.Position_Name__r.Host_Company_Id__c;
               ObjAssessmentSC[0].Record_Type_Group__c = 'AY SC Contact';
               ObjAssessmentSC[0].Count_Down__c = Countdown;              
               ObjAssessmentSC[0].Time_Period__c = TimePeriod;
               ObjAssessmentSC[0].Name = match.Name + ' SCC'; 
                 ObjAssessmentSC[0].ManualShareExists__c = false;    
                ObjAssessmentSC[0].OwnerId = Owner;
                ObjAssessmentSC[0].RecordTypeId = GetAssRecordTypeId(match,TimePeriod,'AY SC Contact');
                 return ObjAssessmentSC[0];              
             }
             else
               return null;
      }
    
        public Assessment__c UpdateHFAssessment(Match__c match,Integer Countdown, string prevPTHost,Id Owner)
      {
        system.debug('****match******'+match.Position_Name__r.Host_Company_Id__c);
        system.debug('****Countdown******'+Countdown);
          string TimePeriod;
          if(match.Engagement__r.Prog_Duration_Extended__c)           
            TimePeriod = GetExtendedMonthName(match,Countdown);           
           else
            TimePeriod = GetMonthName(match,Countdown);
             List<Assessment__c> ObjAssessmentHF;
             ObjAssessmentHF =[Select a.Wrap_Up_Complete_Indicated__c, a.Wrap_Up_Complete_Description__c, a.Validation_Counter__c, 
              a.Upcoming_Separation_Positive__c, a.Upcoming_Separation_Description__c, a.Travel_Arrangements_Indicated__c, a.Time_Period__c, a.SystemModstamp, a.Study_Area__c, a.Storage_Area__c,a.School_Curriculum_Positive__c, a.School_Adjustment_Positive__c, a.School_Adjustment_Description__c, a.Safety_Hazards__c, a.Safety_Hazards_Description__c, a.Return_Expectations__c, a.Return_Challenges__c, a.Resident_Total__c,
              a.Resident_Participants__c, a.Resident_Change_Indicated__c, a.Resident_Change_Description__c, a.Resident_Adults__c,
              a.Representative__c, a.Repeat_Interest_Indicated__c, a.Repeat_Interest_Description__c,a.Record_Type_Group__c,a.Program_Satisfaction_Positive__c,
              a.Program_Satisfaction_Description__c, a.Program_Impact_Description__c, a.Program_End_Feeling__c, a.Position_Name__c, a.Participant_change_Description__c,
              a.Participant_Name__c, a.Participant_Change_Positive__c, a.Participant_Advice__c, a.OwnerId, a.Overall_Assessment__c, a.Name, a.Month_Number__c,
              a.Match_Name__c, a.Last_School_Day__c, a.LastModifiedDate, a.LastModifiedById, a.IsDeleted, a.Insurance_Info_Received__c, a.Initial_Impressions__c, a.Initial_Experience_Positive__c,
              a.Initial_Experience_Description__c, a.In_Touch_Balance_Positive__c, a.In_Touch_Balance_Description__c, a.Id, a.IEW_Participation_Indicated__c, a.Host_Name__c, a.Host_Memories__c, 
              a.Holiday_Planning_Positive__c, a.Holiday_Planning_Description__c, a.Future_Contact_Plan_Positive__c, a.Friendship_Development_Positive__c, a.Friendship_Development_Description__c, a.First_Return_Activity__c,
              a.Feeling_Uncomfortable__c, a.Feeling_Uncomfortable_Description__c, a.Feeling_Homesick__c, a.Family_Dynamics_Positive__c, a.Family_Bonding_Positive__c, a.Family_Bonding_Description__c, a.Expectations_for_Year__c,
              a.Exchange_Learning_Positive__c, a.Exchange_Learning_Description__c, a.Exchange_Experience_Summary__c, a.Engagement__c, a.Departure_Ready_Indicated__c, a.CurrencyIsoCode, a.CreatedDate, a.CreatedById, a.Count_Down__c,
              a.Contact_Type__c, a.ConnectionSentId, a.ConnectionReceivedId, a.Community_Service_Indicated__c, a.Community_Service_Description__c, a.Communication_Description__c, a.Comments__c, a.Cleanliness__c, a.Cleanliness_Description__c,
              a.Bedroom_Sharing__c, a.Bedroom_Privacy__c, a.Bed_Type__c, a.Assessment_Date__c,a.Airport__c, a.Adjusting_Positive__c,
              a.Adjusting_Description__c,a.ManualShareExists__c, a.Additional_Support_Requested__c, a.Additional_Support_Description__c From Assessment__c a where a.Host_Name__c=:prevPTHost and a.count_down__c=:Countdown and a.Record_Type_Group__c ='AY HF Contact' and a.Participant_Name__c =:match.Participant_Id__c and (a.status__c!='Confirmed' or a.status__c!='Completed') LIMIT 1];
              
             if(ObjAssessmentHF!=null && ObjAssessmentHF.size()>0)
             {
               ObjAssessmentHF[0].Match_Name__c =match.id;
               ObjAssessmentHF[0].Engagement__c = match.Engagement__c;
               ObjAssessmentHF[0].Position_Name__c = match.Position_Name__r.Id;
               ObjAssessmentHF[0].Host_Name__c = match.Position_Name__r.Host_Company_Id__c;
               ObjAssessmentHF[0].Participant_Name__c =match.Participant_Id__c;
               ObjAssessmentHF[0].Record_Type_Group__c = 'AY HF Contact';
               ObjAssessmentHF[0].Count_Down__c = Countdown;            
               ObjAssessmentHF[0].Time_Period__c = TimePeriod;
               ObjAssessmentHF[0].Name = match.Name + ' HFC'; 
               ObjAssessmentHF[0].ManualShareExists__c = false;  
               ObjAssessmentHF[0].RecordTypeId = GetAssRecordTypeId(match,TimePeriod,'AY HF Contact');     
               ObjAssessmentHF[0].OwnerId = Owner;
                return ObjAssessmentHF[0];
             }
             else
               return null;
             
      }
      
         public Assessment__c UpdatePTAssessment(Match__c match,Integer Countdown,Id Owner,Integer IntStartingCount)
      {              
               string TimePeriod;
          if(match.Engagement__r.Prog_Duration_Extended__c)           
            TimePeriod = GetExtendedMonthName(match,Countdown);           
           else
            TimePeriod = GetMonthName(match,Countdown);
              
              system.debug('*****TimePeriod*****'+TimePeriod);
               system.debug('*****Countdown*****'+Countdown);
              List<Assessment__c> ObjAssessmentPT;
              ObjAssessmentPT =[Select a.Wrap_Up_Complete_Indicated__c, a.Wrap_Up_Complete_Description__c, a.Validation_Counter__c, 
              a.Upcoming_Separation_Positive__c, a.Upcoming_Separation_Description__c, a.Travel_Arrangements_Indicated__c, a.Time_Period__c, a.SystemModstamp, a.Study_Area__c, a.Storage_Area__c, a.School_Curriculum_Positive__c, a.School_Adjustment_Positive__c, a.School_Adjustment_Description__c, a.Safety_Hazards__c, a.Safety_Hazards_Description__c, a.Return_Expectations__c, a.Return_Challenges__c, a.Resident_Total__c,
              a.Resident_Participants__c, a.Resident_Change_Indicated__c, a.Resident_Change_Description__c, a.Resident_Adults__c,
              a.Representative__c, a.Repeat_Interest_Indicated__c, a.Repeat_Interest_Description__c,a.Record_Type_Group__c,a.Program_Satisfaction_Positive__c,
              a.Program_Satisfaction_Description__c, a.Program_Impact_Description__c, a.Program_End_Feeling__c, a.Position_Name__c, a.Participant_change_Description__c,
              a.Participant_Name__c, a.Participant_Change_Positive__c, a.Participant_Advice__c, a.OwnerId, a.Overall_Assessment__c, a.Name, a.Month_Number__c, 
              a.Match_Name__c, a.Last_School_Day__c, a.LastModifiedDate, a.LastModifiedById, a.IsDeleted, a.Insurance_Info_Received__c, a.Initial_Impressions__c, a.Initial_Experience_Positive__c,
              a.Initial_Experience_Description__c, a.In_Touch_Balance_Positive__c, a.In_Touch_Balance_Description__c, a.Id, a.IEW_Participation_Indicated__c, a.Host_Name__c, a.Host_Memories__c,
              a.Holiday_Planning_Positive__c, a.Holiday_Planning_Description__c, a.Future_Contact_Plan_Positive__c, a.Friendship_Development_Positive__c, a.Friendship_Development_Description__c, a.First_Return_Activity__c,
              a.Feeling_Uncomfortable__c, a.Feeling_Uncomfortable_Description__c, a.Feeling_Homesick__c, a.Family_Dynamics_Positive__c, a.Family_Bonding_Positive__c, a.Family_Bonding_Description__c, a.Expectations_for_Year__c,
              a.Exchange_Learning_Positive__c, a.Exchange_Learning_Description__c, a.Exchange_Experience_Summary__c, a.Engagement__c, a.Departure_Ready_Indicated__c, a.CurrencyIsoCode, a.CreatedDate, a.CreatedById, a.Count_Down__c,
              a.Contact_Type__c, a.ConnectionSentId, a.ConnectionReceivedId, a.Community_Service_Indicated__c, a.Community_Service_Description__c, a.Communication_Description__c, a.Comments__c, a.Cleanliness__c, a.Cleanliness_Description__c,
              a.Bedroom_Sharing__c, a.Bedroom_Privacy__c, a.Bed_Type__c, a.Assessment_Date__c,a.Airport__c, a.Adjusting_Positive__c,
              a.Adjusting_Description__c,a.ManualShareExists__c, a.Additional_Support_Requested__c, a.Additional_Support_Description__c From Assessment__c a where a.Participant_Name__c=:match.Participant_Id__c  and a.count_down__c=:Countdown and a.Record_Type_Group__c ='AY PT Contact' and (a.status__c!='Confirmed' or a.status__c!='Completed') limit 1];
               system.debug('*****ObjAssessmentPT*****'+ObjAssessmentPT);
              if(ObjAssessmentPT!=null && ObjAssessmentPT.size()>0)
              {              
               ObjAssessmentPT[0].Match_Name__c =match.id;
               ObjAssessmentPT[0].Engagement__c = match.Engagement__c;
               ObjAssessmentPT[0].Position_Name__c = match.Position_Name__r.Id;
               ObjAssessmentPT[0].Participant_Name__c = match.Participant_Id__c;
               ObjAssessmentPT[0].Host_Name__c = match.Position_Name__r.Host_Company_Id__c;
               ObjAssessmentPT[0].Record_Type_Group__c = 'AY PT Contact';
               ObjAssessmentPT[0].Count_Down__c = IntStartingCount;              
               ObjAssessmentPT[0].Time_Period__c = TimePeriod;
               ObjAssessmentPT[0].Name = match.Name + ' PTC'; 
               ObjAssessmentPT[0].ManualShareExists__c = false; 
               ObjAssessmentPT[0].OwnerId = Owner;
               ObjAssessmentPT[0].RecordTypeId = GetAssRecordTypeId(match,TimePeriod,'AY PT Contact');
              return ObjAssessmentPT[0];
              }                     
               else
               {
                 system.debug('*****ObjAssessmentPT*****'+ObjAssessmentPT);      
                return null;
               }
      }
          public Assessment__c  UpdateSCAssessment(Match__c match,Integer Countdown,string prevPTHost,Id Owner,Integer IntStartingCount)
      {
                 string TimePeriod;
          if(match.Engagement__r.Prog_Duration_Extended__c)           
            TimePeriod = GetSCExtendedTimePeriod(match,Countdown);           
           else
            TimePeriod = GetSCTimePeriod(match,Countdown);
             List<Assessment__c> ObjAssessmentSC;
             ObjAssessmentSC =[Select a.Wrap_Up_Complete_Indicated__c, a.Wrap_Up_Complete_Description__c, a.Validation_Counter__c, 
              a.Upcoming_Separation_Positive__c, a.Upcoming_Separation_Description__c, a.Travel_Arrangements_Indicated__c, a.Time_Period__c, a.SystemModstamp, a.Study_Area__c, a.Storage_Area__c, a.School_Curriculum_Positive__c, a.School_Adjustment_Positive__c, a.School_Adjustment_Description__c, a.Safety_Hazards__c, a.Safety_Hazards_Description__c, a.Return_Expectations__c, a.Return_Challenges__c, a.Resident_Total__c,
              a.Resident_Participants__c, a.Resident_Change_Indicated__c, a.Resident_Change_Description__c, a.Resident_Adults__c,
              a.Representative__c, a.Repeat_Interest_Indicated__c, a.Repeat_Interest_Description__c,a.Record_Type_Group__c,a.Program_Satisfaction_Positive__c,
              a.Program_Satisfaction_Description__c, a.Program_Impact_Description__c, a.Program_End_Feeling__c, a.Position_Name__c, a.Participant_change_Description__c,
              a.Participant_Name__c, a.Participant_Change_Positive__c, a.Participant_Advice__c, a.OwnerId, a.Overall_Assessment__c, a.Name, a.Month_Number__c, 
              a.Match_Name__c, a.Last_School_Day__c, a.LastModifiedDate, a.LastModifiedById, a.IsDeleted, a.Insurance_Info_Received__c, a.Initial_Impressions__c, a.Initial_Experience_Positive__c,
              a.Initial_Experience_Description__c, a.In_Touch_Balance_Positive__c, a.In_Touch_Balance_Description__c, a.Id, a.IEW_Participation_Indicated__c, a.Host_Name__c, a.Host_Memories__c,
              a.Holiday_Planning_Positive__c, a.Holiday_Planning_Description__c, a.Future_Contact_Plan_Positive__c, a.Friendship_Development_Positive__c, a.Friendship_Development_Description__c, a.First_Return_Activity__c,
              a.Feeling_Uncomfortable__c, a.Feeling_Uncomfortable_Description__c, a.Feeling_Homesick__c, a.Family_Dynamics_Positive__c, a.Family_Bonding_Positive__c, a.Family_Bonding_Description__c, a.Expectations_for_Year__c,
              a.Exchange_Learning_Positive__c, a.Exchange_Learning_Description__c, a.Exchange_Experience_Summary__c, a.Engagement__c, a.Departure_Ready_Indicated__c, a.CurrencyIsoCode, a.CreatedDate, a.CreatedById, a.Count_Down__c,
              a.Contact_Type__c, a.ConnectionSentId, a.ConnectionReceivedId, a.Community_Service_Indicated__c, a.Community_Service_Description__c, a.Communication_Description__c, a.Comments__c, a.Cleanliness__c, a.Cleanliness_Description__c,
              a.Bedroom_Sharing__c, a.Bedroom_Privacy__c, a.Bed_Type__c, a.Assessment_Date__c,a.Airport__c, a.Adjusting_Positive__c,
              a.Adjusting_Description__c,a.ManualShareExists__c, a.Additional_Support_Requested__c, a.Additional_Support_Description__c From Assessment__c a where a.Participant_Name__c=:match.Participant_Id__c  and a.Host_Name__c=:prevPTHost and a.count_down__c=:Countdown and a.Record_Type_Group__c ='AY SC Contact' and (a.status__c!='Confirmed' or a.status__c!='Completed')];
               
             if(ObjAssessmentSC!=null && ObjAssessmentSC.size()>0)
             {              
               ObjAssessmentSC[0].Match_Name__c =match.id;
               ObjAssessmentSC[0].Engagement__c = match.Engagement__c;
               ObjAssessmentSC[0].Position_Name__c = match.Position_Name__r.Id;
               ObjAssessmentSC[0].Participant_Name__c = match.Participant_Id__c;
               ObjAssessmentSC[0].Host_Name__c = match.Position_Name__r.Host_Company_Id__c;
               ObjAssessmentSC[0].Record_Type_Group__c = 'AY SC Contact';
               ObjAssessmentSC[0].Count_Down__c = IntStartingCount;              
               ObjAssessmentSC[0].Time_Period__c = TimePeriod;
               ObjAssessmentSC[0].Name = match.Name + ' SCC'; 
                 ObjAssessmentSC[0].ManualShareExists__c = false;    
                ObjAssessmentSC[0].OwnerId = Owner;
                ObjAssessmentSC[0].RecordTypeId = GetAssRecordTypeId(match,TimePeriod,'AY SC Contact');
                 return ObjAssessmentSC[0];              
             }
             else
               return null;
      }
    
        public Assessment__c UpdateHFAssessment(Match__c match,Integer Countdown, string prevPTHost,Id Owner,Integer IntStartingCount)
      {
        system.debug('****match******'+match.Position_Name__r.Host_Company_Id__c);
        system.debug('****Countdown******'+Countdown);
          string TimePeriod;
          if(match.Engagement__r.Prog_Duration_Extended__c)           
            TimePeriod = GetExtendedMonthName(match,Countdown);           
           else
            TimePeriod = GetMonthName(match,Countdown);
             List<Assessment__c> ObjAssessmentHF;
             ObjAssessmentHF =[Select a.Wrap_Up_Complete_Indicated__c, a.Wrap_Up_Complete_Description__c, a.Validation_Counter__c, 
              a.Upcoming_Separation_Positive__c, a.Upcoming_Separation_Description__c, a.Travel_Arrangements_Indicated__c, a.Time_Period__c, a.SystemModstamp, a.Study_Area__c, a.Storage_Area__c,a.School_Curriculum_Positive__c, a.School_Adjustment_Positive__c, a.School_Adjustment_Description__c, a.Safety_Hazards__c, a.Safety_Hazards_Description__c, a.Return_Expectations__c, a.Return_Challenges__c, a.Resident_Total__c,
              a.Resident_Participants__c, a.Resident_Change_Indicated__c, a.Resident_Change_Description__c, a.Resident_Adults__c,
              a.Representative__c, a.Repeat_Interest_Indicated__c, a.Repeat_Interest_Description__c,a.Record_Type_Group__c,a.Program_Satisfaction_Positive__c,
              a.Program_Satisfaction_Description__c, a.Program_Impact_Description__c, a.Program_End_Feeling__c, a.Position_Name__c, a.Participant_change_Description__c,
              a.Participant_Name__c, a.Participant_Change_Positive__c, a.Participant_Advice__c, a.OwnerId, a.Overall_Assessment__c, a.Name, a.Month_Number__c,
              a.Match_Name__c, a.Last_School_Day__c, a.LastModifiedDate, a.LastModifiedById, a.IsDeleted, a.Insurance_Info_Received__c, a.Initial_Impressions__c, a.Initial_Experience_Positive__c,
              a.Initial_Experience_Description__c, a.In_Touch_Balance_Positive__c, a.In_Touch_Balance_Description__c, a.Id, a.IEW_Participation_Indicated__c, a.Host_Name__c, a.Host_Memories__c, 
              a.Holiday_Planning_Positive__c, a.Holiday_Planning_Description__c, a.Future_Contact_Plan_Positive__c, a.Friendship_Development_Positive__c, a.Friendship_Development_Description__c, a.First_Return_Activity__c,
              a.Feeling_Uncomfortable__c, a.Feeling_Uncomfortable_Description__c, a.Feeling_Homesick__c, a.Family_Dynamics_Positive__c, a.Family_Bonding_Positive__c, a.Family_Bonding_Description__c, a.Expectations_for_Year__c,
              a.Exchange_Learning_Positive__c, a.Exchange_Learning_Description__c, a.Exchange_Experience_Summary__c, a.Engagement__c, a.Departure_Ready_Indicated__c, a.CurrencyIsoCode, a.CreatedDate, a.CreatedById, a.Count_Down__c,
              a.Contact_Type__c, a.ConnectionSentId, a.ConnectionReceivedId, a.Community_Service_Indicated__c, a.Community_Service_Description__c, a.Communication_Description__c, a.Comments__c, a.Cleanliness__c, a.Cleanliness_Description__c,
              a.Bedroom_Sharing__c, a.Bedroom_Privacy__c, a.Bed_Type__c, a.Assessment_Date__c,a.Airport__c, a.Adjusting_Positive__c,
              a.Adjusting_Description__c,a.ManualShareExists__c, a.Additional_Support_Requested__c, a.Additional_Support_Description__c From Assessment__c a where a.Host_Name__c=:prevPTHost and a.count_down__c=:Countdown and a.Record_Type_Group__c ='AY HF Contact' and a.Participant_Name__c =:match.Participant_Id__c and (a.status__c!='Confirmed' or a.status__c!='Completed') LIMIT 1];
              
             if(ObjAssessmentHF!=null && ObjAssessmentHF.size()>0)
             {
               ObjAssessmentHF[0].Match_Name__c =match.id;
               ObjAssessmentHF[0].Engagement__c = match.Engagement__c;
               ObjAssessmentHF[0].Position_Name__c = match.Position_Name__r.Id;
               ObjAssessmentHF[0].Host_Name__c = match.Position_Name__r.Host_Company_Id__c;
               ObjAssessmentHF[0].Participant_Name__c =match.Participant_Id__c;
               ObjAssessmentHF[0].Record_Type_Group__c = 'AY HF Contact';
               ObjAssessmentHF[0].Count_Down__c = IntStartingCount;            
               ObjAssessmentHF[0].Time_Period__c = TimePeriod;
               ObjAssessmentHF[0].Name = match.Name + ' HFC'; 
               ObjAssessmentHF[0].ManualShareExists__c = false;  
               ObjAssessmentHF[0].RecordTypeId = GetAssRecordTypeId(match,TimePeriod,'AY HF Contact');     
               ObjAssessmentHF[0].OwnerId = Owner;
                return ObjAssessmentHF[0];
             }
             else
               return null;
             
      }
      
      
      
      
      
      
      
        public Assessment__c CreateHFAssessment(Match__c match,Integer Countdown,Id Owner)
      {
         
         string  TimePeriod = GetMonthName(match,Countdown);
        
              Assessment__c ObjAssessmentHF = new  Assessment__c();
              
               ObjAssessmentHF.Match_Name__c =match.id;
               ObjAssessmentHF.Participant_Name__c =match.Participant_Id__c;
               ObjAssessmentHF.Engagement__c = match.Engagement__c;
               ObjAssessmentHF.Position_Name__c = match.Position_Name__r.Id;
               ObjAssessmentHF.Host_Name__c = match.Position_Name__r.Host_Company_Id__c;
               ObjAssessmentHF.Record_Type_Group__c = 'AY HF Contact';
               ObjAssessmentHF.Count_Down__c = Countdown;                
               ObjAssessmentHF.Time_Period__c = TimePeriod;
               ObjAssessmentHF.Name = match.Name + ' HFC';   
                ObjAssessmentHF.RecordTypeId = GetAssRecordTypeId(match,TimePeriod,'AY HF Contact');             
               ObjAssessmentHF.OwnerId = Owner;
               return ObjAssessmentHF;
      }
       public void BulkCreate(List<Match__c> matchlist)
       {
         Integer matchno = 0;
       List<JobSettings__c> ObjJobSetting = JobSettings__c.getAll().values();
        List<Match__c> MatchesToBeUpdatedForAssExists = new List<Match__c>();
        List<Engagement__c> EngsToBeUpdated = new List<Engagement__c>();
         List<Match__c> MatchesToBeUpdatedForErrorTag = new List<Match__c>();  
    For(match__c confMatch :matchlist)
   {
            
        List<Assessment__c> LstExistingMatchPTAssessment=new  List<Assessment__c>();
        List<Assessment__c> LstExistingMatchHFAssessment=new  List<Assessment__c>();
        List<Assessment__c> LstExistingMatchSCAssessment=new  List<Assessment__c>();
        List<Assessment__c> LstExistingMatchRTAssessment = new List<Assessment__c>();
           system.debug('******matchlist********'+ matchlist); 
              system.debug('******matchlist********'+ matchlist.size()); 
         
              List<Assessment__c> lstBulkAssessment = new List<Assessment__c>();
               List<Assessment__c> lstUpdateBulkAssessment = new List<Assessment__c>();
                 system.debug('******lstBulkAssessment********'+ lstBulkAssessment); 
                   system.debug('******lstUpdateBulkAssessment********'+ lstUpdateBulkAssessment); 
               system.debug('******matchno********'+ matchno); 
           List<Assessment__c> LstPTAssessment = new List<Assessment__c>();
            List<Assessment__c> LstHFAssessment = new List<Assessment__c>();
            List<Assessment__c> LstSCAssessment = new List<Assessment__c>();
             List<Assessment__c> LstUpdatePTAssessment = new List<Assessment__c>();
            List<Assessment__c> LstUpdateHFAssessment = new List<Assessment__c>();
            List<Assessment__c> LstUpdateSCAssessment = new List<Assessment__c>();
     try
     {
      if(confMatch!=null)
      {
        system.debug('******confMatch********'+ confMatch); 
        if(confMatch.Start_Date__c!=null)
        {
        StartMonthNumber = confMatch.Start_Date__c.Month();     
        StartMonth = GetStartMonthName(StartMonthNumber);
        }
        if(confMatch.Engagement__r.PDExtendedDate__c!=null) 
        {
        ExtendedMonthNumber = confMatch.Engagement__r.PDExtendedDate__c.Month();     
        ExtendedMonth = GetStartMonthName(ExtendedMonthNumber);        
        }
        List<String> RecordTypeList = new List<String>();
        RecordTypeList.add('AY PT Contact');
        RecordTypeList.add('AY HF Contact');
        RecordTypeList.add('AY SC Contact');
        Position__c position =[select OwnerId from Position__c where Id = :confMatch.Position_Name__c];
        Engagement__c engagement =[select OwnerId from Engagement__c where Id = :confMatch.Engagement__c];
              
        lstMatchAssessment = [Select Month_Number__c,Record_Type_Group__c,Assessment_Date__c,Host_Name__c, Match_Name__c, Participant_Name__c, Position_Name__c, Engagement__c, Count_Down__c From Assessment__c where Match_Name__c =: confMatch.Id and Record_Type_Group__c NOT IN : RecordTypeList];
        System.debug('***lstMatchAssessment******'+lstMatchAssessment);
        If(confMatch.Status__c=='Confirmed' && confMatch.Start_Date__c!=null && (confMatch.Match_Assessments__r.size() == 0 || confMatch.Engagement__r.Prog_Duration_Extended__c==true || (lstMatchAssessment!=null && lstMatchAssessment.size()>0)))
        {          
           LstExistingMatchRTAssessment =  [Select Month_Number__c,Record_Type_Group__c,RecordTypeId,Assessment_Date__c,Host_Name__c, Match_Name__c, Participant_Name__c, Position_Name__c, Engagement__c, Count_Down__c From Assessment__c where (Participant_Name__c =: confMatch.Participant_Id__c or Host_Name__c =: confMatch.Position_Name__r.Host_Company_Id__c) and  Record_Type_Group__c in : RecordTypeList];
           system.debug('********LstExistingMatchRTAssessment*****************'+ LstExistingMatchRTAssessment);
           if(LstExistingMatchRTAssessment!=null && LstExistingMatchRTAssessment.size()>0)
           {
             for(Assessment__c assInfo : LstExistingMatchRTAssessment)
             {
               if(assInfo.Record_Type_Group__c == 'AY PT Contact' && assInfo.Participant_Name__c == confMatch.Participant_Id__c)
                {
                   LstExistingMatchPTAssessment.add(assInfo);    
                }
                else if(assInfo.Record_Type_Group__c == 'AY HF Contact' && assInfo.Host_Name__c == confMatch.Position_Name__r.Host_Company_Id__c)
                {
                   LstExistingMatchHFAssessment.add(assInfo);  
                }
                else if(assInfo.Record_Type_Group__c == 'AY SC Contact' && assInfo.Participant_Name__c == confMatch.Participant_Id__c)
                {
                    LstExistingMatchSCAssessment.add(assInfo);  
                }
             }
           }
           system.debug('*****LstExistingMatchPTAssessment****'+LstExistingMatchPTAssessment);
              system.debug('*****LstExistingMatchPTAssessment size****'+LstExistingMatchPTAssessment.size());
               system.debug('********LstExistingMatchHFAssessment*****************'+ LstExistingMatchHFAssessment);
                system.debug('********LstExistingMatchHFAssessment size*****************'+ LstExistingMatchHFAssessment.size());
                 system.debug('*****confMatch****'+confMatch);
                  system.debug('*****confMatch.Engagement__r.Program_Duration__c****'+confMatch.Engagement__r.Program_Duration__c);
            if((LstExistingMatchPTAssessment.size()==0 || LstExistingMatchPTAssessment == null) && (LstExistingMatchHFAssessment.size()==0 || LstExistingMatchHFAssessment == null) && (LstExistingMatchSCAssessment.size()==0 || LstExistingMatchSCAssessment == null) )
            {
                if(confMatch.Engagement__r.Program_Duration__c == 'Academic Year'){
                 count = GetStartingCount(confMatch,StartMonth);
                    while (count > 0){
                       LstPTAssessment.add(CreatePTAssessment(confMatch,count,engagement.OwnerId));
                       LstHFAssessment.add(CreateHFAssessment(confMatch,count,position.OwnerId));              
                       count--;
                    }
                    SCcount=GetSCStartingCount(confMatch,StartMonth);
                    while (SCcount > 0){
                        LstSCAssessment.add(CreateSCAssessment(confMatch,SCcount,position.OwnerId));
                        SCcount--;
                    }
                    system.debug('debug::Academic::List_of_SCAssesments'+'LstSCAssessment');
                }
                else if (confMatch.Engagement__r.Program_Duration__c == 'Spring Semester'){
                  count = GetStartingCount(confMatch,StartMonth);
                  System.debug('***count******'+count);
                  while (count > 0) {
                    System.debug('***Inside loop count******'+count);
                    LstPTAssessment.add(CreatePTAssessment(confMatch,count,engagement.OwnerId));
                    LstHFAssessment.add(CreateHFAssessment(confMatch,count,position.OwnerId));
                    count--;
                  }
                // adding Sc assessments for Spring semester
                  SCcount=GetSCStartingCount(confMatch,StartMonth);
                    while (SCcount > 0){
                        LstSCAssessment.add(CreateSCAssessment(confMatch,SCcount,position.OwnerId));
                        SCcount--;
                    }
                    system.debug('debug::spring::List_of_SCAssesments'+'LstSCAssessment');
                }
               else if (confMatch.Engagement__r.Program_Duration__c == 'Fall Semester'){
                 count = GetStartingCount(confMatch,StartMonth);
                 while (count > 0){
                  LstPTAssessment.add(CreatePTAssessment(confMatch,count,engagement.OwnerId));
                  LstHFAssessment.add(CreateHFAssessment(confMatch,count,position.OwnerId));
                  count--;
                 }
                 // Adding SC assessments for fall semester
                    SCcount=GetSCStartingCount(confMatch,StartMonth);
                    while (SCcount > 0){
                        LstSCAssessment.add(CreateSCAssessment(confMatch,SCcount,position.OwnerId));
                        SCcount--;
                    }
                    system.debug('debug::Fall::List_of_SCAssesments'+'LstSCAssessment');
                }
            }
            else if((LstExistingMatchPTAssessment.size()!=0 && LstExistingMatchPTAssessment !=null) && (LstExistingMatchSCAssessment.size()!=0 && LstExistingMatchSCAssessment !=null) && (LstExistingMatchHFAssessment.size()!=0 && LstExistingMatchHFAssessment !=null) && confMatch.Engagement__r.Prog_Duration_Extended__c==true )
            {
                 extended_count = GetExtendedCount(confMatch,ExtendedMonth);
                 extended_SCcount=GetSCExtendedCount(confMatch,ExtendedMonth);
                   count = GetStartingCount(confMatch,ExtendedMonth);
                    SCcount=GetSCStartingCount(confMatch,ExtendedMonth);
                 system.debug('*****extended_count*******'+extended_count);
                 String prevPTHost = LstExistingMatchPTAssessment[0].Host_Name__c;
                  system.debug('*****prevPTHost*******'+prevPTHost);
                   DiffCount=count-extended_count;
                   DiffSCcount = SCcount-extended_SCcount;
                   system.debug('*****DiffCount*******'+DiffCount);
                   system.debug('*****DiffSCcount*******'+DiffSCcount);
                 while (extended_count > 0) {
                    Assessment__c objAss = UpdatePTAssessment(confMatch,extended_count,engagement.OwnerId,count);
                    if(objAss!=null)
                    LstUpdatePTAssessment.add(objAss);
                    
                    Assessment__c objHFAss = UpdateHFAssessment(confMatch,extended_count,prevPTHost,position.OwnerId,count);
                    if(objHFAss!=null)
                    LstUpdateHFAssessment.add(objHFAss);
                count--;
                extended_count--;
                }
              
                while (extended_SCcount > 0) 
                {
               System.debug('***Inside loop count******'+extended_SCcount);
                Assessment__c objSCAss=UpdateSCAssessment(confMatch,extended_SCcount,prevPTHost,position.OwnerId,SCcount);
               
               if(objSCAss!=null)
               LstUpdateSCAssessment.add(objSCAss);
               SCcount--;
               extended_SCcount--;
               
                }
               
              
                 while (DiffCount > 0) {
                    LstPTAssessment.add(CreatePTAssessment(confMatch,DiffCount,engagement.OwnerId));
                    LstHFAssessment.add(CreateHFAssessment(confMatch,DiffCount,position.OwnerId));
                    DiffCount--;
                }
                 
                while (DiffSCcount > 0) 
                {
                System.debug('***Inside loop count******'+DiffSCcount);             
                 LstSCAssessment.add(CreateSCAssessment(confMatch,DiffSCcount,position.OwnerId));   
                 DiffSCcount--;
                }
            }
            else if((LstExistingMatchPTAssessment.size()!=0 && LstExistingMatchPTAssessment !=null) && (LstExistingMatchSCAssessment.size()!=0 && LstExistingMatchSCAssessment !=null))         
            {
                 count = GetStartingCount(confMatch,StartMonth);
                String prevPTHost = LstExistingMatchPTAssessment[0].Host_Name__c;
                 System.debug('***prevPTHost******'+prevPTHost);
               while (count > 0) {
                System.debug('***Inside loop count******'+count);
               // System.debug('debug::UpdatePTAssesment'+UpdatePTAssessment(confMatch,count,engagement.OwnerId));
               // if(UpdatePTAssessment(confMatch,count,engagement.OwnerId)!=null)
                Assessment__c objAss = UpdatePTAssessment(confMatch,count,engagement.OwnerId);
                if(objAss!=null)
                LstUpdatePTAssessment.add(objAss);
                
                 Assessment__c objHFAss=UpdateHFAssessment(confMatch,count,prevPTHost,position.OwnerId);
                if(objHFAss!=null)
                LstUpdateHFAssessment.add(objHFAss);
                count--;
                }
                  SCcount=GetSCStartingCount(confMatch,StartMonth);
                while (SCcount > 0) 
                {
               System.debug('***Inside loop count******'+SCcount);
               Assessment__c objSCAss=UpdateSCAssessment(confMatch,SCcount,prevPTHost,position.OwnerId);
               
               if(objSCAss!=null)
               LstUpdateSCAssessment.add(objSCAss);
               
               SCcount--;
                }
               
            }
             else if((LstExistingMatchPTAssessment.size()!=0 && LstExistingMatchPTAssessment !=null) && (LstExistingMatchSCAssessment.size()==0 || LstExistingMatchSCAssessment ==null))         
            {
                 count = GetStartingCount(confMatch,StartMonth);
                String prevPTHost = LstExistingMatchPTAssessment[0].Host_Name__c;
                System.debug('***prevPTHost******'+prevPTHost);
               while (count > 0) {
                System.debug('***Inside loop count******'+count);
                Assessment__c objAss = UpdatePTAssessment(confMatch,count,engagement.OwnerId);
                if(objAss!=null)
                 LstUpdatePTAssessment.add(objAss);
               
                Assessment__c objHFAss=UpdateHFAssessment(confMatch,count,prevPTHost,position.OwnerId);
                 If(objHFAss!=null)
                 LstUpdateHFAssessment.add(objHFAss);
                count--;
                }
                 
            }
            else if(LstExistingMatchHFAssessment.size()!=0 && LstExistingMatchHFAssessment !=null)          
            {
                count = GetStartingCount(confMatch,StartMonth);
               while (count > 0) {
                System.debug('***Inside loop count******'+count);
                 LstPTAssessment.add(CreatePTAssessment(confMatch,count,engagement.OwnerId));
                 LstHFAssessment.add(CreateHFAssessment(confMatch,count,position.OwnerId));
                count--;
                }
                SCcount=GetSCStartingCount(confMatch,StartMonth);
                while (SCcount > 0) 
                {
               System.debug('***Inside loop count******'+SCcount);
               LstSCAssessment.add(CreateSCAssessment(confMatch,SCcount,position.OwnerId));
               SCcount--;
                }
     
      }
      
     
        }}
  
       // return true;
       }       
       
       Catch(Exception e)
       {
         System.debug('***confMatch******'+confMatch);
        string errormsg;
        errormsg=e.getMessage();
         System.debug('***errormsg******'+errormsg);
         if(errormsg.length()>250){
       errormsg = errormsg.SubString(0,250); }
        confMatch.Sys_Error_Tag__c=errormsg;
        MatchesToBeUpdatedForErrorTag.add(confMatch);
         System.debug('***confMatch******'+confMatch);
       // return false;
       }
       if(LstPTAssessment.size()>0 && LstPTAssessment!=null)
       {
          For(Assessment__c ass: LstPTAssessment)
          {
            lstBulkAssessment.add(ass);
          }
       }
        System.debug('***lstBulkAssessment.size******'+lstBulkAssessment.size());
      //insert LstPTAssessment;
        if(LstHFAssessment.size()>0 && LstHFAssessment!=null)
       {
          For(Assessment__c ass: LstHFAssessment)
          {
            lstBulkAssessment.add(ass);
          }
       }
        System.debug('***lstBulkAssessment.size******'+lstBulkAssessment.size());
      if(LstSCAssessment.size()>0 && LstSCAssessment!=null)
       {
          For(Assessment__c ass: LstSCAssessment)
          {
            lstBulkAssessment.add(ass);
          }
       }
        System.debug('***lstBulkAssessment.size******'+lstBulkAssessment.size());
        System.debug('Debug::LstSCAssessment.size****** and '+'debug::ListOfSCAss'+LstSCAssessment);
        System.debug('Debug::LstUpdatePTAssessment size is = '+LstUpdatePTAssessment.size());
        System.debug('Debug::LstUpdatePTAssessment '+LstUpdatePTAssessment);
        
      if(LstUpdatePTAssessment.size()>0 && LstUpdatePTAssessment!=null)
       {
          For(Assessment__c ass: LstUpdatePTAssessment)
          {
            lstUpdateBulkAssessment.add(ass);
          }
       }
        System.debug('***lstBulkAssessment.size******'+lstBulkAssessment.size());
        System.debug('debug::lstUpdateBulkAssessment******'+lstUpdateBulkAssessment);
        System.debug('Debug::LstUpdateHFAssessment size is = '+LstUpdateHFAssessment.size());
      if(LstUpdateHFAssessment.size()>0 && LstUpdateHFAssessment!=null)
       {
          For(Assessment__c ass: LstUpdateHFAssessment)
          {
            lstUpdateBulkAssessment.add(ass);
          }
       }
        System.debug('***lstUpdateBulkAssessment.size******'+lstUpdateBulkAssessment.size());
        System.debug('debug::lstUpdateBulkAssessment******'+lstUpdateBulkAssessment);
        System.debug('Debug::LstUpdateSCAssessment size is = '+LstUpdateSCAssessment.size());
        
      if(LstUpdateSCAssessment.size()>0 && LstUpdateSCAssessment!=null)
       {
          For(Assessment__c ass: LstUpdateSCAssessment)
          {
            lstUpdateBulkAssessment.add(ass);
          }
       }
        System.debug('***lstUpdateBulkAssessment.size******'+lstUpdateBulkAssessment.size());
        System.debug('***lstUpdateBulkAssessment******'+lstUpdateBulkAssessment);
      if(lstBulkAssessment.size()>0){
      system.debug(lstBulkAssessment);
      insert lstBulkAssessment ;
      }
     if(lstUpdateBulkAssessment.size()>0)
     update lstUpdateBulkAssessment;
      //insert LstHFAssessment;
      if(lstBulkAssessment.size()>0 || lstUpdateBulkAssessment.size()>0)
      {         
      If(confMatch.MCAssExists__c==False)
      {
      confMatch.MCAssExists__c=True;    
      MatchesToBeUpdatedForAssExists.add(confMatch);
      }
      if(confMatch.engagement__r.Prog_Duration_Extended__c==True)
      {
        confMatch.engagement__r.Prog_Duration_Extended__c = False;
        EngsToBeUpdated.add(confMatch.engagement__r);
        system.debug('******EngsToBeUpdated*******'+EngsToBeUpdated);
      }
      }
      else if (confMatch.Sys_Error_Tag__c==null &&  confMatch.MCAssExists__c==False)
      {
         confMatch.Sys_Error_Tag__c='Data Issue, Assessments can not be created.';
         MatchesToBeUpdatedForErrorTag.add(confMatch);
      }      
     /*  if(LstUpdatePTAssessment.size()>0)
      insert LstUpdatePTAssessment ;
      if(LstUpdateHFAssessment.size()>0)
      insert LstUpdateHFAssessment ;
      if(LstUpdateSCAssessment.size()>0)
      insert LstUpdateSCAssessment ;*/
      
       }
         System.debug('***MatchesToBeUpdatedForAssExists******'+MatchesToBeUpdatedForAssExists);
           System.debug('***MatchesToBeUpdatedForErrorTag******'+MatchesToBeUpdatedForErrorTag);
       if(MatchesToBeUpdatedForAssExists!=null && MatchesToBeUpdatedForAssExists.size()>0)
       update MatchesToBeUpdatedForAssExists;
        if(MatchesToBeUpdatedForErrorTag!=null && MatchesToBeUpdatedForErrorTag.size()>0)
       update MatchesToBeUpdatedForErrorTag;
       if(EngsToBeUpdated!=null && EngsToBeUpdated.size()>0)
       update EngsToBeUpdated;    
       }
}