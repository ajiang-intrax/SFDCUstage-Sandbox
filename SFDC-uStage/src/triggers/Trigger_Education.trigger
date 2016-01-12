trigger Trigger_Education on Education__c (before insert,after delete,before delete) {
    
     List<Applicant_Info__c> listapp = new List<Applicant_Info__c>();
     
     if(trigger.isInsert){
     for(Education__c ed: Trigger.new){
            List<Applicant_Info__c> setEduUni=[select id,University_Indicated__c,Additional_Training_Indicated__c from Applicant_Info__c where id =:ed.Applicant_Info__c];
            If(setEduUni.size()>0){
                    for (Applicant_Info__c app : setEduUni)
                    {
                        If(ed.institution_Type__c=='University/College' && app.University_Indicated__c=='No'){
                        app.University_Indicated__c='Yes';
                        listapp.add(app);
                        }
                        If(ed.institution_Type__c=='Vocational Training' && app.Additional_Training_Indicated__c=='No'){
                        app.Additional_Training_Indicated__c='Yes';
                        listapp.add(app);
                        }
                    }
                    system.debug('******listapp*********'+listapp);
            }       
        }
        if (listapp.size() > 0){
        update listapp;
        }
    }
    
    if(trigger.isdelete && trigger.isAfter){
        system.debug('debug::Insert isAfter -- isdelete');
        List<Applicant_Info__c> lstappUpd= new  List<Applicant_Info__c>();
        List<Applicant_Info__c> lstapp=new  List<Applicant_Info__c>();
        Map<String,Integer> educountMap = new Map<String,Integer>();
            for(Education__c ed: Trigger.old){
            List<aggregateResult> groupedu = [Select Institution_Type__c,count(Id) countType From Education__c where Applicant_Info__C =:ed.Applicant_Info__c group by Institution_Type__c];
            lstapp=[select id,University_Indicated__c,Additional_Training_Indicated__c from Applicant_Info__c where id =:ed.Applicant_Info__c];
            System.debug('debug::'+groupedu);
                for (AggregateResult educount : groupedu){
                    educountMap.put((String)educount.get('Institution_Type__c'),(Integer)educount.get('countType'));
                }
                try{
                    for(Applicant_Info__c app:lstapp){
                        If(!educountMap.containsKey('University/College') && app.University_Indicated__c=='Yes'){
                        app.University_Indicated__c='No';
                        lstappUpd.add(app);
                        }
                        If(!educountMap.containsKey('Vocational Training') && app.Additional_Training_Indicated__c=='Yes'){
                        app.Additional_Training_Indicated__c='No';
                        lstappUpd.add(app);
                        }
                    }
               
                    if(lstappUpd.size()>0)
                    update lstappUpd;
                
                }catch(Exception e){
                system.debug('***** Applicant info not updated: ' + e);
                } 
          }     
    }
    
    if(trigger.isdelete && trigger.isBefore){
        List<Id> idsEdu = new List<Id>{};
        for(Education__c a: Trigger.old){
            idsEdu.add(a.id);
         }
        
        //query all child records where parent ids were deleted
        Intrax_Program_Upload__c[] ipuToDelete = [select id from Intrax_Program_Upload__c where Education__c IN :idsEdu];
        system.debug('deleteRecords'+ipuToDelete);
        delete ipuToDelete; //perform delete statement
    }
}