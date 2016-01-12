trigger Trigger_Lead_Routing on Lead (before insert) {

    if(trigger.isBefore){
        List<Lead> geoAPCHFLeads = new List<Lead>();
        
        for (Lead leadRec : Trigger.new) {
            /*List<Lead_Routing__c> leadRoutesQuery = new List<Lead_Routing__c>();
            if (leadRec.Country != null && leadRec.Country != ''){
                leadRoutesQuery = [select Country_of_Interest__c,Country_of_Origin__c,Intrax_Program__c,Intrax_Program_Option__c,Lead_Type__c,Priority__c,Program__c,Queue__c from Lead_Routing__c where (Country_Of_Origin__c = :leadRec.Country and Lead_Type__c = :leadRec.Lead_Type__c) order by Priority__c asc];
            }
            if (leadRoutesQuery.size() == 0 && leadRec.Citizenship__c != null && leadRec.Citizenship__c != ''){
                leadRoutesQuery = [select Country_of_Interest__c,Country_of_Origin__c,Intrax_Program__c,Intrax_Program_Option__c,Lead_Type__c,Priority__c,Program__c,Queue__c from Lead_Routing__c where (Country_Of_Origin__c = :leadRec.Citizenship__c and Lead_Type__c = :leadRec.Lead_Type__c) order by Priority__c asc];
            }
            if (leadRoutesQuery.size() == 0 && leadRec.mkto2__Inferred_Country__c != null && leadRec.mkto2__Inferred_Country__c != ''){
                leadRoutesQuery = [select Country_of_Interest__c,Country_of_Origin__c,Intrax_Program__c,Intrax_Program_Option__c,Lead_Type__c,Priority__c,Program__c,Queue__c from Lead_Routing__c where (Country_Of_Origin__c =: leadRec.mkto2__Inferred_Country__c and Lead_Type__c = :leadRec.Lead_Type__c) order by Priority__c asc];
            }*/            
                        
            List<LeadRouting__c> leadRoutesQuery = new List<LeadRouting__c>();
            if (leadRec.Country != null && leadRec.Country != ''){
                leadRoutesQuery = [select Id, Country_of_Interest__c,Country_of_Origin__c,Intrax_Program__c,Intrax_Program_Option__c,Lead_Type__c,Priority__c,Program__c,Queue__c from LeadRouting__c where (Country_Of_Origin__c = :leadRec.Country and Lead_Type__c = :leadRec.Lead_Type__c and NewRule__c = false) order by Priority__c asc];
            }
            if (leadRoutesQuery.size() == 0 && leadRec.Citizenship__c != null && leadRec.Citizenship__c != ''){
                leadRoutesQuery = [select Id, Country_of_Interest__c,Country_of_Origin__c,Intrax_Program__c,Intrax_Program_Option__c,Lead_Type__c,Priority__c,Program__c,Queue__c from LeadRouting__c where (Country_Of_Origin__c = :leadRec.Citizenship__c and Lead_Type__c = :leadRec.Lead_Type__c and NewRule__c = false) order by Priority__c asc];
            }
            if (leadRoutesQuery.size() == 0 && leadRec.mkto2__Inferred_Country__c != null && leadRec.mkto2__Inferred_Country__c != ''){
                leadRoutesQuery = [select Id, Country_of_Interest__c,Country_of_Origin__c,Intrax_Program__c,Intrax_Program_Option__c,Lead_Type__c,Priority__c,Program__c,Queue__c from LeadRouting__c where (Country_Of_Origin__c =: leadRec.mkto2__Inferred_Country__c and Lead_Type__c = :leadRec.Lead_Type__c and NewRule__c = false) order by Priority__c asc];
            }
            if (leadRoutesQuery.size() > 0){
                List<String> leadProgram = new List<String>();
                List<String> leadIntraxPrograms = new List<String>();
                List<String> leadIntraxProgramOptions = new List<String>();
                List<String> leadCountriesOfInterest = new List<String>();
                if (leadRec.Intrax_Programs__c !=  null && leadRec.Intrax_Programs__c.length() > 0){
                    for (String program : leadRec.Intrax_Programs__c.split(';')){
                        leadIntraxPrograms.add(program);
                    }
                }
                if (leadRec.Intrax_Program_Options__c != null && leadRec.Intrax_Program_Options__c.length() > 0){
                    for (String program : leadRec.Intrax_Program_Options__c.split(';')){
                        leadIntraxProgramOptions.add(program);
                    }
                }
                if (leadRec.Countries_of_Interest__c != null && leadRec.Countries_of_Interest__c.length() > 0){
                    for (String countryOfInterest : leadRec.Countries_of_Interest__c.split(';')){
                        leadCountriesOfInterest.add(countryOfInterest);
                    }
                }

                //List<String> countryOfInterestList = new List<String>();
                List<LeadRouting__c> countryOfInterestList = new List<LeadRouting__c>();
                Boolean matched = false;
                for (LeadRouting__c leadRoute : leadRoutesQuery){
                    if (leadRoute.Intrax_Program__c){
                        leadProgram = leadIntraxPrograms;
                    }
                    else if (leadRoute.Intrax_Program_Option__c ){
                        leadProgram = leadIntraxProgramOptions;
                    }
 
                    matched = false;
                    for (String program : leadProgram){
                        matched = false;
                        if (program == leadRoute.Program__c){
                        	if (countryOfInterestList.size() == 0 && (leadRoute.Country_of_Interest__c == null || leadRoute.Country_of_Interest__c == ''))
                        		countryOfInterestList.add(leadRoute);
                        		//countryOfInterestList.add(leadRoute.Queue__c );
                        	
                        	for (String countryOfInterest : leadCountriesOfInterest){
                        		if (countryOfInterest == leadRoute.Country_of_Interest__c){
                                    System.debug('leadRoute.Queue--->'+leadRoute.Queue__c);
                        			leadRec.Sys_Routing_Note__c = leadRoute.Queue__c;
                        			leadRec.LeadRouting_RuleName__c = leadRoute.Id;//For identify which lead routing rule tagged to Lead.
                            		matched = true;
                        		}
                        			
                        	}
                        }
                        if (matched)
                            break;
                    }
                    if (matched)
                        break;
                }
                
                if (!matched && countryOfInterestList.size() == 1){
                    System.debug('countryOfInterestList.get(0).Queue--->'+countryOfInterestList.get(0).Queue__c);
                	//leadRec.Sys_Routing_Note__c = countryOfInterestList.get(0);
                	leadRec.Sys_Routing_Note__c = countryOfInterestList.get(0).Queue__c;
                	leadRec.LeadRouting_RuleName__c = countryOfInterestList.get(0).Id;//For identify which lead routing rule tagged to Lead.
                }
                
            }
            
            if (leadRec.Lead_Type__c == 'Host Family' && leadRec.Intrax_Programs__c == 'AuPairCare'){
                geoAPCHFLeads.add(leadRec);
            }
            
        }
        
        if(geoAPCHFLeads!=null && geoAPCHFLeads.size()>0){            
            System.debug('Inside Lead Routing before instance creation--->');
    		googleGeoController gGeoC = new googleGeoController();
            gGeoC.sObjectList = geoAPCHFLeads;
            gGeoC.theInstanceGateKeeper();
        }
    }
}