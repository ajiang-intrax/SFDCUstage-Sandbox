public class Trigger_Engagement_Helper {
    
    public static boolean syncOppFromEng = false;
    
    public static void setsyncOppFromEng(){
        syncOppfromEng = true;
    }
    
    public static boolean getsyncOppFromEng(){
        return syncOppFromEng;
    }
    //B-02451 Starts.. by AP
  /*  public static void setOppOperationStatus(Id engid)
    {
     System.debug('@@ inside trigger update @@');
     List <Engagement__c>eng = [Select id,Name, Placement_Status__c,Opportunity_Id__c from Engagement__c where ID =:engid];
     Opportunity Opp = new Opportunity();
     Opp = [Select Id, Name, Operation_Stage__c,Intrax_Programs__c from Opportunity where ID =:eng[0].Opportunity_Id__c];
     if (Opp.Intrax_Programs__c == 'Ayusa')
     {
     Opp.Operation_Stage__c = 'Match Ready';
     update Opp;
     }
    }*/
    //B-02451 Ends.
    public static void setScorm(Engagement__c eng)
    {
       List<Scorm_Settings__c> scormlst = new List<Scorm_Settings__c>();
       list<Training_Groups__c> TrainingGroups = [select id,Name, Profile_Id__c,Group_Name__c from Training_Groups__c where Type__c=:eng.Type__c and Intrax_Program__c=:eng.Intrax_Program__c Limit 1];
       if(TrainingGroups.size() > 0){
       scormlst= [select id,name,Course_Name__c,Current_Year__c,
                                                                  Course_Id__c, Group_Name__c, Is_this_a_parent_course__c,
                                                                  Is_this_a_quiz__c, Multi_Step_Course__c,
                                                                  Course_Description__c, Step_Number__c,
                                                                  Scorm_Application_ID__c,Parent_Course_Name__c
                                                                  from Scorm_Settings__c where Group_Name__c =:TrainingGroups[0].Group_Name__c and  Is_this_a_parent_course__c = true];
        Engagement__c e =[Select Id ,Account_Id__r.Name, Account_Id__r.PersonEmail from Engagement__c where Id =:eng.Id limit 1 ];                                                      
        if((scormlst.size() > 0) && (e!=null)){
        Scorm__c scorm = new Scorm__c(Name=  (scormlst[0].Course_Name__c+ ' - ' + scormlst[0].Current_Year__c ), 
                                                   Engagement__c= e.Id, 
                                                   Course_Id__c = scormlst[0].Course_Id__c,
                                                   Course_Name__c = scormlst[0].Course_Name__c,
                                                   Group_Name__c = scormlst[0].Group_Name__c,
                                                   Is_Parent__c = scormlst[0].Is_this_a_parent_course__c,
                                                   Is_this_a_quiz__c = scormlst[0].Is_this_a_quiz__c,
                                                   Multi_Step_Course__c = scormlst[0].Multi_Step_Course__c,
                                                   Course_Description__c = scormlst[0].Course_Description__c,
                                                   Step_Number__c = 0,
                                                   Scorm_Application_ID__c = scormlst[0].Scorm_Application_ID__c,
                                                   Learner_Id__c = e.Account_Id__r.PersonEmail,
                                                   Total_Time__c='0'
                                                   );
                                        
         insert scorm;
        }
      }
    }

}