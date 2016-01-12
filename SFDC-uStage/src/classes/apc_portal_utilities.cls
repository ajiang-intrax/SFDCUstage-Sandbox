public with sharing class apc_portal_utilities {

    /*
    Parameters for method highLightsBuilder
    -Parameter 1: Application record
    -Parameter 2: Primary Applicant record
    -Parameter 3: DocType: Lifeguard -- IPU list
    -Parameter 4: Sibling + Primary Person_Info List
    -Parameter 5: Childcare Experience List 
    -Parameter 6: University Education List
    -Parameter 7: Vocational Education List  
    
    */
    
    public static list<String> highLightsBuilder(Applicant_Info__c applicant, Person_Info__c primary,
                                        list<Intrax_Program_Upload__c> IPULifeList, list<Person_Info__c> siblingList,
                                        list<Experience__c> ChildList, list<Education__c> UniversityList,
                                        list<Education__c> VocationlList){

        list<String> listHL = new list<String>();
        list<String> listHLAux = new list<String>();
        String cond1tag = 'Previous Au Pair';
        String cond2tag = 'Advanced Education';
        String cond3tag = 'Older Sibling';
        String cond4tag = 'Lifeguard';
        String cond5atag = 'Nursing experience';
        String cond5btag = 'Trained in First Aid';
        String cond6tag = 'Teacher or Tutor';
        String cond7tag = 'Large Family';
        String cond8tag = 'Multiples Experience';
        String cond9tag = 'Athletic';
        String cond10tag = 'Multi-lingual';
        String cond11tag = 'Musical';
        String cond12tag = 'Lived Independently';
        String cond13tag = 'Cooking skills';
        String cond14tag = 'Traveler';
        
        //***Condition 1 - Previous Au Pair
        Boolean cond1 = false;
        Boolean cond6 = false;
        for(Experience__c c:ChildList){
            if(c.Experience_Type__c == 'Au Pair' ){
                cond1 = true;
            }
            if(c.Experience_Type__c == 'Teaching/Tutoring' ){
                cond6 = true;
            }
        }
        if(cond1 == true){
            listHL.add(cond1tag);
            system.debug('@@@@@ Meet Condition 1: ' + cond1tag);
        }
        //END condition 1
        
        //***Condition 2 - Advanced Education
        if(UniversityList != null && UniversityList.size()>0){
            listHL.add(cond2tag);
            system.debug('@@@@@ Meet Condition 2: ' + cond2tag);
        }
        //END condition 2
        
        //Condition 3 - Older Sibling
        Boolean cond3 = true;
        if(siblingList != null && siblingList.size()>0){
            for(Person_Info__c p:siblingList){
                if(primary.Date_of_Birth__c > primary.Date_of_Birth__c){
                    cond3 = false;
                    break;
                }
            }
            if(cond3 == true){
                listHL.add(cond3tag);
                system.debug('@@@@@ Meet Condition 3: ' + cond3tag);
            }
        }
        //END condition 3
        
        //***Condition 4 - Lifeguard
        if(IPULifeList != null && IPULifeList.size()>0){
            listHL.add(cond4tag);
            system.debug('@@@@@ Meet Condition 4: ' + cond4tag);
        }
        //END condition 4
        
        
        //***Condition 5 - Nursing experience
        Boolean cond5a = false;
        Boolean cond5b = false;
        if(VocationlList != null && VocationlList.size()>0){
            for(Education__c e:VocationlList){
                if(e.Program_Type__c == 'Nursing'){
                    cond5a = true;
                }
                if(e.Program_Type__c == 'First Aid'){
                    cond5b = true;
                }
            }
            if(cond5a == true){
                listHL.add(cond5atag);
                system.debug('@@@@@ Meet Condition 5a: ' + cond5atag);
            }
        }
        //END condition 5
        
        //***Condition 6 - Teacher or Tutor
        if(cond5b == true){
            listHL.add(cond5btag);
            system.debug('@@@@@ Meet Condition 5b: ' + cond5btag);
        }
        //END condition 6
        
        //***Condition 6 - Teacher or Tutor
        if(cond6 == true){
            listHL.add(cond6tag);
            system.debug('@@@@@ Meet Condition 6: ' + cond6tag);
        }
        //END condition 6
        
        //***Condition 7 - Large Family
        if(siblingList != null && siblingList.size()>2){
            listHL.add(cond7tag);
            system.debug('@@@@@ Meet Condition 7: ' + cond7tag);
        }
        //END condition 7
        
        /*Condition 8*/
        
        //***Condition 9 - Athletic
        if(applicant.Interest_Sports__c != null){
            listHL.add(cond9tag);   
            system.debug('@@@@@ Meet Condition 9: ' + cond9tag);
        }//END condition 9
        
        //***Condition 10 - Multi Language
        if(applicant.Language_2__c != null){
            listHL.add(cond10tag);  
            system.debug('@@@@@ Meet Condition 10: ' + cond10tag);
        }//END condition 10
        
        //***Condition 11 - Musical
        if(applicant.Interest_Fine_Arts__c != null){
            listHL.add(cond11tag);  
            system.debug('@@@@@ Meet Condition 11: ' + cond11tag);
        }//END condition 11
        
        
        //***Condition 12 - Lived Independently
        if(applicant.Lived_Independently__c == 'Yes'){
            listHL.add(cond12tag);  
            system.debug('@@@@@ Meet Condition 11: ' + cond12tag);
        }//END condition 12
        
        
        //***Condition 13 - Cooking skills
        if(applicant.Interests_Hobbies__c != null){
            if(applicant.Interests_Hobbies__c.contains('Cooking') || applicant.Interests_Hobbies__c.contains('Baking')){
                listHL.add(cond13tag);  
                system.debug('@@@@@ Meet Condition 13: ' + cond13tag);
            }
        }//END condition 13
        
        //***Condition 14 - Traveler
        if(applicant.US_Experience_Indicated__c == 'Yes'){
                listHL.add(cond14tag);  
                system.debug('@@@@@ Meet Condition 14: ' + cond14tag);
        }//END condition 14
        
        system.debug('@@@@@ listHL: ' + listHL);
        system.debug('@@@@@ listHL.size(): ' + listHL.size());
        
        if(listHL!=null){
            integer counter = 1;
            for(string s : listHL){ 
                if(counter <= 5){                        
                    if(!(new Set<String>(listHLAux)).contains(s))   {
                        listHLAux.add(s);           
                        counter++;  
                    }           
                }
            }   
        }else{
            listHLAux = listHL;
        }
            
        return listHLAux; 
    }
    
    public static map<String, list<String>> highLightsBuilder(list<Engagement__c> engagements){
                                        /*, Person_Info__c primary,
                                        list<Intrax_Program_Upload__c> IPULifeList, list<Person_Info__c> siblingList,
                                        list<Experience__c> ChildList, list<Education__c> UniversityList,
                                        list<Education__c> VocationlList){*/

        String cond1tag = 'Previous Au Pair';
        String cond2tag = 'Advanced Education';
        String cond3tag = 'Older Sibling';
        String cond4tag = 'Lifeguard';
        String cond5atag = 'Nursing experience';
        String cond5btag = 'Trained in First Aid';
        String cond6tag = 'Teacher or Tutor';
        String cond7tag = 'Large Family';
        String cond8tag = 'Multiples Experience';
        String cond9tag = 'Athletic';
        String cond10tag = 'Multi-lingual';
        String cond11tag = 'Musical';
        String cond12tag = 'Lived Independently';
        String cond13tag = 'Cooking skills';
        String cond14tag = 'Traveler';
        
        map<String, list<String>> my_hl = new map<String, list<String>>();
        map<String, list<String>> my_hl_final = new map<String, list<String>>();
        
        for(Engagement__c eng: engagements){
            my_hl.put(eng.Id, new list<String>());
            my_hl_final.put(eng.Id, new list<String>());
            
            if(eng.Interest_Sports__c != null){
                my_hl.get(eng.Id).add(cond9tag);
            }
            if(eng.Language_2__c != null){
                my_hl.get(eng.Id).add(cond10tag);
            }
            if(eng.Interest_Fine_Arts__c != null){
                my_hl.get(eng.Id).add(cond11tag);
            }
            if(eng.Interests_Hobbies__c != null){
                if(eng.Interests_Hobbies__c.contains('Cooking') || eng.Interests_Hobbies__c.contains('Baking')){
                    my_hl.get(eng.Id).add(cond13tag);                   
                }
            }
            
        }       
        
        if(engagements.size() > 0){
            String idString = '(\'';
            for (Engagement__c eng : engagements) {
                idString += eng.Id + '\',\'';
            }
            idString = idString.substring(0,idString.length()-2); 
            idString += ')';
        
            String q = 'SELECT Id, Experience_Type__c, Engagement__c FROM Experience__c WHERE Engagement__c IN ' + idString;
            list<Experience__c> experienceList = Database.query(q); 
        
        
            /*list<Experience__c> experienceList = [SELECT Id, Experience_Type__c, Engagement__c FROM Experience__c
                                                WHERE Engagement__c IN: engagements];*/
                                                
            system.debug('@@@@@ experienceList: ' + experienceList);
            map<String, list<Experience__c>> map_expByPT = new map<String, list<Experience__c>>();
        
            for(Experience__c e : ExperienceList){
                // Condition 1
                if(e.Experience_Type__c == 'Au Pair'){
                    my_hl.get(e.Engagement__c).add(cond1tag);
                }
                // Condition 6
                else if(e.Experience_Type__c == 'Teaching/Tutoring'){
                    my_hl.get(e.Engagement__c).add(cond6tag);
                }
            }
        
            // Advanced Education
        
            list<Education__c> eduList = [SELECT id, Institution_Type__c, Program_Type__c, Institution_Name__c, Field_of_Study__c, Graduation_Date__c, CreatedDate, Engagement__c, Address_Street_1__c,Address_Street_2__c,Phone__c,Phone_Country_Code__c,Program_Type_Other__c,Study_Level__c,City__c,Country__c,Postal_Code__c,State__c,Certification__c
                                            FROM Education__c 
                                            WHERE Engagement__c IN: engagements];
        
            for(Education__c ed : eduList){
                if(ed.Institution_Type__c == 'University/College'){
                    my_hl.get(ed.Engagement__c).add(cond2tag);
                }
                if(ed.Institution_Type__c == 'Vocational Training'){
                    if(ed.Program_Type__c == 'Nursing'){
                        my_hl.get(ed.Engagement__c).add(cond5atag);
                    }else if(ed.Program_Type__c == 'First Aid'){
                        my_hl.get(ed.Engagement__c).add(cond5btag);
                    }
                }
            }
            
            /* WAITING FOR CONFIRMATION _ MEMBER__c OR PERSON_INFO__c
            //Condition 3 - Older Sibling
            Boolean cond3 = true;
            if(siblingList != null && siblingList.size()>0){
                for(Person_Info__c p:siblingList){
                    if(primary.Date_of_Birth__c > primary.Date_of_Birth__c){
                        cond3 = false;
                        break;
                    }
                }
                if(cond3 == true){
                    listHL.add(cond3tag);
                    system.debug('@@@@@ Meet Condition 3: ' + cond3tag);
                }
            }
            //END condition 3
            */
        
            list<Intrax_Program_Upload__c> lgdocs = [Select d.document_name__c,d.Document_Type__c, d.description__c, d.Keywords__c,d.document_guid__c, Engagement__c from Intrax_Program_Upload__c d
                                                        where d.Engagement__c IN: engagements 
                                                        and d.Document_Type__C IN ('Lifeguard')];
                                                        
            for(Intrax_Program_Upload__c i: lgdocs){
                my_hl.get(i.Engagement__c).add(cond4tag);
            }
       
        /*
            
                
        FIELD NOT DEFINED IN ENGAGEMENT
        //***Condition 12 - Lived Independently
        if(applicant.Lived_Independently__c == 'Yes'){
            listHL.add(cond12tag);  
            system.debug('@@@@@ Meet Condition 11: ' + cond12tag);
        }//END condition 12
        
        FIELD NOT DEFINED IN ENGAGEMENT
        //***Condition 14 - Traveler
        if(applicant.US_Experience_Indicated__c == 'Yes'){
                listHL.add(cond14tag);  
                system.debug('@@@@@ Meet Condition 14: ' + cond14tag);
        }//END condition 14
        
        system.debug('@@@@@ listHL: ' + listHL);
        system.debug('@@@@@ listHL.size(): ' + listHL.size());
        
        if(listHL!=null && listHL.size()>4){
            for(Integer i = 0; i<5;i++){
                listHLAux.add(listHL[i]);
            }
        }else{
            listHLAux = listHL;
        }
        
        
        return listHLAux; 
        */
        
            for(Engagement__c eng : engagements){
                system.debug('**** eng Name: '+ eng.name);
                system.debug('**** hl size: '+ my_hl.get(eng.Id).size());
                integer counter = 1;
                for(string s : my_hl.get(eng.Id)){  
                    if(counter <= 3){                        
                        if(!(new Set<String>(my_hl_final.get(eng.Id))).contains(s)) {
                            my_hl_final.get(eng.Id).add(s);         
                            counter++;  
                        }           
                    }
                }
            }       
        }
        return my_hl_final;
    }
    
    //JOSE B-03139 Display Match Request Deadline messages in HF and PT portals (Match Deadlines - B)
    // This method returns 2 parameters "match request deadline" and "arrival date"
    public static APC_ArrivalDates__c MatchRequestDeadline(){
        
        try{
        
        APC_ArrivalDates__c result = new APC_ArrivalDates__c();
        date dtoday = Date.today();
        Map<String, APC_ArrivalDates__c> mcs = APC_ArrivalDates__c.getAll();
        system.debug('@@@@@mcs: ' + mcs);
        list<Date> datelist = new list<Date>();
        list<APC_ArrivalDates__c> values = mcs.values();
        for(APC_ArrivalDates__c a:values) {
            if(a.Match_Request_Deadline__c >= dtoday ){
                datelist.add(a.Match_Request_Deadline__c);
            }
        }
        datelist.sort();
        
        system.debug('@@@@@datelist: ' + datelist);
        
        if(datelist!= null && datelist.size()>0){
            for(APC_ArrivalDates__c ar:values) {
                if(ar.Match_Request_Deadline__c == datelist[0] ){
                    result = ar;
                    break;
                }
            }
        }
        return result;
        
        }catch(Exception e){
            system.debug('@@@@@ Exception in MatchRequestDeadline(): ' + e);
            return null;
        }
        
        
    }
    
    //JOSE B-02985 AP Completion Certificate create / make available in portal 
    public static PageReference generateAuPairCareCertificate(Id engId, String fname, String lname, Date startDate, Date endDate){
        
        try{
        string responseXML;
        list<Intrax_Program_Upload__c> apcCertificates;
        
        String startDateS = '00/00/0000';
        String endDateS = '00/00/0000';
        
        if(startDate != null){
            startDateS = startDate.format();
        }
        if(endDate != null){
            endDateS = endDate.format();
        }
        
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Dom.Document docRes = new Dom.Document();
        Intrax_Program_Upload__c apcIPU;
        pageReference p;
        
        req.setMethod('POST'); 
        req.setHeader('Accept', 'application/xml');
        req.setHeader('Authorization','Basic '+EncodingUtil.base64Encode(Blob.valueof(Constants.ldapCredentials)));
        req.setEndpoint(Constants.documentService+'CreateAuPairCertificate');
        String body = '';
        
        body = 'authToken='+Constants.serviceAuthToken+'&programId=certificates/APC/AP/APCertificates&';
        body = body+'certificateTemplateGUID=certificates/APC/AP/AP_2015_Certificate.pdf';
        body = body+'&firstName='+fname;
        body = body+'&lastName='+lname;
        body = body+'&startDate='+startDateS;
        body = body+'&endDate='+endDateS;
        body = body+'&dateCompleted='+endDateS;
        system.debug('@@@@@debug::RequestBody: ' + body);
        
        req.setBody(body);
        
        //Retrieving IPU related to Engagment with DOCTYPE Certification
        apcCertificates = [SELECT Id, Document_Guid__c FROM Intrax_Program_Upload__c WHERE Engagement__c = :engId AND Document_Type__c = 'Certificate'];
        String AuPairCertificateGuid = null;
        if(!Test.isRunningTest()){
            if(apcCertificates.size() == 0){
                res = h.send(req);
                responseXML = res.getBody();
                docRes.load(responseXML);
                List<dom.XmlNode> resnodelist = docRes.getRootElement().getChildElements();
            
                system.debug(res.getBody());      
            
                for (dom.XmlNode node : resnodelist){
                    if (node.getName() == 'documentResult'){
                        List<dom.XmlNode> resnodelist1 = node.getChildren();
                        for (dom.XmlNode node1 : resnodelist1){
                            if (node1.getName() == 'result'){
                                
                                AuPairCertificateGuid = node1.getText();
                                RecordType RecType = [Select Id From RecordType  Where SobjectType = 'Intrax_Program_Upload__c' and DeveloperName = 'Engagement'];
                                apcIPU = new Intrax_Program_Upload__c();
                                apcIPU.Name= 'AP 2015 Certificate ' + system.today().format();
                                apcIPU.Document_GUID__c=AuPairCertificateGuid;
                                apcIPU.Printed_Date__c = Date.today();
                                apcIPU.RecordTypeId = RecType.id;
                                apcIPU.Document_Type__c = 'Certificate';
                                apcIPU.Document_Service__c = 'DS';
                                apcIPU.Engagement__c = engId;
                                system.debug('@@@@@Creating apcIPU');
                                //Create IPU related to Engagement
                                insert apcIPU;
                            }
                        }                
                    }
                }
                system.debug('@@@@@ AuPairCertificateGuid: ' + AuPairCertificateGuid);
                p = new pageReference('/apex/DocViewerPortal?docGuid='+AuPairCertificateGuid);
                p.setRedirect(true);
                return p;
            
            }else{
                system.debug('@@@@@ apcIPU exists // redirecting to DocViewerPortal');
                p = new pageReference('/apex/DocViewerPortal?docGuid='+apcCertificates[0].Document_GUID__c);
                p.setRedirect(true);
                return p;
            }        
        }else{
             //do nothing for now
             return null;
        } 
        }catch(Exception e){
            system.debug('@@@@@ Exception in generateAuPairCareCertificate() in apc_portal_utilities.cls: ' + e);
            return null;
        }     
    }
    
    //JOSE B-02827 and B-03142  //APC HF Contact Us page -- retrieving record from APC_Contact_Information__c CUSTOM SETTING
    public static APC_Contact_Information__c InsuranceInfo(){
        try{
            APC_Contact_Information__c apcInsurance = APC_Contact_Information__c.getValues('AP Insurance');
            if(apcInsurance!=null){
                return apcInsurance;
            }else{
                APC_Contact_Information__c apcInsuranceAux = new APC_Contact_Information__c(); 
                return apcInsuranceAux; 
            }
        }catch(Exception e){
            system.debug('@@@@@Exception in InsuranceInfo: ' + e);
            APC_Contact_Information__c apcInsuranceAux = new APC_Contact_Information__c(); 
            return apcInsuranceAux;
        }    
    }
    
    
    //JOSE B-02827 and B-03142  //APC HF Contact Us page -- retrieving record from APC_Contact_Information__c CUSTOM SETTING
    public static APC_Contact_Information__c HQInfo(){
        try{
            APC_Contact_Information__c apcHQInfo = APC_Contact_Information__c.getValues('HQ Address');
            if(apcHQInfo!=null){
                return apcHQInfo;
            }else{
                APC_Contact_Information__c apcHQInfoAux = new APC_Contact_Information__c(); 
                return apcHQInfoAux; 
            }
        }catch(Exception e){
            system.debug('@@@@@Exception in HQInfo: ' + e);
            APC_Contact_Information__c apcHQInfoAux = new APC_Contact_Information__c(); 
            return apcHQInfoAux;
        }    
    }
    
    
    //JOSE B-02827 and B-03142  //APC HF Contact Us page -- retrieving record from APC_Contact_Information__c CUSTOM SETTING
    public static APC_Contact_Information__c EmergencyLine(){
        try{
            APC_Contact_Information__c apcEmergencyLine = APC_Contact_Information__c.getValues('Emergency Line');
            if(apcEmergencyLine != null){
                return  apcEmergencyLine;
            }else{
                APC_Contact_Information__c apcEmergencyLineAux = new APC_Contact_Information__c(); 
                return apcEmergencyLineAux; 
            }
        }catch(Exception e){
            system.debug('@@@@@Exception in EmergencyLine: ' + e);
            APC_Contact_Information__c apcEmergencyLineAux = new APC_Contact_Information__c(); 
            return apcEmergencyLineAux;
        }    
    }
    
    //JOSE B-02827 and B-03142  //APC HF Contact Us page -- retrieving record from APC_Contact_Information__c CUSTOM SETTING
    public static APC_Sales_Assignments__c MatchingExpert(String OwnerADRegion){
        try{
            if(OwnerADRegion != null){
                system.debug('@@@@@OwnerADRegion: ' + OwnerADRegion);
                APC_Sales_Assignments__c apcSales = APC_Sales_Assignments__c.getValues(OwnerADRegion);
                return apcSales;
                
            }else{
               APC_Sales_Assignments__c apcSalesAux = new APC_Sales_Assignments__c(); 
               return apcSalesAux;  
            }
        }catch(Exception e){
            system.debug('@@@@@Exception in apc_portal_utilities.MatchingExpert(Id OwnerAD): ' + e);
            APC_Sales_Assignments__c apcSalesAux = new APC_Sales_Assignments__c(); 
            return apcSalesAux; 
        }    
    }

}