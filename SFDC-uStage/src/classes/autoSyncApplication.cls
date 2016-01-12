//auto-sync automation application. - Created by Hari
public class autoSyncApplication {
    
    //Method used to automate auto sync application - Created by Hari
    public void autoSyncWTApplication(list<Applicant_Info__c> lstNewApplication, map<Id, Applicant_Info__c> mapOldApplication){
        
        list<Applicant_Info__c> lstApplicationWithChild = new list<Applicant_Info__c>();
        list<Applicant_Info__c> lstApplication_WT = new list<Applicant_Info__c>();
        list<Account> lstPersonAccountToUpdate = new list<Account>();
        list<Account> lstPersonAccountToInsert = new list<Account>();
        list<Opportunity> lstOpportunityToUpdate = new list<Opportunity>();
        list<Opportunity> lstOpportunityToInsert = new list<Opportunity>();
        list<Engagement__c> lstEngagementToUpdate = new list<Engagement__c>();
        list<Engagement__c> lstEngagementToInsert = new list<Engagement__c>();
        map<Id, list<Person_Info__c>> mapPersonInfo = new map<Id, list<Person_Info__c>>();
        set<Id> setApplicationId = new set<Id>(); 
        list<Person_Info__c> lstPersonInfo_PrimaryApplication = new list<Person_Info__c>();
        list<Person_Info__c> lstPersonInfo_NotPrimaryApplication = new list<Person_Info__c>();
        set<String> setAccountId_FromPersonInfo = new set<String>();
        list<Account> lstAccount_MemberDetails = new list<Account>();
        list<Member__c> lstMemberToUpdate = new list<Member__c>();
        list<Member__c> lstMemberToInsert = new list<Member__c>();
        map<String, list<Member__c>> mapMember = new map<String, list<Member__c>>();
        map<Id, list<Person_Info__c>> mapPersonInfo_NotPrimary = new map<Id, list<Person_Info__c>>();
        set<Id> setAccountId_Opportunity = new set<Id>();
        list<Account> lstAccount_Opportunity = new list<Account>();
        map<Id, list<Opportunity>> mapOpportunity = new map<Id, list<Opportunity>>();
        set<Id> setOppId_Engagement = new set<Id>();
        list<Opportunity> lstOpportunity_Engagement = new list<Opportunity>();
        map<Id, list<Engagement__c>> mapEngagement = new map<Id, list<Engagement__c>>();
        set<Id> setNewAccount = new set<Id>();
        map<Id,String> mapEngPartnerId=new map<Id, String>();
        Set<Id> setInsertEngIds=new Set<Id>();
        Set<Id> setupdateEngIds=new Set<Id>();
        Set<Id> setCREngIds=new Set<Id>();
            
        TriggerExclusion.mapSkipAfterUpdate.put('AutoSyncRecord', String.ValueOf(system.now()));
        //Auto Sync Application for WT
        for(Applicant_Info__c itrApplication : lstNewApplication){
            Applicant_Info__c oldApplicaton = mapOldApplication.get(itrApplication.Id);
            if(itrApplication.Application_Stage__c != oldApplicaton.Application_Stage__c && oldApplicaton.Application_Stage__c == 'Working' || oldApplicaton.Application_Stage__c == 'Submitted'){
                if(itrApplication.Intrax_Program__c == 'Work Travel' && itrApplication.Application_Level__c == 'Main' && itrApplication.Application_Stage__c == 'In-Review' && itrApplication.Service_Level__c == 'Premium'){                   
                    itrApplication.Last_App_Sync__c = system.now();
                    itrApplication.Application_Stage__c = 'Accepted';                    
                    itrApplication.Sys_Admin_Tag__c = TriggerExclusion.mapSkipAfterUpdate.get('AutoSyncRecord');
                    TriggerExclusion.skipUpdate_AutoSync = true;
                    lstApplication_WT.add(itrApplication);
                    setApplicationId.add(itrApplication.Id);
                }
            }
        }
        
        if(setApplicationId != null && setApplicationId.size() > 0){
            lstApplicationWithChild = [select Id, NAME, Account__c, Type__c, Engagement__c, Opportunity_Name__c, Home_Street_1__c, Home_Street_2__c, Home_City__c, Home_Postal_Code__c, Home_Country__c, Intrax_Program__c, INTRAX_REGION__C, MAJOR__C, PRIOR_EXCHANGE_EXPERIENCE__C , SCHOOL_NAME__C, ENGLISH_TEST_TYPE__C, 
                                       PROGRAM_YEAR__C, SEASON__C, COUNTRY_OF_INTEREST__C, SUBMITTED_DATE__C, POSITION_TYPES__C, ENGAGEMENT_START__C, ENGAGEMENT_END__C, SERVICE_LEVEL__C, LANGUAGE_1_PROFICIENCY__C, LANGUAGE_1__C, PARTNER_ACCOUNT__C, PARTNER_INTRAX_ID__C,
                                       Account__r.Name, Account__r.Id, Account__r.Auto_Sync_Account__c, Account__r.FirstName,Account__r.Middle_Name__pc,Account__r.LastName, Account__r.Type, Account__r.RecordTypeId, Account__r.OWNERID, Account__r.PHOTOURL, Account__r.INTRAX_PROGRAMS__C, Account__r.STATUS__C, Account__r.INTRAX_REGION__C, Account__r.J1_EXPERIENCE__C, Account__r.APISERVERURL__C,
                                       Account__r.APISESSIONID__C, Account__r.INTRAX_PROGRAMS__PC, Account__r.SKYPE_ID__PC, Account__r.GENDER__PC, Account__r.MAJOR__PC, Account__r.CITIZENSHIP__PC, Account__r.SCHOOL_NAME__PC, Account__r.ENGLISH_TEST__PC, Account__r.BIRTH_COUNTRY__PC, Account__r.BIRTH_CITY__PC, Account__r.LEGAL_RESIDENCE__PC, Account__r.STATUS__PC,
                                       Account__r.MANUALPARTNERSHAREEXISTS__PC, Account__r.MANUALHCPORTALUSERSHAREEXISTS__PC, Account__r.ALUMNI_SHARE_CONTACT_INFO__PC, Account__r.ISCONTACTNOTSERVICED__PC, Account__r.PERSONBIRTHDATE, Account__r.PersonHomePhone, Account__r.PersonContactId, Account__r.PersonEmail, Account__r.IsPersonAccount, Account__r.PersonMailingStreet, Account__r.PersonMailingCity,
                                       Opportunity_Name__r.ACCOUNTID, Opportunity_Name__r.Auto_Sync_Opprotunity__c, Opportunity_Name__r.RECORDTYPEID, Opportunity_Name__r.NAME, Opportunity_Name__r.STAGENAME, Opportunity_Name__r.CLOSEDATE, Opportunity_Name__r.TYPE, Opportunity_Name__r.OWNERID, Opportunity_Name__r.PROGRAM_YEAR__C, Opportunity_Name__r.SEASON__C, Opportunity_Name__r.INTRAX_PROGRAMS__C, Opportunity_Name__r.COUNTRIES_OF_INTEREST__C,
                                       Opportunity_Name__r.APPLICATION_DATE__C, Opportunity_Name__r.POSITION_TYPES__C, Opportunity_Name__r.PAX__C, Opportunity_Name__r.ENGAGEMENT_START__C, Opportunity_Name__r.ENGAGEMENT_END__C, Opportunity_Name__r.SERVICE_LEVEL__C, Opportunity_Name__r.INTRAX_REGION__C, Opportunity_Name__r.COMPENSATION_TYPE__C, Opportunity_Name__r.RENEWAL__C, Opportunity_Name__r.FLEXIBLE_DATES__C,
                                       Opportunity_Name__r.PRIMARY_CONTACT__C, Opportunity_Name__r.LANGUAGE_1_PROFICIENCY__C, Opportunity_Name__r.LANGUAGE_1__C, Opportunity_Name__r.PARTNER_ACCOUNT__C, Opportunity_Name__r.COUNTRY_OF_INTEREST__C, Opportunity_Name__r.PARTNER_ID__C, Opportunity_Name__r.BILL_TO_NAME__C, Opportunity_Name__r.BILL_TO_INTACCT_ID__C, Opportunity_Name__r.END_CUSTOMER_SHIP_TO__C, Opportunity_Name__r.SHIP_TO_END_CUSTOMER__C,                                          
                                       Engagement__r.Id, Engagement__r.OWNERID, Engagement__r.NAME, Engagement__r.Auto_Sync_Engagement__c, Engagement__r.RECORDTYPEID, Engagement__r.ACCOUNT_ID__C, Engagement__r.ENGAGEMENT_COUNTRY__C, Engagement__r.ENGAGEMENT_END__C, Engagement__r.ENGAGEMENT_START__C, Engagement__r.INTRAX_PROGRAM__C, Engagement__r.INTRAX_REGION__C, Engagement__r.OPPORTUNITY_ID__C, Engagement__r.POSITION_TYPES__C, Engagement__r.STATUS__C, Engagement__r.TYPE__C,
                                       Engagement__r.COMPENSATION_TYPE__C, Engagement__r.COUNTRIES_OF_INTEREST__C, Engagement__r.FLEXIBLE_DATES__C, Engagement__r.FLEXIBLE_LOCATION__C, Engagement__r.LANGUAGE_1_PROFICIENCY__C, Engagement__r.LANGUAGE_1__C, Engagement__r.PARTNER_ACCOUNT__C, Engagement__r.PARTNER_ID__C, Engagement__r.PROGRAM_YEAR__C, Engagement__r.MAJOR__C, Engagement__r.SCHOOL_NAME__C, Engagement__r.OTHER_FINANCIAL_SUPPORT__C,
                                       Engagement__r.OTHER_ORG_FUNDING__C, Engagement__r.OTHER_ORG_NAME__C, Engagement__r.PERSONAL_FUNDS__C, Engagement__r.SEVIS_POSITION__C, Engagement__r.SEVIS_PROGRAM__C, Engagement__r.SEVIS_SUBJECT_CATEGORY__C, Engagement__r.SEVIS_SUBJECT_CODE__C, Engagement__r.SEASON__C, Engagement__r.SERVICE_LEVEL__C, Engagement__r.APPLICATION_ACCEPTED_DATE__C, 
                                       (select Id, Name, First_Name__c,Middle_Name__c,Last_Name__c, MOBILE__C, ROLE_OTHER__C, ROLE__C, PHONE__C, Auto_Sync_Person_Info__c, EMAIL__C, DATE_OF_BIRTH__C, SKYPE_ID__C, GENDER__C, CITIZENSHIP__C, BIRTH_COUNTRY__C, BIRTH_CITY__C, COUNTRY_OF_RESIDENCE__C, Primary_Applicant__c from Person_Info__r) from Applicant_Info__c where Id IN :setApplicationId];
            for(Applicant_Info__c itrApp : lstApplicationWithChild){                
                for(Person_Info__c itrPersonInfo : itrApp.Person_Info__r){
                    if(itrPersonInfo.Primary_Applicant__c){
                        lstPersonInfo_PrimaryApplication.add(itrPersonInfo);
                    }else{
                        lstPersonInfo_NotPrimaryApplication.add(itrPersonInfo);
                    }
                }
                if(lstPersonInfo_PrimaryApplication != null && lstPersonInfo_PrimaryApplication.size() > 0){
                    mapPersonInfo.put(itrApp.Id, lstPersonInfo_PrimaryApplication);
                }
                if(lstPersonInfo_NotPrimaryApplication != null && lstPersonInfo_NotPrimaryApplication.size() > 0){
                    mapPersonInfo_NotPrimary.put(itrApp.Id, lstPersonInfo_NotPrimaryApplication);
                }
            }
        }
        
        //Mapping logic
        if(lstApplicationWithChild != null && lstApplicationWithChild.size() > 0){
            
            //----------------------------- Account logic starts here -------------------------------//
            for(Applicant_Info__c itrApplication_WT : lstApplicationWithChild){
                
                //Account details
                if(itrApplication_WT.Account__c != null){
                    if(mapPersonInfo != null && mapPersonInfo.size() > 0){
                        if(mapPersonInfo.get(itrApplication_WT.Id) != null){
                            Account account = accountDetails(itrApplication_WT);
                            lstPersonAccountToUpdate.add(account);
                        }
                    }
                }else{
                    if(mapPersonInfo != null && mapPersonInfo.size() > 0){
                        if(mapPersonInfo.get(itrApplication_WT.Id) != null){
                            Account account = accountDetails(itrApplication_WT);
                            lstPersonAccountToInsert.add(account);
                        }
                    }
                }                    
            }
            
            //Account to Update or Insert
            if(lstPersonAccountToUpdate != null && lstPersonAccountToUpdate.size() > 0){
                TriggerExclusion.triggerExclude('Account', true);
                update lstPersonAccountToUpdate;
                TriggerExclusion.triggerExclude('Account', false);
            }
            if(lstPersonAccountToInsert != null && lstPersonAccountToInsert.size() > 0){
                TriggerExclusion.triggerExclude('Account', true);
                insert lstPersonAccountToInsert;
                TriggerExclusion.triggerExclude('Account', false);                
                //Tag account to application.
                for(Applicant_Info__c itrAppInfo : lstApplication_WT){
                    for(Account itrAccount : lstPersonAccountToInsert){
                        Id applicationId = Id.valueOf(itrAccount.Auto_Sync_Account__c);
                        if(applicationId == itrAppInfo.Id){
                            itrAppInfo.Account__c = itrAccount.Id;
                        }
                    }                       
                }           
            }
            //----------------------------- Account logic ends here -------------------------------//
            
            //----------------------------- Opportunity logic starts here -------------------------------//     
            //Opportunity details.
            for(Applicant_Info__c itrAppInfo : lstApplication_WT){
                if(itrAppInfo.Account__c != null){
                    setAccountId_Opportunity.add(itrAppInfo.Account__c);
                }
            }
            if(setAccountId_Opportunity != null && setAccountId_Opportunity.size() > 0){
                lstAccount_Opportunity = [select Id, (select Id, ACCOUNTID, Auto_Sync_Opprotunity__c, RECORDTYPEID, NAME, STAGENAME, CLOSEDATE, TYPE, OWNERID, PROGRAM_YEAR__C, SEASON__C, INTRAX_PROGRAMS__C, COUNTRIES_OF_INTEREST__C,
                                           APPLICATION_DATE__C, POSITION_TYPES__C, PAX__C, ENGAGEMENT_START__C, ENGAGEMENT_END__C, SERVICE_LEVEL__C, INTRAX_REGION__C, COMPENSATION_TYPE__C, RENEWAL__C, FLEXIBLE_DATES__C,
                                           PRIMARY_CONTACT__C, LANGUAGE_1_PROFICIENCY__C, LANGUAGE_1__C, PARTNER_ACCOUNT__C, COUNTRY_OF_INTEREST__C, PARTNER_ID__C, BILL_TO_NAME__C, BILL_TO_INTACCT_ID__C, END_CUSTOMER_SHIP_TO__C, SHIP_TO_END_CUSTOMER__C 
                                           from Opportunities where RECORDTYPEID = :Constants.OPP_WORK_TRAVEL_PT and (STAGENAME = 'Prospecting' or STAGENAME = 'Review' or STAGENAME = 'Qualified' or STAGENAME = 'Processing' or STAGENAME = 'Finalization') 
                                           ORDER BY LastModifiedDate DESC limit 1) from Account where Id IN :setAccountId_Opportunity];
                for(Account itrAccount : lstAccount_Opportunity){
                    mapOpportunity.put(itrAccount.Id, itrAccount.Opportunities);
                }
            }
            
            for(Applicant_Info__c itrApplication_WT : lstApplicationWithChild){
                if(itrApplication_WT.Opportunity_Name__c != null){
                    Opportunity opportunity = opportunityDetails(itrApplication_WT, lstApplication_WT, new list<Opportunity>());
                    lstOpportunityToUpdate.add(opportunity);
                }else{
                    Integer countValue = 0;
                    for(Applicant_Info__c itrAppInfo : lstApplication_WT){
                        if(itrAppInfo.Id == itrApplication_WT.Id){
                            if(itrAppInfo.Account__c != null && mapOpportunity != null && mapOpportunity.get(itrAppInfo.Account__c) != null && mapOpportunity.get(itrAppInfo.Account__c).size() > 0){
                                countValue++;
                                Opportunity opportunity = opportunityDetails(itrApplication_WT, lstApplication_WT, mapOpportunity.get(itrAppInfo.Account__c));
                                lstOpportunityToUpdate.add(opportunity);
                                //Tag opportunity to application on update.
                                for(Opportunity itrOpp : lstOpportunityToUpdate){
                                    Id applicationId = Id.valueOf(itrOpp.Auto_Sync_Opprotunity__c);
                                    if(applicationId == itrAppInfo.Id){
                                        itrAppInfo.Opportunity_Name__c = itrOpp.Id;
                                    }
                                }     
                            }
                            if(countValue == 0){
                                 Opportunity opportunity = opportunityDetails(itrApplication_WT, lstApplication_WT, new list<Opportunity>());
                                lstOpportunityToInsert.add(opportunity);
                            }
                        }
                    }                   
                }   
            }
            
            //Opportunity to update or insert.
            if(lstOpportunityToUpdate != null && lstOpportunityToUpdate.size() > 0){
                TriggerExclusion.triggerExclude('Opportunity', true);
                update lstOpportunityToUpdate;
                TriggerExclusion.triggerExclude('Opportunity', false);
            }
            if(lstOpportunityToInsert != null && lstOpportunityToInsert.size() > 0){   
                TriggerExclusion.triggerExclude('Opportunity', true);
                insert lstOpportunityToInsert;
                TriggerExclusion.triggerExclude('Opportunity', false);
                
                //Tag opportunity to application on insert.              
                for(Applicant_Info__c itrAppInfo : lstApplication_WT){
                    for(Opportunity itrOpp : lstOpportunityToInsert){
                        Id applicationId = Id.valueOf(itrOpp.Auto_Sync_Opprotunity__c);
                        if(applicationId == itrAppInfo.Id){
                            itrAppInfo.Opportunity_Name__c = itrOpp.Id;
                        }
                    }                    
                }               
            }
            //----------------------------- Opportunity logic ends here -------------------------------//
            
            //----------------------------- Engagement logic starts here -------------------------------//
            //Engagment details.
            for(Applicant_Info__c itrAppInfo : lstApplication_WT){
                if(itrAppInfo.Engagement__c == null){
                    if(itrAppInfo.Opportunity_Name__c != null){
                        setOppId_Engagement.add(itrAppInfo.Opportunity_Name__c);
                    }
                }
            }
            
            if(setOppId_Engagement != null && setOppId_Engagement.size() > 0){
                lstOpportunity_Engagement = [select Id, (select Id, OWNERID, NAME, Auto_Sync_Engagement__c, RECORDTYPEID, ACCOUNT_ID__C, ENGAGEMENT_COUNTRY__C, ENGAGEMENT_END__C, ENGAGEMENT_START__C, INTRAX_PROGRAM__C, INTRAX_REGION__C, OPPORTUNITY_ID__C, POSITION_TYPES__C, STATUS__C, TYPE__C,
                                               COMPENSATION_TYPE__C, COUNTRIES_OF_INTEREST__C, FLEXIBLE_DATES__C, FLEXIBLE_LOCATION__C, LANGUAGE_1_PROFICIENCY__C, LANGUAGE_1__C, PARTNER_ACCOUNT__C, PARTNER_ID__C, PROGRAM_YEAR__C, MAJOR__C, SCHOOL_NAME__C, OTHER_FINANCIAL_SUPPORT__C,
                                               OTHER_ORG_FUNDING__C, OTHER_ORG_NAME__C, PERSONAL_FUNDS__C, SEVIS_POSITION__C, SEVIS_PROGRAM__C, SEVIS_SUBJECT_CATEGORY__C, SEVIS_SUBJECT_CODE__C, SEASON__C, SERVICE_LEVEL__C, APPLICATION_ACCEPTED_DATE__C from Engagements__r where 
                                               RECORDTYPEID = :Constants.ENG_WORK_TRAVEL_PT ORDER BY LastModifiedDate DESC limit 1) from Opportunity where Id IN :setOppId_Engagement];
                
                for(Opportunity itrOpp : lstOpportunity_Engagement){
                    mapEngagement.put(itrOpp.Id, itrOpp.Engagements__r);
                }
            }
            
            for(Applicant_Info__c itrApplication_WT : lstApplicationWithChild){
                if(itrApplication_WT.Engagement__c != null){
                    System.debug('Tagged :: Opportunity Engagement PartnerId'+itrApplication_WT.Engagement__r.PARTNER_ID__C);
                    mapEngPartnerId.put(itrApplication_WT.Engagement__c , itrApplication_WT.Engagement__r.PARTNER_ID__C);                  
                    Engagement__c engagement = engagementDetails(itrApplication_WT, lstApplication_WT, new list<Engagement__c>());
                    lstEngagementToUpdate.add(engagement);
                }else{ 
                    Integer countValue = 0;
                    for(Applicant_Info__c itrAppInfo : lstApplication_WT){
                        if(itrAppInfo.Id == itrApplication_WT.Id){
                            if(itrAppInfo.Opportunity_Name__c != null && mapEngagement != null && mapEngagement.get(itrAppInfo.Opportunity_Name__c) != null && mapEngagement.get(itrAppInfo.Opportunity_Name__c).size() > 0){
                                countValue++;
                                System.debug('Update :: Opportunity Engagement PartnerId'+mapEngagement.get(itrAppInfo.Opportunity_Name__c)[0].PARTNER_ID__C);
                                mapEngPartnerId.put(mapEngagement.get(itrAppInfo.Opportunity_Name__c)[0].Id , mapEngagement.get(itrAppInfo.Opportunity_Name__c)[0].PARTNER_ID__C);
                                                             
                                Engagement__c engagement = engagementDetails(itrApplication_WT, lstApplication_WT, mapEngagement.get(itrAppInfo.Opportunity_Name__c));
                                lstEngagementToUpdate.add(engagement);
                                //Tag engagement to application on update.
                                for(Engagement__c itrEng : lstEngagementToUpdate){
                                    Id applicationId = Id.valueOf(itrEng.Auto_Sync_Engagement__c);
                                    if(applicationId == itrAppInfo.Id){
                                        itrAppInfo.Engagement__c = itrEng.Id;
                                    }
                                }      
                            }
                            if(countValue == 0){
                                Engagement__c engagement = engagementDetails(itrApplication_WT, lstApplication_WT, new list<Engagement__c>());
                                System.debug('Insert:: Opportunity Engagement PartnerId'+engagement.PARTNER_ID__C);
                                lstEngagementToInsert.add(engagement);
                            }
                        }
                    }
                }
            }
            
            //Engagement to update or insert.
            if(lstEngagementToUpdate != null && lstEngagementToUpdate.size() > 0){
                TriggerExclusion.triggerExclude('Engagement', true);
                update lstEngagementToUpdate;
                TriggerExclusion.triggerExclude('Engagement', false);
            }
            if(lstEngagementToInsert != null && lstEngagementToInsert.size() > 0){                
                TriggerExclusion.triggerExclude('Engagement', true);
                insert lstEngagementToInsert;
                TriggerExclusion.triggerExclude('Engagement', false);
                               
                //Tag engagement to application on insert.
                for(Applicant_Info__c itrAppInfo : lstApplication_WT){
                    for(Engagement__c itrEng : lstEngagementToInsert){
                        Id applicationId = Id.valueOf(itrEng.Auto_Sync_Engagement__c);
                        if(applicationId == itrAppInfo.Id){
                            itrAppInfo.Engagement__c = itrEng.Id;
                        }
                    }                    
                }       
            }
            
            /* D-02207 Start */          
            for(Engagement__c itrinsertEng : lstEngagementToInsert){
                setInsertEngIds.add(itrinsertEng.Id);
            }
            System.debug('Map Engagement'+mapEngPartnerId);
            for(Engagement__c itrupdateEng : lstEngagementToUpdate){
                if(itrupdateEng.PARTNER_ID__C != null && mapEngPartnerId !=null && mapEngPartnerId.size()>0){
                        if(itrupdateEng.PARTNER_ID__C != mapEngPartnerId.get(itrupdateEng.Id)){
                           System.debug('Engagement PartnerId'+itrupdateEng.PARTNER_ID__C+'Old Engagement ID'+mapEngPartnerId.get(itrupdateEng.Id));
                            setupdateEngIds.add(itrupdateEng.Id);
                        }
                    }
            }
            
            // To share Application createdby__c to Engagement,Account
            if(setInsertEngIds != null && setInsertEngIds.size() >= 1){
                SharingSecurityHelper.shareEngagement(setInsertEngIds, setInsertEngIds, setCREngIds);
            }
            
            //To share Engagement,Account with tagged PartnerId to all its respective partner users.
            if(setupdateEngIds != null && setupdateEngIds.size() >= 1){
                SharingSecurityHelper.shareEngagement(setupdateEngIds, setupdateEngIds, setCREngIds);
            }
            /* D-02207 End */ 
           
            //----------------------------- Engagement logic ends here -------------------------------//
        }
        
        //----------------------------- Person Info and Member logic starts here -------------------------------//                       
        if(mapPersonInfo_NotPrimary != null && mapPersonInfo_NotPrimary.size() > 0){
            if(lstPersonAccountToInsert != null && lstPersonAccountToInsert.size() > 0){                
                for(Account itrAccount : lstPersonAccountToInsert){
                    setNewAccount.add(itrAccount.Id);
                }
                if(setNewAccount != null && setNewAccount.size() > 0){
                    for(Applicant_Info__c itrAppInfo : lstApplication_WT){
                        if(itrAppInfo.Account__c != null){
                            if(setNewAccount.contains(itrAppInfo.Account__c)){
                                if(mapPersonInfo_NotPrimary.get(itrAppInfo.Id) != null){
                                    for(Person_Info__c itrPersonInfo : mapPersonInfo_NotPrimary.get(itrAppInfo.Id)){
                                        Member__c newMember = memberDetails(new Member__c(), itrPersonInfo, itrAppInfo.Account__c);
                                        lstMemberToInsert.add(newMember);
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            for(Person_Info__c itrPersonInfo : lstPersonInfo_NotPrimaryApplication){
                if(itrPersonInfo.Auto_Sync_Person_Info__c != null){
                    setAccountId_FromPersonInfo.add(itrPersonInfo.Auto_Sync_Person_Info__c);
                }
            }
            if(setAccountId_FromPersonInfo != null && setAccountId_FromPersonInfo.size() > 0){
                lstAccount_MemberDetails = [select Id, (select Id, NAME, ACCOUNT_NAME__C, EMAIL__C, EMERGENCY_CONTACT_INDICATED__C, FIRST_NAME__C, LAST_NAME__C, MOBILE__C, ROLE_OTHER__C, ROLE__C from Members__r) from Account where Id IN :setAccountId_FromPersonInfo];
                for(Account itrAccount : lstAccount_MemberDetails){
                    String accountString = itrAccount.Id;                   
                    mapMember.put(accountString.subString(0,15), itrAccount.Members__r);
                }
            }
            
            for(Person_Info__c itrPersonInfo : lstPersonInfo_NotPrimaryApplication){
                if(itrPersonInfo.Auto_Sync_Person_Info__c != null){   
                    if(mapMember != null && mapMember.size() > 0){                      
                        if(mapMember.get(itrPersonInfo.Auto_Sync_Person_Info__c) != null){
                            for(Member__c itrMember : mapMember.get(itrPersonInfo.Auto_Sync_Person_Info__c)){
                                if(itrPersonInfo.Email__c == itrMember.Email__c && itrPersonInfo.FIRST_NAME__C == itrMember.FIRST_NAME__C && itrPersonInfo.LAST_NAME__C == itrMember.LAST_NAME__C){
                                    Member__c member = memberDetails(itrMember, itrPersonInfo, null);
                                    lstMemberToUpdate.add(member);
                                }
                            }
                            if(lstMemberToUpdate == null || lstMemberToUpdate.size() == 0){
                                Member__c newMember = memberDetails(new Member__c(), itrPersonInfo, null);
                                lstMemberToInsert.add(newMember);
                            }
                        }else{
                            Member__c newMember = memberDetails(new Member__c(), itrPersonInfo, null);
                            lstMemberToInsert.add(newMember);
                        }
                    }
                }
            }
            
            if(lstMemberToUpdate != null && lstMemberToUpdate.size() > 0){
                update lstMemberToUpdate;
            }
            if(lstMemberToInsert != null && lstMemberToInsert.size() > 0){
                insert lstMemberToInsert;
            }
        }
        //----------------------------- Person Info and Member logic ends here -------------------------------//
    }
    
    //This method used to check for auto app sync validation - Re-Worked by Hari
    public static map<String, list<Applicant_Info__c>> autoAppSyncValidation(list<Applicant_Info__c> lstApplication_TriggerNew, Boolean skipAutoAppSyncValidation){
        set<Id> setApplicationId = new set<Id>();
        list<Applicant_Info__c> lstApplication = new list<Applicant_Info__c>();
        map<String, Country_Names__c> mapCountryNames = new map<String, Country_Names__c>();
        list<Applicant_Info__c> lstApplication_include = new list<Applicant_Info__c>();
        list<Applicant_Info__c> lstApplication_exclude = new list<Applicant_Info__c>();
        map<Id, String> mapValidationMessage = new map<Id, String>();
        map<String, list<Applicant_Info__c>> mapApplication = new map<String, list<Applicant_Info__c>>();
        mapCountryNames = Country_Names__c.getall();
        String patternSpecialCharacter = '[^\\w\\s\\*]';
        Pattern patternFormat = Pattern.compile(patternSpecialCharacter);   
        Matcher matcher;    
        for(Applicant_Info__c itrApplication : lstApplication_TriggerNew){
            setApplicationId.add(itrApplication.Id);
        }
        
        if(setApplicationId != null && setApplicationId.size() > 0){
            lstApplication = [Select id, Validation_Failure_Reason__c, Engagement_Start__c,Account__r.PersonContact.FirstName,Account__r.PersonContact.LastName,Account__r.Middle_Name__pc,Engagement_End__c,Partner_Account__c,
                                Account__r.PersonContact.Birthdate,Account__r.Legal_Residence__pc,Name from Applicant_Info__c where Id IN :setApplicationId];
        }   
        
        if(lstApplication != null && lstApplication.size() > 0){
            for(Applicant_Info__c itrApplication : lstApplication){
                String validationMessage = '';
                String accountName = '';
                if(itrApplication.Account__r != null){
                    if(itrApplication.Engagement_Start__c != null && (itrApplication.Engagement_Start__c.YEAR()-itrApplication.Account__r.PersonContact.Birthdate.YEAR() < 18)){
                        validationMessage = 'Participant will not be 18 by program start.';
                    }
                    if (itrApplication.Engagement_Start__c != null && (itrApplication.Engagement_Start__c.YEAR()-itrApplication.Account__r.PersonContact.Birthdate.YEAR()>= 28)){
                        validationMessage = (validationMessage == '' ? 'Participant will be 28 or older by program start.' : validationMessage + ', Participant will be 28 or older by program start.');
                    }                   
                    if(itrApplication.Account__r.PersonContact.FirstName != null){
                        accountName = itrApplication.Account__r.PersonContact.FirstName;
                    }
                    if(itrApplication.Account__r.Middle_Name__pc != null){
                        accountName = (accountName == '' ? itrApplication.Account__r.Middle_Name__pc  : accountName + ' ' +itrApplication.Account__r.Middle_Name__pc );
                    }
                    accountName = (accountName == '' ? itrApplication.Account__r.PersonContact.LastName : accountName + ' ' +itrApplication.Account__r.PersonContact.LastName);
                    matcher = patternFormat.matcher(accountName);   
                    if(matcher.find()){
                        validationMessage = (validationMessage == '' ? 'Participant name contains special character' : validationMessage + ', Participant name contains special character.');
                    }                   
                    if(mapCountryNames.get(itrApplication.Account__r.Legal_Residence__pc) != null){
                        Country_Names__c countryNames = mapCountryNames.get(itrApplication.Account__r.Legal_Residence__pc);
                        if((itrApplication.Engagement_Start__c < countryNames.WT_Valid_Start_Date__c || itrApplication.Engagement_End__c > countryNames.WT_Valid_End_Date__c)&&(countryNames.WT_Valid_Start_Date__c != null && countryNames.WT_Valid_End_Date__c !=null)){
                            validationMessage = (validationMessage == '' ? 'Engagement Dates fall outside WT Embassy Dates.': validationMessage + ', Engagement Dates fall outside WT Embassy Dates.');
                        }
                    }
                }
                if ((itrApplication.Engagement_Start__c == null && itrApplication.Engagement_End__c !=null)|| (itrApplication.Engagement_Start__c != null && itrApplication.Engagement_End__c == null)){
                    validationMessage = (validationMessage == '' ? 'One of the Engagement start or end dates are missing.': validationMessage + ', One of the Engagement start or end dates are missing.');
                }
                if(itrApplication.Partner_Account__c == null){
                    validationMessage = (validationMessage == '' ? 'Application is not tagged to a Partner Agent.' : validationMessage + ', Application is not tagged to a Partner Agent.');
                }
                if(validationMessage != ''){
                    mapValidationMessage.put(itrApplication.Id, validationMessage);
                }
            }
            
            for(Applicant_Info__c itrApplication : lstApplication_TriggerNew){
                if(mapValidationMessage != null && mapValidationMessage.size() > 0 && mapValidationMessage.get(itrApplication.Id) != null){
                    if(!skipAutoAppSyncValidation){
                        itrApplication.Validation_Failure_Reason__c = mapValidationMessage.get(itrApplication.Id);
                    }
                    lstApplication_include.add(itrApplication);
                }else{
                    lstApplication_exclude.add(itrApplication);
                }
            }
            if(lstApplication_include != null && lstApplication_include.size() > 0){
                mapApplication.put('include', lstApplication_include); //No need of auto sync.
            }
            if(lstApplication_exclude != null && lstApplication_exclude.size() > 0){
                mapApplication.put('exclude', lstApplication_exclude); //auto sync required.
            }
        }
        return mapApplication;      
    }
    
    //Member record details.
    public static Member__c memberDetails(Member__c itrMember, Person_Info__c itrPersonInfo, Id newAccount){
        
        itrMember.NAME = itrPersonInfo.FIRST_Name__c + ' ' +itrPersonInfo.LAST_NAME__C;
        itrMember.ACCOUNT_NAME__C = (newAccount == null) ? itrPersonInfo.Auto_Sync_Person_Info__c : newAccount;
        itrMember.EMAIL__C = itrPersonInfo.EMAIL__C;
        itrMember.EMERGENCY_CONTACT_INDICATED__C = 'Yes';
        itrMember.FIRST_NAME__C = itrPersonInfo.FIRST_Name__c;
        itrMember.LAST_NAME__C = itrPersonInfo.LAST_NAME__C;
        itrMember.MOBILE__C = itrPersonInfo.MOBILE__C;
        itrMember.ROLE_OTHER__C = itrPersonInfo.ROLE_OTHER__C;
        itrMember.ROLE__C = itrPersonInfo.ROLE__C;
        return itrMember;
    }
    
    //Account record details.
    public static Account accountDetails(Applicant_Info__c itrApplication_WT){
        
        if(itrApplication_WT.Account__r == null){
            itrApplication_WT.Account__r = new Account();
            itrApplication_WT.Account__r.Auto_Sync_Account__c = itrApplication_WT.Id;
            itrApplication_WT.Account__r.Status__c = 'Contracted';
        }        
        if(itrApplication_WT.Account__r != null){
            if(itrApplication_WT.Account__r.Status__c == 'Prospect'){
                itrApplication_WT.Account__r.Status__c = 'Contracted';
            }
        }
        itrApplication_WT.Account__r.FirstName = itrApplication_WT.Person_Info__r[0].First_Name__c;
        itrApplication_WT.Account__r.Middle_Name__pc = itrApplication_WT.Person_Info__r[0].Middle_Name__c;
        itrApplication_WT.Account__r.LastName = itrApplication_WT.Person_Info__r[0].Last_Name__c;
        itrApplication_WT.Account__r.Type = itrApplication_WT.Type__c;
        itrApplication_WT.Account__r.RecordTypeId = Constants.Account_Participant; 
        itrApplication_WT.Account__r.BillingStreet = itrApplication_WT.Home_Street_1__c +'\n' +itrApplication_WT.Home_Street_2__c;
        itrApplication_WT.Account__r.BillingCity = itrApplication_WT.Home_City__c;  
        itrApplication_WT.Account__r.BillingPostalCode = itrApplication_WT.Home_Postal_Code__c;
        itrApplication_WT.Account__r.BillingCountry = itrApplication_WT.Home_Country__c;
        //itrApplication_WT.Account__r.PersonContactId = 
        itrApplication_WT.Account__r.PersonMailingStreet = itrApplication_WT.Home_Street_1__c +'\n' +itrApplication_WT.Home_Street_2__c;
        itrApplication_WT.Account__r.PersonMailingCity = itrApplication_WT.Home_City__c;    
        itrApplication_WT.Account__r.PersonMailingPostalCode = itrApplication_WT.Home_Postal_Code__c;
        itrApplication_WT.Account__r.PersonMailingCountry = itrApplication_WT.Home_Country__c;
        itrApplication_WT.Account__r.PersonHomePhone = itrApplication_WT.Person_Info__r[0].PHONE__C;
        itrApplication_WT.Account__r.PersonEmail =  itrApplication_WT.Person_Info__r[0].EMAIL__C;
        itrApplication_WT.Account__r.PERSONBIRTHDATE =  itrApplication_WT.Person_Info__r[0].DATE_OF_BIRTH__C;
        itrApplication_WT.Account__r.INTRAX_PROGRAMS__C = itrApplication_WT.INTRAX_PROGRAM__C;
        itrApplication_WT.Account__r.INTRAX_REGION__C = itrApplication_WT.INTRAX_REGION__C;      
        itrApplication_WT.Account__r.INTRAX_PROGRAMS__PC = itrApplication_WT.INTRAX_PROGRAM__C;
        itrApplication_WT.Account__r.SKYPE_ID__PC = itrApplication_WT.Person_Info__r[0].SKYPE_ID__C;
        itrApplication_WT.Account__r.GENDER__PC = itrApplication_WT.Person_Info__r[0].GENDER__C;
        itrApplication_WT.Account__r.MAJOR__PC = itrApplication_WT.MAJOR__C;
        itrApplication_WT.Account__r.CITIZENSHIP__PC = itrApplication_WT.Person_Info__r[0].CITIZENSHIP__C;
        itrApplication_WT.Account__r.SCHOOL_NAME__PC = itrApplication_WT.SCHOOL_NAME__C;
        itrApplication_WT.Account__r.ENGLISH_TEST__PC = itrApplication_WT.ENGLISH_TEST_TYPE__C;
        itrApplication_WT.Account__r.BIRTH_COUNTRY__PC = itrApplication_WT.Person_Info__r[0].BIRTH_COUNTRY__C;
        itrApplication_WT.Account__r.BIRTH_CITY__PC = itrApplication_WT.Person_Info__r[0].BIRTH_CITY__C;
        itrApplication_WT.Account__r.LEGAL_RESIDENCE__PC = itrApplication_WT.Person_Info__r[0].COUNTRY_OF_RESIDENCE__C;
        itrApplication_WT.Account__r.STATUS__PC = 'Active';
        return itrApplication_WT.Account__r;
    }
    
    //Opportunity record details.
    public static Opportunity opportunityDetails(Applicant_Info__c itrApplication_WT, list<Applicant_Info__c> lstApplication_WT, list<Opportunity> lstOpportunity){
        
        if(itrApplication_WT.Opportunity_Name__r == null){
            if(lstOpportunity != null && lstOpportunity.size() > 0){
                itrApplication_WT.Opportunity_Name__r = new Opportunity();
                itrApplication_WT.Opportunity_Name__r = lstOpportunity[0];
                itrApplication_WT.Opportunity_Name__r.Auto_Sync_Opprotunity__c = itrApplication_WT.Id;                
                
                for(Applicant_Info__c itrAppInfo : lstApplication_WT){
                    if(itrAppInfo.Id == itrApplication_WT.Id){
                        if(itrAppInfo.Account__c != null){
                            itrApplication_WT.Opportunity_Name__r.AccountId = itrAppInfo.Account__c;
                        }
                    }               
                }
            }
        }
        
        if(itrApplication_WT.Opportunity_Name__r == null){
            itrApplication_WT.Opportunity_Name__r = new Opportunity();
            itrApplication_WT.Opportunity_Name__r.STAGENAME = 'Processing';
            itrApplication_WT.Opportunity_Name__r.CLOSEDATE = Date.valueof(system.now());
            itrApplication_WT.Opportunity_Name__r.Auto_Sync_Opprotunity__c = itrApplication_WT.Id;
            for(Applicant_Info__c itrAppInfo : lstApplication_WT){
                if(itrAppInfo.Id == itrApplication_WT.Id){
                    if(itrAppInfo.Account__c != null){
                        itrApplication_WT.Opportunity_Name__r.AccountId = itrAppInfo.Account__c;
                    }
                }               
            }
        }
        
        if(itrApplication_WT.Opportunity_Name__r != null){
            if(itrApplication_WT.Opportunity_Name__r.STAGENAME == 'Prospecting' || itrApplication_WT.Opportunity_Name__r.STAGENAME == 'Review' || itrApplication_WT.Opportunity_Name__r.STAGENAME == 'Qualified'){
                    itrApplication_WT.Opportunity_Name__r.STAGENAME = 'Processing';
            }
        }
        
        itrApplication_WT.Opportunity_Name__r.RECORDTYPEID = Constants.OPP_WORK_TRAVEL_PT;
        itrApplication_WT.Opportunity_Name__r.NAME = itrApplication_WT.Name;
        itrApplication_WT.Opportunity_Name__r.TYPE = itrApplication_WT.Type__c;
        itrApplication_WT.Opportunity_Name__r.PROGRAM_YEAR__C = itrApplication_WT.PROGRAM_YEAR__C;
        itrApplication_WT.Opportunity_Name__r.SEASON__C = itrApplication_WT.SEASON__C;
        itrApplication_WT.Opportunity_Name__r.INTRAX_PROGRAMS__C = itrApplication_WT.INTRAX_PROGRAM__C;
        itrApplication_WT.Opportunity_Name__r.COUNTRIES_OF_INTEREST__C = itrApplication_WT.COUNTRY_OF_INTEREST__C;
        itrApplication_WT.Opportunity_Name__r.APPLICATION_DATE__C = itrApplication_WT.SUBMITTED_DATE__C;
        itrApplication_WT.Opportunity_Name__r.POSITION_TYPES__C = itrApplication_WT.POSITION_TYPES__C;
        itrApplication_WT.Opportunity_Name__r.PAX__C = 1;
        itrApplication_WT.Opportunity_Name__r.ENGAGEMENT_START__C = itrApplication_WT.ENGAGEMENT_START__C;
        itrApplication_WT.Opportunity_Name__r.ENGAGEMENT_END__C = itrApplication_WT.ENGAGEMENT_END__C;
        itrApplication_WT.Opportunity_Name__r.SERVICE_LEVEL__C = itrApplication_WT.SERVICE_LEVEL__C;
        itrApplication_WT.Opportunity_Name__r.INTRAX_REGION__C = itrApplication_WT.INTRAX_REGION__C;
        //itrApplication_WT.Opportunity_Name__r.PRIMARY_CONTACT__C = 
        itrApplication_WT.Opportunity_Name__r.LANGUAGE_1_PROFICIENCY__C = itrApplication_WT.LANGUAGE_1_PROFICIENCY__C;
        itrApplication_WT.Opportunity_Name__r.LANGUAGE_1__C = itrApplication_WT.LANGUAGE_1__C;
        itrApplication_WT.Opportunity_Name__r.PARTNER_ACCOUNT__C = itrApplication_WT.PARTNER_ACCOUNT__C;
        itrApplication_WT.Opportunity_Name__r.PARTNER_ID__C = itrApplication_WT.PARTNER_INTRAX_ID__C;
        itrApplication_WT.Opportunity_Name__r.BILL_TO_NAME__C = 'B_' +itrApplication_WT.Opportunity_Name__r.ACCOUNT_ID__C;
        itrApplication_WT.Opportunity_Name__r.BILL_TO_INTACCT_ID__C = itrApplication_WT.Opportunity_Name__r.ACCOUNT_ID__C;
        itrApplication_WT.Opportunity_Name__r.END_CUSTOMER_SHIP_TO__C = 'S_' +itrApplication_WT.Opportunity_Name__r.ACCOUNT_ID__C;
        itrApplication_WT.Opportunity_Name__r.SHIP_TO_END_CUSTOMER__C = true;
        return itrApplication_WT.Opportunity_Name__r;
    }
    
    //Engagement record details
    public static Engagement__c engagementDetails(Applicant_Info__c itrApplication_WT, list<Applicant_Info__c> lstApplication_WT, list<Engagement__c> lstEngagement){
        
        if(itrApplication_WT.Engagement__r == null){             
             if(lstEngagement != null && lstEngagement.size() > 0){
                itrApplication_WT.Engagement__r = new Engagement__c();
                itrApplication_WT.Engagement__r = lstEngagement[0];
                itrApplication_WT.Engagement__r.Auto_Sync_Engagement__c = itrApplication_WT.Id;
                
                for(Applicant_Info__c itrAppInfo : lstApplication_WT){                         
                    if(itrAppInfo.Id == itrApplication_WT.Id){
                        if(itrAppInfo.Account__c != null){
                            itrApplication_WT.Engagement__r.Account_Id__c = itrAppInfo.Account__c;
                        }
                        if(itrAppInfo.Opportunity_Name__c != null){
                            itrApplication_WT.Engagement__r.Opportunity_Id__c = itrAppInfo.Opportunity_Name__c;
                        }
                    }
                }
             }
        }
        
        if(itrApplication_WT.Engagement__r == null){
            itrApplication_WT.Engagement__r = new Engagement__c();
            itrApplication_WT.Engagement__r.Auto_Sync_Engagement__c = itrApplication_WT.Id;
            itrApplication_WT.Engagement__r.Status__c = 'Processing';
            
            for(Applicant_Info__c itrAppInfo : lstApplication_WT){                         
                if(itrAppInfo.Id == itrApplication_WT.Id){
                    if(itrAppInfo.Account__c != null){
                        itrApplication_WT.Engagement__r.Account_Id__c = itrAppInfo.Account__c;
                    }
                    if(itrAppInfo.Opportunity_Name__c != null){
                        itrApplication_WT.Engagement__r.Opportunity_Id__c = itrAppInfo.Opportunity_Name__c;
                    }
                }
            }
        }
        
        if(itrApplication_WT.Engagement__r != null){
            if(itrApplication_WT.Engagement__r.Status__c == 'New'){
                itrApplication_WT.Engagement__r.Status__c = 'Processing';
            }
        }
        
        itrApplication_WT.Engagement__r.NAME = itrApplication_WT.NAME;
        itrApplication_WT.Engagement__r.RECORDTYPEID = Constants.ENG_WORK_TRAVEL_PT;
        itrApplication_WT.Engagement__r.ENGAGEMENT_COUNTRY__C = itrApplication_WT.COUNTRY_OF_INTEREST__C;
        itrApplication_WT.Engagement__r.ENGAGEMENT_END__C = itrApplication_WT.ENGAGEMENT_END__C;
        itrApplication_WT.Engagement__r.ENGAGEMENT_START__C = itrApplication_WT.ENGAGEMENT_START__C;
        itrApplication_WT.Engagement__r.INTRAX_PROGRAM__C = itrApplication_WT.INTRAX_PROGRAM__C;
        itrApplication_WT.Engagement__r.INTRAX_REGION__C = itrApplication_WT.INTRAX_REGION__C;
        itrApplication_WT.Engagement__r.POSITION_TYPES__C = itrApplication_WT.Position_Types__c;        
        itrApplication_WT.Engagement__r.TYPE__C = itrApplication_WT.TYPE__C;
        itrApplication_WT.Engagement__r.COUNTRIES_OF_INTEREST__C = itrApplication_WT.COUNTRY_OF_INTEREST__C;
        itrApplication_WT.Engagement__r.LANGUAGE_1_PROFICIENCY__C = itrApplication_WT.LANGUAGE_1_PROFICIENCY__C;
        itrApplication_WT.Engagement__r.LANGUAGE_1__C = itrApplication_WT.LANGUAGE_1__C;
        itrApplication_WT.Engagement__r.PARTNER_ACCOUNT__C = itrApplication_WT.PARTNER_ACCOUNT__C;
        itrApplication_WT.Engagement__r.PARTNER_ID__C = itrApplication_WT.PARTNER_INTRAX_ID__C;
        itrApplication_WT.Engagement__r.PROGRAM_YEAR__C = itrApplication_WT.PROGRAM_YEAR__C;
        itrApplication_WT.Engagement__r.MAJOR__C = itrApplication_WT.MAJOR__C;
        itrApplication_WT.Engagement__r.SCHOOL_NAME__C = itrApplication_WT.SCHOOL_NAME__C;
        itrApplication_WT.Engagement__r.SEASON__C = itrApplication_WT.SEASON__C;
        itrApplication_WT.Engagement__r.SERVICE_LEVEL__C = itrApplication_WT.SERVICE_LEVEL__C;
        itrApplication_WT.Engagement__r.APPLICATION_ACCEPTED_DATE__C = Date.valueof(system.now());
        return itrApplication_WT.Engagement__r;
    }
}