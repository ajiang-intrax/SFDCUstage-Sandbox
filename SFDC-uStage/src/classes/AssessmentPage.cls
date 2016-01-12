public without sharing class AssessmentPage {
        
        public Position__c position { set; get;}
        public Assessment__c ass { set; get;}
        public Engagement__c engagement { set; get;}
        public String assId {set; get;}
        public String assessmentField {set;get;} 
               
       
    public AssessmentPage(){
    } 
    
    public AssessmentPage(ApexPages.StandardController controller) { 
   
        System.debug('***********Record ID***********'+assId);    
        
        assId =  ApexPages.currentPage().getParameters().get('id'); 
          System.debug('***********assId***********'+assId);   
        if(assId != null)
        
        ass = [select /*Youth_Experience_Description__c,Wrap_Up_Complete_Indicated__c,Confirmed_Date__c ,Wrap_Up_Complete_Description__c,Welcomers__c,Validation_Counter__c,Upcoming_Separation_Positive__c,Upcoming_Separation_Description__c,Travel_Arrangements_Indicated__c,Time_Period__c,SystemModstamp,
        Study_Area__c,Student_Safety_Approach__c,Storage_Area__c,Separation_Plan_Description__c,School_Curriculum_Positive__c,
        School_Adjustment_Positive__c,School_Adjustment_Description__c,Safety_Hazards__c,Safety_Hazards_Description__c,
        Return_Expectations__c,Return_Challenges__c,Resident_Total__c,Resident_Participants__c,Resident_Illness_Description__c,Resident_Change_Indicated__c,
        Resident_Change_Description__c,Resident_Adults__c,Representative__c,Repeat_Interest_Indicated__c,Repeat_Interest_Description__c,RecordTypeId,Program_Satisfaction_Positive__c,
        Program_Satisfaction_Description__c,Program_Impact_Description__c,Program_End_Feeling__c,Position_Name__c,Participant_change_Description__c,Participant_Name__c,
        Participant_Change_Positive__c,School_Responder__c,Enrollment_Period_Start__c,Enrollment_Period_End__c, Participant_Advice__c,PT_Responsibilities_Expectations__c,PT_Expense_Expectations__c,OwnerId,Overall_Assessment__c,
        Nearby_Support_Description__c,Name,Month_Number__c,Month_Counter__c,Match_Name__c,Last_School_Day__c,LastModifiedDate,LastModifiedById,
        LastActivityDate,IsDeleted,Insurance_Info_Received__c,Initial_Language_Level__c,Initial_Impressions__c,Initial_Experience_Positive__c,
        Initial_Experience_Description__c,In_Touch_Balance_Positive__c,In_Touch_Balance_Description__c,Id,IEW_Participation_Indicated__c,Host_Name__c,
        Host_Motivation__c,Host_Memories__c,Host_Benefit_Description__c,Home_Description__c,Holiday_Planning_Positive__c,Holiday_Planning_Description__c,
        Future_Contact_Plan_Positive__c,Friendship_Development_Positive__c,Friendship_Development_Description__c,First_Return_Activity__c,
        Feeling_Uncomfortable__c,Feeling_Uncomfortable_Description__c,Feeling_Homesick__c,Family_Dynamics_Positive__c,Family_Bonding_Positive__c,
        Family_Bonding_Description__c,Expectations_for_Year__c,Expectation_Of_Participant__c,Exchange_Learning_Positive__c,Exchange_Learning_Description__c,
        Exchange_Experience_Summary__c,Engagement__c,Departure_Ready_Indicated__c,CurrencyIsoCode,CreatedDate,CreatedById,Count_Down__c,
        Contact_Type__c,ConnectionSentId,ConnectionReceivedId,Community_Service_Indicated__c,Community_Service_Description__c,Community_Description__c,
        Community_Dangerous_Areas__c,Communication_Style_Positive__c,Communication_Description__c,Comments__c,Cleanliness__c,Cleanliness_Description__c,
        Bedroom_Sharing__c,Bedroom_Privacy__c,Bed_Type__c,Average_Week_Description__c,Assessment_Staff__c,Assessment_Location__c,Assessment_Date__c,Anticipated_Return_Positive__c,Airport__c,
        Adjusting_Positive__c,Adjusting_Description__c,Additional_Support_Requested__c, Bedroom_Type__c, Family_Activities__c, Host_Rules__c, PT_Responsibilities__c, Challenges__c, School_Activities__c,
        Additional_Support_Description__c,
        //Access_To_Utilities__c,*/
        status__c,Engagement__c,Position_Name__c from Assessment__c where Id =:assId];
   
               
        
        RecordType validationId = [SELECT Id,Name FROM RecordType WHERE Name = 'AY HF Validation'];
        RecordType HFinterviewId = [SELECT Id,Name FROM RecordType WHERE Name = 'AY HF Interview'];
        RecordType PTorientationId = [SELECT Id,Name FROM RecordType WHERE Name = 'AY PT Orientation'];
        RecordType HomeVisitId = [SELECT Id,Name FROM RecordType WHERE Name = 'AY Home Visit'];
      //  RecordType ptc = [SELECT Id,Name FROM RecordType WHERE Name = 'AY PT Contact'];
      //  RecordType htc = [SELECT Id,Name FROM RecordType WHERE Name = 'AY HF Contact'];
      //  RecordType stc = [SELECT Id,Name FROM RecordType WHERE Name = 'AY SC Contact'];

        
        //*****We get all the info about the Engagement__c linked with the current Assessment Object
        
        if(ass.Engagement__c != null){
        
        engagement = [SELECT Id,Name,Program_Duration__c, Class_8__c,Class_7__c,Class_6__c, Class_5__c, Class_4__c, Class_3__c, Class_2__c, Class_1__c,
        Grade_Level__c,Orientation_Date__c FROM Engagement__c WHERE Id =: ass.Engagement__c];
        
        }
        
        //*****We get all the info about the Position__c linked with the current Assessment Object
        
       if(ass.Position_Name__c != null){ 
        
        position = [SELECT Id, Engagement_Start__c   FROM Position__c WHERE Id =: ass.Position_Name__c];
        
        }
                 
        //Comparations to create an String varible with the name of the FieldSet for HF & PT & SC Contact & HF Interview & Validation & PT interview &*/
        
     /*  if(ass.RecordTypeId == htc.Id && engagement!=null){
            
                           
            if(engagement.Program_Duration__c  == 'Academic Year'){
            
            System.debug('Time Period Value  '+assessmentField );
            assessmentField = 'HF' + ass.Time_Period__c  + 'Y';
            System.debug('****Test***'+ assessmentField );
            
            }else if(engagement.Program_Duration__c  == 'Fall Semester'){
            
            assessmentField = 'HF' + ass.Time_Period__c  + 'Sem1';
             
                        
            }else if(engagement.Program_Duration__c  == 'Spring Semester'){
                
            assessmentField = 'HF' + ass.Time_Period__c  + 'Sem2';
                
            }
            
            System.debug('*****AssessmentField:  '+assessmentField );
        
        }else if(ass.RecordTypeId == ptc.Id && engagement!=null){
            
                           
            if(engagement.Program_Duration__c  == 'Academic Year'){
            
            System.debug('Time Period Value  ' + assessmentField );
            assessmentField = 'PT' + ass.Time_Period__c  + 'Y';
            System.debug('****Test***'+ assessmentField );
            
            }else if(engagement.Program_Duration__c  == 'Fall Semester'){
               
            assessmentField = 'PT' + ass.Time_Period__c  + 'Sem1'; 
                                        
            }else if(engagement.Program_Duration__c  == 'Spring Semester'){
                
            assessmentField = 'HF' + ass.Time_Period__c  + 'Sem2';
            
            }
            System.debug('*****AssessmentField:  '+assessmentField );
        
        }else if(ass.RecordTypeId == stc.Id && engagement!=null){
            
           
            if(engagement.Program_Duration__c  == 'Academic Year'){
            
            System.debug('Time Period Value  ' + assessmentField );
            assessmentField = 'SC' + ass.Time_Period__c  + 'Y';
            System.debug('****Test***'+ assessmentField );
            
            }else if(engagement.Program_Duration__c  == 'Fall Semester'){
               
            assessmentField = 'SC' + ass.Time_Period__c  + 'Sem1'; 
                                        
            }else if(engagement.Program_Duration__c  == 'Spring Semester'){
                
            assessmentField = 'SC' + ass.Time_Period__c  + 'Sem2';
            
            }
            
            System.debug('*****AssessmentField:  '+assessmentField );
        
        }*/
        
               
   }
    
    public PageReference cancel(){
        
           Pagereference newpage;
           if(assId!=null)
            {
            
           
            newpage = new Pagereference ('/' + assId.left(3));
            system.debug('******This is the Assessment page: ' + newpage);
            system.debug('******This is the Id: ' + assId.left(3));
            
            }
            
            return newpage;
           
    }
    
   
    
 }