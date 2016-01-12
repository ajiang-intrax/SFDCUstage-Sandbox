trigger Trigger_Person_Info on Person_Info__c (after update, after insert) {
    if(trigger.isAfter){
        if(trigger.isUpdate){
            try{
                list<Person_Info__c> personInfoList = [SELECT Id, Primary_Applicant__c,Applicant_Info__r.Lead__c,Applicant_Info__r.RecordTypeId,Applicant_Info__r.Intrax_Program__c,Applicant_Info__r.Account__c, Applicant_Info__r.Home_Phone__c, First_Name__c, Last_Name__c, Gender__c, Date_Of_Birth__c, Citizenship__c, email__c, Mobile__c, Phone__c, Phone_Country_Code__c,Skype_Id__c, Best_call_Time__c, Applicant_Info__c 
                                                    FROM Person_Info__c 
                                                    WHERE Id IN: trigger.new];
        
                for(Person_Info__c personInfo : personInfoList){
                    if (personInfo.Primary_Applicant__c){
                        
                        string residence_old = trigger.oldMap.get(personInfo.Id).Country_of_Residence__c;
                        string residence_new = trigger.newMap.get(personInfo.Id).Country_of_Residence__c;
                        
                        if(personInfo.Applicant_Info__r.Intrax_Program__c == 'Internship' && residence_old != residence_new){
                            PersonInfoHelper.mapIntraxRegion_Residence(residence_new, personInfo.Applicant_Info__c);
                        }
                        
                        system.debug('***** Lead!! ' + personInfo.Applicant_Info__r.Lead__c); 
                        if((personInfo.Applicant_Info__r.RecordTypeId == Constants.WT_PT_Record_Type_Id || personInfo.Applicant_Info__r.RecordTypeId == Constants.AuPairCarePT_Record_Type_Id || personInfo.Applicant_Info__r.RecordTypeId == Constants.AyusaPT_Record_Type_Id) && residence_old != residence_new)
                        {
                         PersonInfoHelper.mapIntraxRegion_ResidenceForAllPgms(residence_new, personInfo.Applicant_Info__c);
                        }
                        if(personInfo.Applicant_Info__r.Lead__c != null){
                        PersonInfoHelper.syncLeadFields(personInfo.Applicant_Info__r.Lead__c, personInfo);
                        }
                        
                        PersonInfoHelper.syncAccFields(personInfo.Applicant_Info__r.Account__c, personInfo);                    
                    
                    }
                }
            }catch(Exception e){
                system.debug('****** No person Info record yet. Nothing to sync for now...');
            }
        }
        if(trigger.IsInsert){
            list<Person_Info__c> personInfoList = [SELECT Id, Primary_Applicant__c,Applicant_Info__r.Lead__c, Applicant_Info__r.Intrax_Program__c, Applicant_Info__r.Account__c, Applicant_Info__r.Home_Phone__c, First_Name__c, Last_Name__c, Gender__c, Date_Of_Birth__c, Citizenship__c, email__c, Mobile__c, Phone__c, Skype_Id__c, Best_call_Time__c, Applicant_Info__c 
                                                    FROM Person_Info__c 
                                                    WHERE Id IN: trigger.new];
            for(Person_Info__c personInfo : personInfoList){
                if (personInfo.Primary_Applicant__c){                                       
                    
                    string residence_new = trigger.newMap.get(personInfo.Id).Country_of_Residence__c;
                    
                    if(personInfo.Applicant_Info__r.Intrax_Program__c == 'Intenship' && residence_new != ''){
                        PersonInfoHelper.mapIntraxRegion_Residence(residence_new, personInfo.Applicant_Info__c);
                    }
                }
            }
        }
    }
}