trigger Trigger_User_Profile on User_Profile__c (after insert) {

    //Get a list of User Profile Id's
    Set<ID> ids = Trigger.newMap.keySet();
    System.debug('ids'+ids);
    //Get the list of the corresponding User Profiles
    List<User_Profile__c> correspondingUserProfiles = [select id,name,Is_Active__c,user__r.email,user__c from user_profile__c where Id in : ids];
    Set<Id> userIds = new Set<Id>();
    for (User_Profile__c userProfile : correspondingUserProfiles){
        userIds.add(userProfile.user__c);
    }
    //Get the list of the corresponding Users
    List<User> userRecs = [select Id,profileId from User where Id in :userIds];
    System.debug('userRecs'+userRecs);
    //New map to hold userProfile Id mapped to Profile Id
    Map<Id,Id> userProfileIdMap = new Map<Id,Id>();
    //Build the map
    for (User_Profile__c UserProfile : Trigger.new) {
        for (User userRec : userRecs){
            if (UserProfile.User__c == userRec.Id){
                userProfileIdMap.put(UserProfile.Id,userRec.profileId);     
            }
        }
    }
    
    System.debug('userProfileMap'+userProfileIdMap);
    
    Set<Id> setTrainingProfile = new Set<Id>();
    for(User lstTrainingprofiles :userRecs){
        setTrainingProfile.add(lstTrainingprofiles.profileId);
    }
    system.debug('debug::setTrainingProfile'+setTrainingProfile);
    List<Training_Groups__c> TrainingGroups = [select id,Name, Profile_Id__c,Group_Name__c from Training_Groups__c where Profile_Id__c in: setTrainingProfile];
    
    Set<string> userPds = new Set<string>();
    for(Training_Groups__c lstTrainingGroups :TrainingGroups){
        userPds.add(lstTrainingGroups.Group_Name__c);
    }
    
    for (User_Profile__c UserProfile : correspondingUserProfiles) {

        //If (userProfileIdMap.get(UserProfile.Id) == Constants.APCADProfileId || userProfileIdMap.get(UserProfile.Id) == Constants.APCRMProfileId){
        if(userPds.size()>0){
            
            //List<Scorm_Settings__c> ScormCourseSettings = Scorm_Settings__c.getAll().values();
            
           //First query all the scorm parent courses applicable for APC Area Directors and Regional Managers.
           List<Scorm_Settings__c> ScormParentCourseSettings =  [select id,name,Course_Name__c,Current_Year__c,
                                                                  Course_Id__c, Group_Name__c, Is_this_a_parent_course__c,
                                                                  Is_this_a_quiz__c, Multi_Step_Course__c,
                                                                  Course_Description__c, Step_Number__c,
                                                                  Scorm_Application_ID__c,Parent_Course_Name__c,Has_Certificate__c
                                                                  //from Scorm_Settings__c where Group_Name__c =: Constants.APC_AD_RM_TRAINING
                                                                  from Scorm_Settings__c where Group_Name__c in: userPds
                                                                  and  Is_this_a_parent_course__c = true];
           
            List<Scorm__c> ScromParentRecords = new List<Scorm__c>();
            
                for(integer i=0;i<ScormParentCourseSettings.size(); i++){
                    if(UserProfile.Is_Active__c == True){
                        ScromParentRecords.add(new Scorm__c(
                                                   Name=(ScormParentCourseSettings[i].Course_Name__c + ' - ' + ScormParentCourseSettings[i].Current_Year__c), 
                                                   User_Profile__c=UserProfile.id, 
                                                   Course_Id__c = ScormParentCourseSettings[i].Course_Id__c,
                                                   Course_Name__c = ScormParentCourseSettings[i].Course_Name__c,
                                                   Group_Name__c = ScormParentCourseSettings[i].Group_Name__c,
                                                   Is_Parent__c = ScormParentCourseSettings[i].Is_this_a_parent_course__c,
                                                   Is_this_a_quiz__c = ScormParentCourseSettings[i].Is_this_a_quiz__c,
                                                   Multi_Step_Course__c = ScormParentCourseSettings[i].Multi_Step_Course__c,
                                                   Course_Description__c = ScormParentCourseSettings[i].Course_Description__c,
                                                   Step_Number__c = 0,
                                                   Scorm_Application_ID__c = ScormParentCourseSettings[i].Scorm_Application_ID__c,
                                                   Learner_Id__c=UserProfile.user__r.email,
                                                   Total_Time__c='0',
                                                   Has_Certificate__c=ScormParentCourseSettings[i].Has_Certificate__c
                                                   )
                                                   );
                    }
                }
                
                
                //Create Scorm Parent objects for the paren courses.
                if(ScromParentRecords.size()>0)
                {
                    insert ScromParentRecords;
                    system.debug('debug:::Learner Id'+ScromParentRecords);
                }
                 
                 
                //Now query all the scorm child courses applicable for APC Area Directors and Regional Managers, create them and hook them to the parent courses
                
                 
                //First query all the scorm parent courses applicable for APC Area Directors and Regional Managers.
                List<Scorm_Settings__c> ScormChildCourseSettings =  [select id,name,Course_Name__c,Current_Year__c,
                                                                  Course_Id__c, Group_Name__c, Is_this_a_parent_course__c,
                                                                  Is_this_a_quiz__c, Multi_Step_Course__c,
                                                                  Course_Description__c, Step_Number__c,
                                                                  Scorm_Application_ID__c,Parent_Course_Name__c
                                                                  from Scorm_Settings__c where Group_Name__c in: userPds
                                                                  and  Is_this_a_parent_course__c = false];
                                                                  
                List<Scorm__c> ScromChildRecords = new List<Scorm__c>();                                          
           
                for(integer i=0;i<ScormChildCourseSettings.size(); i++){
                    
                    if(UserProfile.Is_Active__c == True){
                        String parentScormId ='';
                        
                        for(Scorm__c parent:ScromParentRecords)
                        {
                            if(parent.Course_Name__c == ScormChildCourseSettings[i].Parent_Course_Name__c)
                            parentScormId=parent.Id;                        
                        }

                        ScromChildRecords.add(new Scorm__c(
                                                   Name=(ScormChildCourseSettings[i].Course_Name__c + ' - ' + ScormChildCourseSettings[i].Current_Year__c), 
                                                   User_Profile__c=UserProfile.id, 
                                                   Course_Id__c = ScormChildCourseSettings[i].Course_Id__c,
                                                   Course_Name__c = ScormChildCourseSettings[i].Course_Name__c,
                                                   Group_Name__c = ScormChildCourseSettings[i].Group_Name__c,
                                                   Is_Parent__c = ScormChildCourseSettings[i].Is_this_a_parent_course__c,
                                                   Is_this_a_quiz__c = ScormChildCourseSettings[i].Is_this_a_quiz__c,
                                                   Multi_Step_Course__c = ScormChildCourseSettings[i].Multi_Step_Course__c,
                                                   Course_Description__c = ScormChildCourseSettings[i].Course_Description__c,
                                                   Parent_Course_Name__c = parentScormId,
                                                   Step_Number__c = ScormChildCourseSettings[i].Step_Number__c,
                                                   Scorm_Application_ID__c = ScormChildCourseSettings[i].Scorm_Application_ID__c,
                                                   Learner_Id__c=UserProfile.user__r.email,
                                                   Total_Time__c='0'
                                                   )
                                                   );
                    }
                }
                
                //Create Scorm child objects for the child courses.
                if(ScromChildRecords.size()>0)
                {
                 insert ScromChildRecords; 
                 system.debug('debug:::Learner Id'+ScromChildRecords);
                }
                
        }
    }

}