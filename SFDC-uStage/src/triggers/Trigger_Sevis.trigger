trigger Trigger_Sevis on Sevis__c (before update, after update) {
if (Trigger.isAfter || Trigger.isBefore){
    if (Trigger.isUpdate){
        //List to hold engagements to be updated
        List<Engagement__c> engagementList = new List<Engagement__c>();
    //List to hold DS2019IPU to be inserted
    List<Intrax_Program_Upload__c> sevisDS2019IPUList = new List<Intrax_Program_Upload__c>();

        //Map to hold engagments mapped to the SEVIS objects in context
        Map<ID, Engagement__c> engagementMap = new Map<ID, Engagement__c>();
        //List to hold engagements mapped to the SEVIS objects in context
        List<Engagement__c> engagementListToMap = [select SEVIS__c,Intrax_Program_Options__c,Intrax_Program__c, SEVIS_Program__c, Partner_Account__c from Engagement__c where SEVIS__c in :Trigger.new];
        //Convert list to map and hold them
        for (Engagement__c engagementInd : engagementListToMap){
            engagementMap.put(engagementInd.SEVIS__c,engagementInd);
        }
        //For each SEVIS record in context 

    if (Trigger.isBefore)
    {
        for (Sevis__c sevisBeforeUpdate : Trigger.new)
        {
            Sevis__c sevisOldBefore = Trigger.oldMap.get(sevisBeforeUpdate.Id);
            Engagement__c engMnt = engagementMap.get(sevisBeforeUpdate.Id);
            if(engMnt.Partner_Account__c != sevisOldBefore.SEVIS_Partner_Account__c)
            {
                sevisBeforeUpdate.SEVIS_Partner_Account__c = engMnt.Partner_Account__c;
            }
            //Story B-01612 
 
            if(engMnt.Intrax_Program__c == 'Work Travel')
            {
              sevisBeforeUpdate.SEVIS_Program__c = 'wt-pt';
            } 
            else if(engMnt.Intrax_Program__c == 'Internship' && engMnt.Intrax_Program_Options__c.contains('WEST'))
            {
                sevisBeforeUpdate.SEVIS_Program__c = 'igi-pt-west';
            }
            else if(engMnt.Intrax_Program__c == 'Internship' && engMnt.Intrax_Program_Options__c!= 'WEST' && engMnt.SEVIS_Program__c =='14-Trainee')
            {
                sevisBeforeUpdate.SEVIS_Program__c = 'igi-pt-trainee';
            }
            else if (engMnt.Intrax_Program__c == 'Internship' && engMnt.Intrax_Program_Options__c!= 'WEST' && engMnt.SEVIS_Program__c =='15-Intern')
            {
                sevisBeforeUpdate.SEVIS_Program__c = 'igi-pt-intern';
            }
           
            
        }
    }
    
 
    
    if (Trigger.isAfter)
    {
        //Get SysAdmin ID to check if Admin is the one updating the record
        User SysAdmin = [select Id from User where userName = :Constants.SYS_ADMIN];
        for (Sevis__c sevisNew : Trigger.new){
            //Pick the Old values from the OldMap
            Sevis__c sevisOld = Trigger.oldMap.get(sevisNew.Id);
            //Get the engagement to be unlocked
            Engagement__c engagement = engagementMap.get(sevisNew.Id);
            //If conditions match
            if (sevisNew.SEVIS_When_Downloaded__c != sevisOld.SEVIS_When_Downloaded__c && sevisNew.LastModifiedById == SysAdmin.Id ){
                engagement.SEVIS_LOCK__c = False;
                engagement.SEVIS_ID__c = sevisNew.SEVIS_ID__c;
                //Add the engagement to the list to be updated
                engagementList.add(engagement);
            }
            //Create IPU if conditions match
            if (sevisNew.SEVIS_DS2019_DocGuid__c != null && sevisOld.SEVIS_DS2019_DocGuid__c != sevisNew.SEVIS_DS2019_DocGuid__c ){
                Intrax_Program_Upload__c sevisDS2019IPU = new Intrax_Program_Upload__c();
                sevisDS2019IPU.Document_GUID__c = sevisNew.SEVIS_DS2019_DocGuid__c;
                sevisDS2019IPU.Sevis__c = sevisNew.Id;
                sevisDS2019IPU.Engagement__c = engagement.Id;
                sevisDS2019IPU.Description__c = 'DS 2019';
                sevisDS2019IPU.Document_Service__c = 'DS';
                sevisDS2019IPU.Document_Type__c = 'DS-2019';
                sevisDS2019IPU.Intrax_Programs__c = engagement.Intrax_Program__c;
                
                sevisDS2019IPUList.add(sevisDS2019IPU);
            }
            
            //Added for DS-7002 (Start)
            if (sevisNew.SEVIS_DS7002_DocGuid__c != null && sevisOld.SEVIS_DS7002_DocGuid__c != sevisNew.SEVIS_DS7002_DocGuid__c ){
                Intrax_Program_Upload__c sevisDS7002IPU = new Intrax_Program_Upload__c();
                sevisDS7002IPU.Document_GUID__c = sevisNew.SEVIS_DS7002_DocGuid__c;
                sevisDS7002IPU.Sevis__c = sevisNew.Id;
                sevisDS7002IPU.Engagement__c = engagement.Id;
                sevisDS7002IPU.Description__c = 'DS 7002 (Unsigned)';
                sevisDS7002IPU.Document_Service__c = 'DS';
                sevisDS7002IPU.Document_Type__c = 'DS-7002-(Unsigned)';
                sevisDS7002IPU.Intrax_Programs__c = engagement.Intrax_Program__c;
                
                sevisDS2019IPUList.add(sevisDS7002IPU);
            }
            //Added for DS-7002 (End)
            
        }
        //Update Engagements for unlock
        update engagementList;
        //insert DS2019IPU List
        insert sevisDS2019IPUList;
    }
    }
}
}