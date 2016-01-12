trigger Trigger_TagApplication on Person_Info__c (before insert, before update) {
    if(trigger.isBefore){        
        if(trigger.isUpdate || trigger.isInsert){
            for (Person_Info__c personInfo : Trigger.New)
            {
                //B-01532 (Start)
                if (trigger.isInsert)
                {
                	if (personInfo.Role__c == 'Student'|| personInfo.Role__c == 'Participant') 
                	{
	                	if (personInfo.Email__c != '' && personInfo.Email__c != NULL)
	                	{
		                    List<Lead> qExistLead = [select Valid_Drivers_License__c, Marital_Status__c,Allergies_Indicated__c,Special_Diet_Indicated__c, Low_Grade_Count__c, id, FirstName,LastName, Status, Intrax_Programs__c, Intrax_Program_Options__c, Lead_Type__c, LeadSource, Lead_Source_Tag__c, Intrax_Region__c, Intrax_Market__c,
		                    Email, Gender__c, MobilePhone, Phone, Street, City, State, PostalCode, Country, Title, Date_of_Birth__c, Last_Interest_Date__c, Enquiry_Channel__c,Citizenship__c,
		                    Currently_Studying__c, One_Year_Work_Experience__c, Five_Years_Work_Experience__c from Lead where Email =: personInfo.Email__c and Status != 'Closed - Unqualified' order by CreatedDate DESC];
		                    if (qExistLead.size() > 0)
		                    {
		                        if (personInfo.Applicant_Info__c != NULL)
		                        {
		                            Applicant_Info__c qSelAppInfo = [SELECT Drivers_Licence_Indicated__c, Allergies_Indicated__c,Special_Diet_Indicated__c, Low_Grade_Count__c, RecordTypeId, Intrax_Program__c, Intrax_Program_Options__c, Type__c, Intrax_Region__c, Intrax_Market__c, Home_Phone__c,
		                            Home_Street_2__c, Home_Street_1__c,Home_City__c, Home_State__c, Home_Postal_Code__c, Home_Country__c, Title__c, Date_of_Birth__c, Enquiry_Channel__c,
		                            Currently_Studying__c,One_Year_Work_Experience__c,Five_Years_Work_Experience__c,Application_Type__c FROM Applicant_Info__c WHERE ID = :personInfo.Applicant_Info__c];
		                            
		                            if (qSelAppInfo.RecordTypeId == Constants.ICD_Intern_PT_Record_Type_Id || qSelAppInfo.RecordTypeId == Constants.AyusaPT_Record_Type_Id || (qSelAppInfo.RecordTypeId == Constants.AuPairCarePT_Record_Type_Id && qSelAppInfo.Application_Type__c == 'Original'))
		                            {
		                                personInfo.First_Name__c = qExistLead[0].FirstName;
		                                personInfo.Last_Name__c = qExistLead[0].LastName;
		                                personInfo.Date_of_Birth__c = qExistLead[0].Date_of_Birth__c;
		                                personInfo.Email__c = qExistLead[0].Email;
		                                personInfo.Gender__c = qExistLead[0].Gender__c;
		                                personInfo.Mobile__c = qExistLead[0].MobilePhone;
		                                personInfo.citizenship__c = qExistLead[0].Citizenship__c;
		                                personInfo.Country_of_Residence__c = qExistLead[0].Country; 
		                                
		                                if (qSelAppInfo.RecordTypeId == Constants.AuPairCarePT_Record_Type_Id)
		                                {
		                                	personInfo.Street__c = qExistLead[0].Street;
		                                	personInfo.Postal_Code__c = qExistLead[0].PostalCode;
		                                	personInfo.City__c = qExistLead[0].City;
		                                	personInfo.Country__c = qExistLead[0].Country;
		                                	personInfo.Phone__c = qExistLead[0].Phone;
		                                	PersonInfo.Marital_Status__c = qExistLead[0].Marital_Status__c;
		                                }
		                                
		                                
		                                qSelAppInfo.Intrax_Program__c = qExistLead[0].Intrax_Programs__c; 
		                                qSelAppInfo.Intrax_Program_Options__c = qExistLead[0].Intrax_Program_Options__c;
		                                qSelAppInfo.Type__c = qExistLead[0].Lead_Type__c;
		                                qSelAppInfo.Intrax_Region__c = qExistLead[0].Intrax_Region__c;
		                                qSelAppInfo.Intrax_Market__c = qExistLead[0].Intrax_Market__c;
		                                qSelAppInfo.Home_Phone__c = qExistLead[0].Phone;
		                                qSelAppInfo.Home_Street_1__c = qExistLead[0].Street;
		                                qSelAppInfo.Home_City__c = qExistLead[0].City;
		                                qSelAppInfo.Home_State__c = qExistLead[0].State;
		                                qSelAppInfo.Home_Postal_Code__c = qExistLead[0].PostalCode;
		                                qSelAppInfo.Home_Country__c = qExistLead[0].Country;
		                                qSelAppInfo.Title__c = qExistLead[0].Title;
		                                qSelAppInfo.Date_of_Birth__c = qExistLead[0].Date_of_Birth__c;
		                                qSelAppInfo.Enquiry_Channel__c = qExistLead[0].Enquiry_Channel__c;
		                                qSelAppInfo.Currently_Studying__c = qExistLead[0].Currently_Studying__c;
		                                qSelAppInfo.One_Year_Work_Experience__c = qExistLead[0].One_Year_Work_Experience__c;
		                                qSelAppInfo.Five_Years_Work_Experience__c = qExistLead[0].Five_Years_Work_Experience__c;
		                                qSelAppInfo.Email__c= qExistLead[0].Email;
		                                qSelAppInfo.Allergies_Indicated__c= qExistLead[0].Allergies_Indicated__c;
		                                qSelAppInfo.Special_Diet_Indicated__c = qExistLead[0].Special_Diet_Indicated__c;
		                                qSelAppInfo.Low_Grade_Count__c= qExistLead[0].Low_Grade_Count__c;
		                                
		                                if (qSelAppInfo.RecordTypeId == Constants.AuPairCarePT_Record_Type_Id)
		                                {
		                                	qSelAppInfo.Drivers_Licence_Indicated__c = qExistLead[0].Valid_Drivers_License__c;
		                                }
		                                
		                                update qSelAppInfo;
		                            }
		                        }
		                    }
	                	}
	                }
                }
                //B-01532 (End)
                
                if (personInfo.Role__c == 'Student'|| personInfo.Role__c == 'Host' || personInfo.Role__c == 'Participant'){
                    //TagCode
                    if (personInfo.Email__c != null){
                      //Host Family application must have a State value before a Lead or Account association
                      If(personInfo.Role__c == 'Host'){
                        Applicant_Info__c aiRec = [Select Home_State__c, Application_Type__c from Applicant_Info__c where Id = :personInfo.Applicant_Info__c];
                        if(!String.isBlank(aiRec.Home_State__c) && aiRec.Application_Type__c != 'Repeat'){
                          Sharing_Security_Controller.tagApplicationToAccAndOrLead(personInfo);
                        }
                      }
                      //For all other applications
                      else{
                        Sharing_Security_Controller.tagApplicationToAccAndOrLead(personInfo);
                      }
                    }    
                }  
                //B-03109 (Start)
                for (Person_Info__c p : Trigger.New)
                {
                if (trigger.isInsert)
                {     
                  if (p.Email__c != null && p.Role__c == 'Student'){
                   System.debug('inside tag application');
                   if(p.Applicant_Info__c!=null){
                   Applicant_Info__c app = [Select Id,Intrax_Program__c, Application_Level__c,Application_stage__c,Account__c,createdDate from Applicant_Info__c where Id = :p.Applicant_Info__c];
                   ApplicantInfoHelper.syncWTAppFields(app,p);
                   }
                  }        
                 }
                }
               //B-03109 (End)
                /*if(personInfo.Email__c!=null)
                {
                    List<Account> existingAcc = [select id, Last_Interest_Date__pc from Account where IsPersonAccount = true and PersonEmail!= null and PersonEmail =: personInfo.Email__c order by CreatedDate DESC];
                    List<Lead> existingLead = [select id, Last_Interest_Date__c from Lead where Email =: personInfo.Email__c and IsConverted = false order by CreatedDate DESC];
                    Applicant_Info__c applicantInfo = [select Id,Account__c,Application_Stage__c,CreatedById,LastModifiedById,Intrax_Program__c,Type__c,Lead__c,
                    Intrax_Program_Options__c,Home_Phone__c,Home_Street_2__c,Home_Street_1__c,Home_City__c,Home_State__c,Home_Postal_Code__c,Home_Country__c,Title__c,
                    Date_of_Birth__c,Enquiry_Channel__c from Applicant_Info__c where id = :personInfo.Applicant_Info__c ];

                    if (existingAcc.size() > 0) {
                        applicantInfo.Account__c = existingAcc[0].ID;
                        if((existingAcc[0].Last_Interest_Date__pc == NULL || !datetime.now().isSameDay(existingAcc[0].Last_Interest_Date__pc) && applicantInfo.Application_Stage__c != 'Cancelled' && applicantInfo.CreatedById == applicantInfo.LastModifiedById )){
                          existingAcc[0].Last_Interest_Date__pc = dateTime.now();
                        }
                        update applicantInfo;
                        //update existingAcc[0];
                    }
                    else if (existingLead.size() > 0) {
                        if (applicantInfo.Intrax_Program__c != 'Ayusa' && applicantInfo.Type__c != 'Host Family'){
                            applicantInfo.Lead__c = existingLead[0].ID;
    
                            if((existingLead[0].Last_Interest_Date__c == NULL || !datetime.now().isSameDay(existingLead[0].Last_Interest_Date__c) && applicantInfo.Application_Stage__c != 'Cancelled' && applicantInfo.CreatedById == applicantInfo.LastModifiedById )){
                                existingLead[0].Last_Interest_Date__c = DateTime.now(); 
                            }
                            update applicantInfo;
                            //update existingLead[0]; 
                        }
                        else{
                            applicantInfo.Lead__c = existingLead[0].ID;
                            //IUtilities.AppToLeadSync(applicantInfo, personInfo, existingLead[0], 'insert'); 
                            
                            existingLead[0].FirstName = personInfo.First_Name__c;
                            existingLead[0].LastName = personInfo.Last_Name__c;
                            existingLead[0].Intrax_Programs__c = 'Ayusa';
                            existingLead[0].Intrax_Program_Options__c = applicantInfo.Intrax_Program_Options__c;
                            existingLead[0].Lead_Type__c = applicantInfo.Type__c;
                            existingLead[0].LeadSource = 'Portal';
                            existingLead[0].Lead_Source_Tag__c = 'Application';
                            existingLead[0].Intrax_Region__c = 'United States';
                            existingLead[0].Email = personInfo.Email__c;
                            existingLead[0].Gender__c = personInfo.Gender__c;
                            existingLead[0].MobilePhone = personInfo.Mobile__c;
                            existingLead[0].Phone = applicantInfo.Home_Phone__c;
                            existingLead[0].Street = String.isBlank(applicantInfo.Home_Street_2__c) ? applicantInfo.Home_Street_1__c : applicantInfo.Home_Street_1__c + ' \r\n' + applicantInfo.Home_Street_2__c;
                            existingLead[0].City = applicantInfo.Home_City__c;
                            existingLead[0].State = applicantInfo.Home_State__c;
                            existingLead[0].PostalCode = applicantInfo.Home_Postal_Code__c;
                            existingLead[0].Country = applicantInfo.Home_Country__c;
                            existingLead[0].Title = applicantInfo.Title__c;
                            existingLead[0].Date_of_Birth__c = applicantInfo.Date_of_Birth__c;    
                            existingLead[0].Enquiry_Channel__c = applicantInfo.Enquiry_Channel__c;   
                            // Update only if nto changed in last 24 hours
                            if((existingLead[0].Last_Interest_Date__c == NULL || !datetime.now().isSameDay(existingLead[0].Last_Interest_Date__c) && applicantInfo.Application_Stage__c != 'Cancelled' && applicantInfo.CreatedById == applicantInfo.LastModifiedById )){
                                existingLead[0].Last_Interest_Date__c = DateTime.now(); 
                            }
                            try{
                                update applicantInfo;
                              //update existingLead[0];    
                            }catch(Exception e){
                              system.debug('***** Impossible to update related Lead: '+ e);
                            }  
                               
                        }
                        
                    } 
                    else {
                        Lead newLead = new Lead();            
                        newLead.FirstName = personInfo.First_Name__c;
                        newLead.LastName = personInfo.Last_Name__c;
                        newLead.Status = 'Open - New';
                        newLead.Intrax_Programs__c = applicantInfo.Intrax_Program__c; 
                        newLead.Intrax_Program_Options__c = applicantInfo.Intrax_Program_Options__c;
                        newLead.Lead_Type__c = applicantInfo.Type__c;
                        newLead.LeadSource = 'Portal';
                        newLead.Lead_Source_Tag__c = 'Application';
                        newLead.Intrax_Region__c = 'United States';
                        newLead.Email = personInfo.Email__c;
                        newLead.Gender__c = personInfo.Gender__c;
                        newLead.MobilePhone = personInfo.Mobile__c;
                        newLead.Phone = applicantInfo.Home_Phone__c;
                        newLead.Street = String.isBlank(applicantInfo.Home_Street_2__c) ? applicantInfo.Home_Street_1__c : applicantInfo.Home_Street_1__c + ' \r\n' + applicantInfo.Home_Street_2__c;
                        newLead.City = applicantInfo.Home_City__c;
                        newLead.State = applicantInfo.Home_State__c;
                        newLead.PostalCode = applicantInfo.Home_Postal_Code__c;
                        newLead.Country = applicantInfo.Home_Country__c;
                        newLead.Title = applicantInfo.Title__c;
                        newLead.Date_of_Birth__c = applicantInfo.Date_of_Birth__c;
                        newLead.Last_Interest_Date__c = DateTime.now(); 
                        newLead.Enquiry_Channel__c = applicantInfo.Enquiry_Channel__c;
          
                        // to turn the Assignment Rules on
                        Database.DMLOptions dmo = new Database.DMLOptions();
                        dmo.assignmentRuleHeader.useDefaultRule = true;
                        newLead.setOptions(dmo);
                        try{
                          insert newLead;
                        }catch(Exception e){
                          system.debug('****** Impossible to create new Lead for the HF App: '+ e);
                        }
                        applicantInfo.Lead__c = newLead.id;
                    }
                }*/
            }
        }
    }

}