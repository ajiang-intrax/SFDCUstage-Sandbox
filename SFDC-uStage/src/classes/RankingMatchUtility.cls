//Utiltiy methods for Ranking Match
public with sharing class RankingMatchUtility { 
    
    //Static Opportunity Match
    public static Map<Integer, Opportunity> mapOpportunitiesWithIds;
    public static Map<Integer, Position__c> mapPositionsWithIds;
    public static Map<Integer, Engagement__c> mapEngagementWithIds;
    
    //Method for prepare the Entity data
    public static wwwIntraxincComMatchRanking.attributes prepareEntityProps(Position__c position) {
    
        //Set positions attribute
        wwwIntraxincComMatchRanking.attributes entityProps = new wwwIntraxincComMatchRanking.attributes();
        entityProps.Id = 1;
        entityProps.list_x = new List<wwwIntraxincComMatchRanking.attribute>();
        
        //Attribute for Functiona Area
        wwwIntraxincComMatchRanking.attribute attributeFunctionalArea = new wwwIntraxincComMatchRanking.attribute();
        attributeFunctionalArea.id = 11;
        attributeFunctionalArea.key = 'Functional Areas';
        attributeFunctionalArea.value = position.Functional_Areas__c;
        
        //Attribute for Location Of interest
        wwwIntraxincComMatchRanking.attribute attributeLocationOfInterest = new wwwIntraxincComMatchRanking.attribute();
        attributeLocationOfInterest.id = 21;
        attributeLocationOfInterest.key = 'Location of Interest';
        attributeLocationOfInterest.value = position.Regional_Location__c;
    
        //Attribute for Compensation type
        wwwIntraxincComMatchRanking.attribute attributeCompensationType = new wwwIntraxincComMatchRanking.attribute();
        attributeCompensationType.id = 31;
        attributeCompensationType.key = 'Compensation Type';
        attributeCompensationType.value = position.Compensation_Type__c;
    
        //Attribute for Engagement Start
        wwwIntraxincComMatchRanking.attribute attributeEngagementStart = new wwwIntraxincComMatchRanking.attribute();
        attributeEngagementStart.id = 41;
        attributeEngagementStart.key = 'Engagement Start';
        
        //Check if position.Engagement_Start__c is not null
        if(position.Engagement_Start__c != null)
            attributeEngagementStart.value = String.valueOf(position.Engagement_Start__c);
        
        //Attribute for Engagement End
        wwwIntraxincComMatchRanking.attribute attributeEngagementEnd = new wwwIntraxincComMatchRanking.attribute();
        attributeEngagementEnd.id = 51;
        attributeEngagementEnd.key = 'Engagement End';
        
        //Check if position.Engagement_Start__c is not null
        if(position.Engagement_End__c != null)
            attributeEngagementStart.value = String.valueOf(position.Engagement_End__c);
        
        //Attribute for Citizenship
        wwwIntraxincComMatchRanking.attribute attributeCitizenship = new wwwIntraxincComMatchRanking.attribute();
        attributeCitizenship.id = 61;
        attributeCitizenship.key = 'Citizenship';
        attributeCitizenship.value = getISOCodesByCountries(position.Countries_of_Interest__c);
        
        //Attribute for Position Types
        wwwIntraxincComMatchRanking.attribute attributePositionTypes = new wwwIntraxincComMatchRanking.attribute();
        attributePositionTypes.id = 71;
        attributePositionTypes.key = 'Position Types';
        attributePositionTypes.value = position.Position_Types__c;
        
        //Add attributes to entityProps
        entityProps.list_x.add(attributeFunctionalArea);
        entityProps.list_x.add(attributeLocationOfInterest);
        entityProps.list_x.add(attributeCompensationType);
        entityProps.list_x.add(attributeEngagementStart);
        entityProps.list_x.add(attributeEngagementEnd);
        entityProps.list_x.add(attributeCitizenship);
        entityProps.list_x.add(attributePositionTypes);
        
        //Shankar commented out here
        return entityProps;
    }
     //Method for prepare the Entity data
    public static wwwIntraxincComMatchRanking.attributes prepareEntityProps(Engagement__c engagement) {
    
        //Set positions attribute
        wwwIntraxincComMatchRanking.attributes entityProps = new wwwIntraxincComMatchRanking.attributes();
        entityProps.Id = 1;
        entityProps.list_x = new List<wwwIntraxincComMatchRanking.attribute>();
        
        //Attribute for Functiona Area
        wwwIntraxincComMatchRanking.attribute attributeSingleNoChildren = new wwwIntraxincComMatchRanking.attribute();
        attributeSingleNoChildren.id = 11;
        attributeSingleNoChildren.key = 'Single No Children Indicated';
        attributeSingleNoChildren.value = engagement.Single_No_Children_Indicated__c;
        
        //Attribute for Location Of interest
        wwwIntraxincComMatchRanking.attribute attributeLiveWithSmoker = new wwwIntraxincComMatchRanking.attribute();
        attributeLiveWithSmoker.id = 21;
       attributeLiveWithSmoker.key = 'Live with smoker';
        attributeLiveWithSmoker.value = engagement.Live_With_Smoker__c;
    
        //Attribute for Compensation type
        wwwIntraxincComMatchRanking.attribute attributeLiveWithPets = new wwwIntraxincComMatchRanking.attribute();
        attributeLiveWithPets.id = 31;
        attributeLiveWithPets.key = 'Live With Pets';
        attributeLiveWithPets.value = engagement.Live_With_Pets__c;
    
        //Attribute for Engagement Start
        wwwIntraxincComMatchRanking.attribute attributePersonalityInd = new wwwIntraxincComMatchRanking.attribute();
        attributePersonalityInd.id = 41;
        attributePersonalityInd.key = 'Personality Independence';
        attributePersonalityInd.value = engagement.Personality_Independence__c;
        
        //Attribute for Engagement End
        wwwIntraxincComMatchRanking.attribute attributeInterestTop = new wwwIntraxincComMatchRanking.attribute();
        attributeInterestTop.id = 51;
        attributeInterestTop.key = 'Interests Top';
        attributeInterestTop.value = engagement.Interests_Top__c;
        
        //Attribute for Citizenship
        wwwIntraxincComMatchRanking.attribute attributeDoublePlacementInd = new wwwIntraxincComMatchRanking.attribute();
        attributeDoublePlacementInd.id = 61;
        attributeDoublePlacementInd.key = 'Double Placement Indicated';
        attributeDoublePlacementInd.value = engagement.Double_Placement_Indicated__c;
        
        //Attribute for Position Types
        wwwIntraxincComMatchRanking.attribute attributePrivateHighSchoolInd = new wwwIntraxincComMatchRanking.attribute();
        attributePrivateHighSchoolInd.id = 71;
        attributePrivateHighSchoolInd.key = 'Private High School Indicated';
        attributePrivateHighSchoolInd.value = engagement.Private_High_School_Indicated__c;
        
        //Attribute for Position Types
        wwwIntraxincComMatchRanking.attribute attributeEngagementStart = new wwwIntraxincComMatchRanking.attribute();
        attributeEngagementStart.id = 81;
        attributeEngagementStart.key = 'Engagement Start';
        if(engagement.Engagement_Start__c != null)
            attributeEngagementStart.value = String.valueOf(engagement.Engagement_Start__c);       
        
               
        //Add attributes to entityProps
        entityProps.list_x.add(attributeSingleNoChildren);
        entityProps.list_x.add(attributeLiveWithSmoker);
        entityProps.list_x.add(attributeLiveWithPets);
        entityProps.list_x.add(attributePersonalityInd);
        entityProps.list_x.add(attributeInterestTop);
        entityProps.list_x.add(attributeDoublePlacementInd);
        entityProps.list_x.add(attributePrivateHighSchoolInd);
        entityProps.list_x.add(attributeEngagementStart);
        //Shankar commented out here
        return entityProps;
        
    }
     public static wwwIntraxincComMatchRanking.attributes prepareHFPositionProps(Position__c position) {
    
        //Set positions attribute
        wwwIntraxincComMatchRanking.attributes entityProps = new wwwIntraxincComMatchRanking.attributes();
        entityProps.Id = 1;
        entityProps.list_x = new List<wwwIntraxincComMatchRanking.attribute>();
        
        //Attribute for Functiona Area
        wwwIntraxincComMatchRanking.attribute attributeSingleNoChildren = new wwwIntraxincComMatchRanking.attribute();
        attributeSingleNoChildren.id = 11;
        attributeSingleNoChildren.key = 'Single No Children Indicated';
        attributeSingleNoChildren.value = position.Single_No_Children_Indicated__c;
        
        //Attribute for Location Of interest
        wwwIntraxincComMatchRanking.attribute attributeLiveWithSmoker = new wwwIntraxincComMatchRanking.attribute();
        attributeLiveWithSmoker.id = 21;
       attributeLiveWithSmoker.key = 'Live with smoker';
        attributeLiveWithSmoker.value = position.Smoker_in_Family__c;
    
        //Attribute for Compensation type
        wwwIntraxincComMatchRanking.attribute attributeLiveWithPets = new wwwIntraxincComMatchRanking.attribute();
        attributeLiveWithPets.id = 31;
        attributeLiveWithPets.key = 'Live With Pets';
        attributeLiveWithPets.value = position.Pets__c;
    
        //Attribute for Engagement Start
        wwwIntraxincComMatchRanking.attribute attributePersonalityInd = new wwwIntraxincComMatchRanking.attribute();
        attributePersonalityInd.id = 41;
        attributePersonalityInd.key = 'Personality Independence';
        attributePersonalityInd.value = position.Personality_Independence__c;
        
        //Attribute for Engagement End
        wwwIntraxincComMatchRanking.attribute attributeInterestTop = new wwwIntraxincComMatchRanking.attribute();
        attributeInterestTop.id = 51;
        attributeInterestTop.key = 'Interests Top';
        attributeInterestTop.value = position.Interests__c;
        
        //Attribute for Citizenship
        wwwIntraxincComMatchRanking.attribute attributeDoublePlacementInd = new wwwIntraxincComMatchRanking.attribute();
        attributeDoublePlacementInd.id = 61;
        attributeDoublePlacementInd.key = 'Double Placement Indicated';
        attributeDoublePlacementInd.value = position.Double_Placement_Indicated__c;
        
        //Attribute for Position Types
        wwwIntraxincComMatchRanking.attribute attributePrivateHighSchoolInd = new wwwIntraxincComMatchRanking.attribute();
        attributePrivateHighSchoolInd.id = 71;
        attributePrivateHighSchoolInd.key = 'Private High School Indicated';
        attributePrivateHighSchoolInd.value = position.School_Category__c;
        
        //Attribute for Position Types
        wwwIntraxincComMatchRanking.attribute attributeEngagementStart = new wwwIntraxincComMatchRanking.attribute();
        attributeEngagementStart.id = 81;
        attributeEngagementStart.key = 'Engagement Start';
        if(position.Engagement_Start__c != null)
            attributeEngagementStart.value = String.valueOf(position.Engagement_Start__c);       
        
               
        //Add attributes to entityProps
        entityProps.list_x.add(attributeSingleNoChildren);
        entityProps.list_x.add(attributeLiveWithSmoker);
        entityProps.list_x.add(attributeLiveWithPets);
        entityProps.list_x.add(attributePersonalityInd);
        entityProps.list_x.add(attributeInterestTop);
        entityProps.list_x.add(attributeDoublePlacementInd);
        entityProps.list_x.add(attributePrivateHighSchoolInd);
        entityProps.list_x.add(attributeEngagementStart);
        //Shankar commented out here
        return entityProps;
        
    }
    //Method to prepare candidate list
    public static List<wwwIntraxincComMatchRanking.Attributes> prepareCandidateList(List<Opportunity> opportunities) {
        
        //Create a list of attributes to hold the candidate data
        List<wwwIntraxincComMatchRanking.Attributes> candidatePropsList = new List<wwwIntraxincComMatchRanking.Attributes>();
        
        //Default increment counter
        Integer defaultCounter = 91;
        
        //Instantiate map
        mapOpportunitiesWithIds = new Map<Integer, Opportunity>();
        
        //Loop through the opportunities
        for(Opportunity opp : opportunities) {
            
            //Create an instance of dataset
            wwwIntraxincComMatchRanking.Attributes dataset = new wwwIntraxincComMatchRanking.Attributes();
            dataset.Id = 1;
            dataset.list_x = new List<wwwIntraxincComMatchRanking.attribute>();
        
            //Create dataset for Functional Areas
            wwwIntraxincComMatchRanking.Attribute dataFunctionalAreas = new wwwIntraxincComMatchRanking.Attribute(); 
            dataFunctionalAreas.id = defaultCounter;
            dataFunctionalAreas.key = 'Functional Areas';
            dataFunctionalAreas.value = opp.Functional_Areas__c;
            defaultCounter = defaultCounter + 10;
            
            //Put opportunity in map for first time
            mapOpportunitiesWithIds.put(defaultCounter, opp);
            
            //Create dataset for Location Of Interest
            wwwIntraxincComMatchRanking.Attribute dataLocationOfInterest = new wwwIntraxincComMatchRanking.Attribute(); 
            dataLocationOfInterest.id = defaultCounter;
            dataLocationOfInterest.key = 'Location of Interest';
            dataLocationOfInterest.value = opp.Location_of_Interest__c;
            defaultCounter = defaultCounter + 10;
            
            //Create dataset for Compensation Type
            wwwIntraxincComMatchRanking.Attribute dataCompensationType = new wwwIntraxincComMatchRanking.Attribute(); 
            dataCompensationType.id = defaultCounter;
            dataCompensationType.key = 'Compensation Type';
            dataCompensationType.value = opp.Compensation_Type__c;
            defaultCounter = defaultCounter + 10;
            
            //Create dataset for Engagement Start
            wwwIntraxincComMatchRanking.Attribute dataEngagementStart = new wwwIntraxincComMatchRanking.Attribute(); 
            dataEngagementStart.id = defaultCounter;
            dataEngagementStart.key = 'Engagement Start';
            
            //Check if start date is not null
            if(opp.Engagement_Start__c != null)
                dataEngagementStart.value = String.valueOf(opp.Engagement_Start__c);
            defaultCounter = defaultCounter + 10;
            
            //Create dataset for Engagement End
            wwwIntraxincComMatchRanking.Attribute dataEngagementEnd = new wwwIntraxincComMatchRanking.Attribute(); 
            dataEngagementEnd.id = defaultCounter;
            dataEngagementEnd.key = 'Engagement End';
            
            //Check if end date is not null
            if(opp.Engagement_End__c != null)
                dataEngagementEnd.value = String.valueOf(opp.Engagement_End__c);
            defaultCounter = defaultCounter + 10;
            
            //Attribute for Citizenship
            wwwIntraxincComMatchRanking.attribute dataCitizenship = new wwwIntraxincComMatchRanking.attribute();
            dataCitizenship.id = defaultCounter;
            dataCitizenship.key = 'Citizenship';
            dataCitizenship.value = getISOCodesByCountries(opp.Account.Citizenship__pc);
            defaultCounter = defaultCounter + 10;
            
            //Attribute for Position Types
            wwwIntraxincComMatchRanking.attribute attributePositionTypes = new wwwIntraxincComMatchRanking.attribute();
            attributePositionTypes.id = defaultCounter;
            attributePositionTypes.key = 'Position Types';
            attributePositionTypes.value = opp.Position_Types__c;
            defaultCounter = defaultCounter + 10;
            
            //Add in dataset
            dataset.list_x.add(dataFunctionalAreas);
            dataset.list_x.add(dataLocationOfInterest);
            dataset.list_x.add(dataCompensationType);
            dataset.list_x.add(dataEngagementStart);
            dataset.list_x.add(dataEngagementEnd);
            dataset.list_x.add(dataCitizenship);
            dataset.list_x.add(attributePositionTypes);
            
            //Add this dataset in Candidate list
            candidatePropsList.add(dataset);
        }
        
        return candidatePropsList;  
    }
     public static List<wwwIntraxincComMatchRanking.Attributes> prepareCandidateList(List<Engagement__c> engagements) {
        
        //Create a list of attributes to hold the candidate data
        List<wwwIntraxincComMatchRanking.Attributes> candidatePropsList = new List<wwwIntraxincComMatchRanking.Attributes>();
        
        //Default increment counter
        Integer defaultCounter = 91;
        
        //Instantiate map
        mapEngagementWithIds = new Map<Integer, Engagement__c>();
        
        //Loop through the opportunities
        for(Engagement__c eng : engagements) {
            
            //Create an instance of dataset
            wwwIntraxincComMatchRanking.Attributes dataset = new wwwIntraxincComMatchRanking.Attributes();
            dataset.Id = 1;
            dataset.list_x = new List<wwwIntraxincComMatchRanking.attribute>();
        
            //Create dataset for Functional Areas
            wwwIntraxincComMatchRanking.Attribute dataFunctionalAreas = new wwwIntraxincComMatchRanking.Attribute(); 
            dataFunctionalAreas.id = defaultCounter;
            dataFunctionalAreas.key = 'Functional Areas';
            dataFunctionalAreas.value = eng.Functional_Areas__c;
            defaultCounter = defaultCounter + 10;
            
            //Put opportunity in map for first time
            mapEngagementWithIds.put(defaultCounter, eng);
            
            //Create dataset for Location Of Interest
            wwwIntraxincComMatchRanking.Attribute dataLocationOfInterest = new wwwIntraxincComMatchRanking.Attribute(); 
            dataLocationOfInterest.id = defaultCounter;
            dataLocationOfInterest.key = 'Location of Interest';
            dataLocationOfInterest.value = eng.Location_of_Interest__c;
            defaultCounter = defaultCounter + 10;
            
            //Create dataset for Compensation Type
            wwwIntraxincComMatchRanking.Attribute dataCompensationType = new wwwIntraxincComMatchRanking.Attribute(); 
            dataCompensationType.id = defaultCounter;
            dataCompensationType.key = 'Compensation Type';
            dataCompensationType.value = eng.Compensation_Type__c;
            defaultCounter = defaultCounter + 10;
            
            //Create dataset for Engagement Start
            wwwIntraxincComMatchRanking.Attribute dataEngagementStart = new wwwIntraxincComMatchRanking.Attribute(); 
            dataEngagementStart.id = defaultCounter;
            dataEngagementStart.key = 'Engagement Start';
            
            //Check if start date is not null
            if(eng.Engagement_Start__c != null)
                dataEngagementStart.value = String.valueOf(eng.Engagement_Start__c);
            defaultCounter = defaultCounter + 10;
            
            //Create dataset for Engagement End
            wwwIntraxincComMatchRanking.Attribute dataEngagementEnd = new wwwIntraxincComMatchRanking.Attribute(); 
            dataEngagementEnd.id = defaultCounter;
            dataEngagementEnd.key = 'Engagement End';
            
            //Check if end date is not null
            if(eng.Engagement_End__c != null)
                dataEngagementEnd.value = String.valueOf(eng.Engagement_End__c);
            defaultCounter = defaultCounter + 10;
            
            //Attribute for Citizenship
            wwwIntraxincComMatchRanking.attribute dataCitizenship = new wwwIntraxincComMatchRanking.attribute();
            dataCitizenship.id = defaultCounter;
            dataCitizenship.key = 'Citizenship';
            dataCitizenship.value = getISOCodesByCountries(eng.Account_Id__r.Citizenship__pc);
            defaultCounter = defaultCounter + 10;
            
            //Attribute for Position Types
            wwwIntraxincComMatchRanking.attribute attributePositionTypes = new wwwIntraxincComMatchRanking.attribute();
            attributePositionTypes.id = defaultCounter;
            attributePositionTypes.key = 'Position Types';
            attributePositionTypes.value = eng.Position_Types__c;
            defaultCounter = defaultCounter + 10;
            
            //Add in dataset
            dataset.list_x.add(dataFunctionalAreas);
            dataset.list_x.add(dataLocationOfInterest);
            dataset.list_x.add(dataCompensationType);
            dataset.list_x.add(dataEngagementStart);
            dataset.list_x.add(dataEngagementEnd);
            dataset.list_x.add(dataCitizenship);
            dataset.list_x.add(attributePositionTypes);
            
            //Add this dataset in Candidate list
            candidatePropsList.add(dataset);
        }
        
        return candidatePropsList;  
    }
    
      //Method to prepare candidate list
    public static List<wwwIntraxincComMatchRanking.Attributes> prepareEngagementList(List<Engagement__c> engagements) {
        
        //Create a list of attributes to hold the candidate data
        List<wwwIntraxincComMatchRanking.Attributes> engPropsList = new List<wwwIntraxincComMatchRanking.Attributes>();
        
        //Default increment counter
        Integer defaultCounter = 91;
        
        //Instantiate map
        mapEngagementWithIds = new Map<Integer, Engagement__c>();
        
        //Loop through the opportunities
        for(Engagement__c eng : engagements) {
            
            //Create an instance of dataset
            wwwIntraxincComMatchRanking.Attributes dataset = new wwwIntraxincComMatchRanking.Attributes();
            dataset.Id = 1;
            dataset.list_x = new List<wwwIntraxincComMatchRanking.attribute>();
        
            //Create dataset for Functional Areas
            wwwIntraxincComMatchRanking.Attribute dataSingleNoChildren = new wwwIntraxincComMatchRanking.Attribute(); 
            dataSingleNoChildren.id = defaultCounter;
            dataSingleNoChildren.key = 'Single No Children Indicated';
            dataSingleNoChildren.value = eng.Single_No_Children_Indicated__c;
            defaultCounter = defaultCounter + 10;
            
            //Put opportunity in map for first time
            mapEngagementWithIds.put(defaultCounter, eng);
            
            //Create dataset for Location Of Interest
            wwwIntraxincComMatchRanking.Attribute dataLiveWithSmoker = new wwwIntraxincComMatchRanking.Attribute(); 
            dataLiveWithSmoker.id = defaultCounter;
            dataLiveWithSmoker.key = 'Live with smoker';
            dataLiveWithSmoker.value = eng.Live_With_Smoker__c;
            defaultCounter = defaultCounter + 10;
            
            //Create dataset for Compensation Type
            wwwIntraxincComMatchRanking.Attribute dataLiveWithPets = new wwwIntraxincComMatchRanking.Attribute(); 
            dataLiveWithPets.id = defaultCounter;
            dataLiveWithPets.key = 'Live With Pets';
            dataLiveWithPets.value = eng.Live_With_Pets__c;
            defaultCounter = defaultCounter + 10;
            
            //Create dataset for Engagement Start
            wwwIntraxincComMatchRanking.Attribute dataPersonalityInd = new wwwIntraxincComMatchRanking.Attribute(); 
            dataPersonalityInd.id = defaultCounter;
            dataPersonalityInd.key = 'Personality Independence';            
            dataPersonalityInd.value = eng.Personality_Independence__c;
            defaultCounter = defaultCounter + 10;
            
            //Create dataset for Engagement End
            wwwIntraxincComMatchRanking.Attribute dataInterestTop = new wwwIntraxincComMatchRanking.Attribute(); 
            dataInterestTop.id = defaultCounter;
            dataInterestTop.key = 'Interests Top';
            dataInterestTop.value = eng.Interests_Top__c;
            defaultCounter = defaultCounter + 10;
            
            //Attribute for Citizenship
            wwwIntraxincComMatchRanking.attribute dataDoublePlacementInd  = new wwwIntraxincComMatchRanking.attribute();
            dataDoublePlacementInd.id = defaultCounter;
            dataDoublePlacementInd.key = 'Double Placement Indicated';
            dataDoublePlacementInd.value = eng.Double_Placement_Indicated__c;
            defaultCounter = defaultCounter + 10;
            
            //Attribute for Position Types
            wwwIntraxincComMatchRanking.attribute dataPrivateHighSchoolInd = new wwwIntraxincComMatchRanking.attribute();
            dataPrivateHighSchoolInd.id = defaultCounter;
            dataPrivateHighSchoolInd.key = 'Private High School Indicated';
            dataPrivateHighSchoolInd.value = eng.Private_High_School_Indicated__c;
            defaultCounter = defaultCounter + 10;
            
            wwwIntraxincComMatchRanking.attribute dataEngagementStart = new wwwIntraxincComMatchRanking.attribute();
            dataEngagementStart.id = defaultCounter;
            dataEngagementStart.key = 'Engagement Start';
            if(eng.Engagement_Start__c != null)
              dataEngagementStart.value = String.valueOf(eng.Engagement_Start__c);       
        
            
            //Add in dataset
            dataset.list_x.add(dataSingleNoChildren);
            dataset.list_x.add(dataLiveWithSmoker);
            dataset.list_x.add(dataLiveWithPets);
            dataset.list_x.add(dataPersonalityInd);
            dataset.list_x.add(dataInterestTop);
            dataset.list_x.add(dataDoublePlacementInd);
            dataset.list_x.add(dataPrivateHighSchoolInd);
            dataset.list_x.add(dataEngagementStart);
            
            //Add this dataset in Candidate list
            engPropsList.add(dataset);
        }
        
        return engPropsList;  
    }
    
    
    //Method to parse webservice response and Create the result
    public static Map<Integer, List<OpportunityWrapper>> parseResponse(wwwIntraxincComMatchRanking.resultSet resultSet) {
        
        //Instantiate a list of OpportunityWrapper
        Map<Integer, List<OpportunityWrapper>> mapOfListOppotunityWrapper = new Map<Integer, List<OpportunityWrapper>>();
        
        System.debug('mapOpportunitiesWithIds:::::' + mapOpportunitiesWithIds);
        
        //Loop through the results
        for(wwwIntraxincComMatchRanking.result res : resultSet.list_x) {
                
            //Loop through the result set
            for(wwwIntraxincComMatchRanking.attribute att : res.attributes) {
                
                //Attribute Id
                Integer attId = Integer.valueOf(att.id);
                System.debug('attId:::::' + attId + ':::::res.similiarity:::::' + res.similiarity + ':::::res.rank:::::' + res.rank);
        
                //Check if this Id is in Map
                if(mapOpportunitiesWithIds.containsKey(attId)) {
                    
                    //check if opporunity with similar rank then add it in list
                    if(mapOfListOppotunityWrapper.containsKey(res.rank)) {
                        mapOfListOppotunityWrapper.get(res.rank).add(new OpportunityWrapper(mapOpportunitiesWithIds.get(attId), 
                                                                                                res.similiarity, res.rank));
                    } else {
                        mapOfListOppotunityWrapper.put(res.rank, new List<OpportunityWrapper>{new OpportunityWrapper(mapOpportunitiesWithIds.get(attId), 
                                                                                                                        res.similiarity, res.rank)});           
                    }
                }
            }
        }
        
        //returning results
        return mapOfListOppotunityWrapper;
    }
    
    //Method for prepare the Entity data
    public static wwwIntraxincComMatchRanking.attributes prepareEntityProps(Opportunity opprotunityObj) {
    
        //Set positions attribute
        wwwIntraxincComMatchRanking.attributes entityProps = new wwwIntraxincComMatchRanking.attributes();
        entityProps.Id = 1;
        entityProps.list_x = new List<wwwIntraxincComMatchRanking.attribute>();
        
        //Attribute for Functiona Area
        wwwIntraxincComMatchRanking.attribute attributeFunctionalArea = new wwwIntraxincComMatchRanking.attribute();
        attributeFunctionalArea.id = 11;
        attributeFunctionalArea.key = 'Functional Areas';
        attributeFunctionalArea.value = opprotunityObj.Functional_Areas__c;
        
        //Attribute for Location Of interest
        wwwIntraxincComMatchRanking.attribute attributeLocationOfInterest = new wwwIntraxincComMatchRanking.attribute();
        attributeLocationOfInterest.id = 21;
        attributeLocationOfInterest.key = 'Location of Interest';
        attributeLocationOfInterest.value = opprotunityObj.Location_of_Interest__c;
    
        //Attribute for Compensation type
        wwwIntraxincComMatchRanking.attribute attributeCompensationType = new wwwIntraxincComMatchRanking.attribute();
        attributeCompensationType.id = 31;
        attributeCompensationType.key = 'Compensation Type';
        attributeCompensationType.value = opprotunityObj.Compensation_Type__c;
    
        //Attribute for Engagement Start
        wwwIntraxincComMatchRanking.attribute attributeEngagementStart = new wwwIntraxincComMatchRanking.attribute();
        attributeEngagementStart.id = 41;
        attributeEngagementStart.key = 'Engagement Start';
        
        //Check if position.Engagement_Start__c is not null
        if(opprotunityObj.Engagement_Start__c != null)
            attributeEngagementStart.value = String.valueOf(opprotunityObj.Engagement_Start__c);
        
        //Attribute for Engagement End
        wwwIntraxincComMatchRanking.attribute attributeEngagementEnd = new wwwIntraxincComMatchRanking.attribute();
        attributeEngagementEnd.id = 51;
        attributeEngagementEnd.key = 'Engagement End';
        
        //Check if position.Engagement_Start__c is not null
        if(opprotunityObj.Engagement_End__c != null)
            attributeEngagementStart.value = String.valueOf(opprotunityObj.Engagement_End__c);
        
        //Attribute for Citizenship
        wwwIntraxincComMatchRanking.attribute attributeCitizenship = new wwwIntraxincComMatchRanking.attribute();
        attributeCitizenship.id = 61;
        attributeCitizenship.key = 'Citizenship';
        attributeCitizenship.value = getISOCodesByCountries(opprotunityObj.Account.Citizenship__pc);
        
        //Attribute for Position Types
        wwwIntraxincComMatchRanking.attribute attributePositionTypes = new wwwIntraxincComMatchRanking.attribute();
        attributePositionTypes.id = 71;
        attributePositionTypes.key = 'Position Types';
        attributePositionTypes.value = opprotunityObj.Position_Types__c;
        
        //Add attributes to entityProps
        entityProps.list_x.add(attributeFunctionalArea);
        entityProps.list_x.add(attributeLocationOfInterest);
        entityProps.list_x.add(attributeCompensationType);
        entityProps.list_x.add(attributeEngagementStart);
        entityProps.list_x.add(attributeEngagementEnd);
        entityProps.list_x.add(attributeCitizenship);
        entityProps.list_x.add(attributePositionTypes);
        
        //return entityProps
        return entityProps;
    }
    
    //Method to prepare positions list
    public static List<wwwIntraxincComMatchRanking.Attributes> preparePositionList(List<Position__c> positions) {
        
        //Create a list of attributes to hold the candidate data
        List<wwwIntraxincComMatchRanking.Attributes> positionPropsList = new List<wwwIntraxincComMatchRanking.Attributes>();
        
        //Default increment counter
        Integer defaultCounter = 81;
        
        //Instantiate map
        mapPositionsWithIds = new Map<Integer, Position__c>();
        
        //Loop through the opportunities
        for(Position__c pos : positions) {
            
            //Create an instance of dataset
            wwwIntraxincComMatchRanking.Attributes dataset = new wwwIntraxincComMatchRanking.Attributes();
            dataset.Id = 1;
            dataset.list_x = new List<wwwIntraxincComMatchRanking.attribute>();
        
            //Create dataset for Functional Areas
            wwwIntraxincComMatchRanking.Attribute dataFunctionalAreas = new wwwIntraxincComMatchRanking.Attribute(); 
            dataFunctionalAreas.id = defaultCounter;
            dataFunctionalAreas.key = 'Functional Areas';
            dataFunctionalAreas.value = pos.Functional_Areas__c;
            defaultCounter = defaultCounter + 10;
            
            //Put opportunity in map for first time
            mapPositionsWithIds.put(defaultCounter, pos);
            
            //Create dataset for Location Of Interest
            wwwIntraxincComMatchRanking.Attribute dataLocationOfInterest = new wwwIntraxincComMatchRanking.Attribute(); 
            dataLocationOfInterest.id = defaultCounter;
            dataLocationOfInterest.key = 'Location of Interest';
            dataLocationOfInterest.value = pos.Regional_Location__c;
            defaultCounter = defaultCounter + 10;
            
            //Create dataset for Compensation Type
            wwwIntraxincComMatchRanking.Attribute dataCompensationType = new wwwIntraxincComMatchRanking.Attribute(); 
            dataCompensationType.id = defaultCounter;
            dataCompensationType.key = 'Compensation Type';
            dataCompensationType.value = pos.Compensation_Type__c;
            defaultCounter = defaultCounter + 10;
            
            //Create dataset for Engagement Start
            wwwIntraxincComMatchRanking.Attribute dataEngagementStart = new wwwIntraxincComMatchRanking.Attribute(); 
            dataEngagementStart.id = defaultCounter;
            dataEngagementStart.key = 'Engagement Start';
            
            //Check if start date is not null
            if(pos.Engagement_Start__c != null)
                dataEngagementStart.value = String.valueOf(pos.Engagement_Start__c);
            defaultCounter = defaultCounter + 10;
            
            //Create dataset for Engagement End
            wwwIntraxincComMatchRanking.Attribute dataEngagementEnd = new wwwIntraxincComMatchRanking.Attribute(); 
            dataEngagementEnd.id = defaultCounter;
            dataEngagementEnd.key = 'Engagement End';
            
            //Check if end date is not null
            if(pos.Engagement_End__c != null)
                dataEngagementEnd.value = String.valueOf(pos.Engagement_End__c);
            defaultCounter = defaultCounter + 10;
            
            //Attribute for Citizenship
            wwwIntraxincComMatchRanking.attribute dataCitizenship = new wwwIntraxincComMatchRanking.attribute();
            dataCitizenship.id = 61;
            dataCitizenship.key = 'Citizenship';
            dataCitizenship.value = getISOCodesByCountries(pos.Countries_of_Interest__c);
        
            //Attribute for Position Types
            wwwIntraxincComMatchRanking.attribute dataPositionTypes = new wwwIntraxincComMatchRanking.attribute();
            dataPositionTypes.id = defaultCounter;
            dataPositionTypes.key = 'Position Types';
            dataPositionTypes.value = pos.Position_Types__c;
            defaultCounter = defaultCounter + 10;
            
            //Add in dataset
            dataset.list_x.add(dataFunctionalAreas);
            dataset.list_x.add(dataLocationOfInterest);
            dataset.list_x.add(dataCompensationType);
            dataset.list_x.add(dataEngagementStart);
            dataset.list_x.add(dataEngagementEnd);
            dataset.list_x.add(dataCitizenship);
            dataset.list_x.add(dataPositionTypes);
            
            //Add this dataset in Candidate list
            positionPropsList.add(dataset);
        }
        
        return positionPropsList;
          
    }
    
    //Method to parse webservice response and Create the result
    public static Map<Integer, List<PositionWrapper>> parseResponseForPositions(wwwIntraxincComMatchRanking.resultSet resultSet) {
        
        //Instantiate a list of OpportunityWrapper
        Map<Integer, List<PositionWrapper>> mapOfListPositionWrapper = new Map<Integer, List<PositionWrapper>>();
        
        System.debug('mapPositionsWithIds:::::' + mapPositionsWithIds);
        
        //Loop through the results
        for(wwwIntraxincComMatchRanking.result res : resultSet.list_x) {
                
            //Loop through the result set
            for(wwwIntraxincComMatchRanking.attribute att : res.attributes) {
                
                //Attribute Id
                Integer attId = Integer.valueOf(att.id);
                System.debug('attId:::::' + attId + ':::::res.similiarity:::::' + res.similiarity + ':::::res.rank:::::' + res.rank);
        
                //Check if this Id is in Map
                if(mapPositionsWithIds.containsKey(attId)) {
                    
                    //check if opporunity with similar rank then add it in list
                    if(mapOfListPositionWrapper.containsKey(res.rank)) {
                        mapOfListPositionWrapper.get(res.rank).add(new PositionWrapper(mapPositionsWithIds.get(attId), 
                                                                                                res.similiarity, res.rank));
                    } else {
                        mapOfListPositionWrapper.put(res.rank, new List<PositionWrapper>{new PositionWrapper(mapPositionsWithIds.get(attId), 
                                                                                                                        res.similiarity, res.rank)});           
                    }
                }
            }
        }
        
        //returning results
        return mapOfListPositionWrapper;
    }
      //Method to parse webservice response and Create the result
    public static Map<Integer, List<EngagementWrapper>> parseResponseForEng(wwwIntraxincComMatchRanking.resultSet resultSet) {
        
        //Instantiate a list of OpportunityWrapper
        Map<Integer, List<EngagementWrapper>> mapOfListEngagementWrapper = new Map<Integer, List<EngagementWrapper>>();
        
        System.debug('mapEngagementWithIds:::::' + mapEngagementWithIds);
        System.debug('resultSet:::::' + resultSet);
        //Loop through the results
        for(wwwIntraxincComMatchRanking.result res : resultSet.list_x) {
                
            //Loop through the result set
            for(wwwIntraxincComMatchRanking.attribute att : res.attributes) {
                
                //Attribute Id
                Integer attId = Integer.valueOf(att.id);
                System.debug('attId:::::' + attId + ':::::res.similiarity:::::' + res.similiarity + ':::::res.rank:::::' + res.rank);
        
                //Check if this Id is in Map
                if(mapEngagementWithIds.containsKey(attId)) {
                    
                    //check if opporunity with similar rank then add it in list
                    if(mapOfListEngagementWrapper.containsKey(res.rank)) {
                        mapOfListEngagementWrapper.get(res.rank).add(new EngagementWrapper(mapEngagementWithIds.get(attId), 
                                                                                                res.similiarity, res.rank));
                    } else {
                        mapOfListEngagementWrapper.put(res.rank, new List<EngagementWrapper>{new EngagementWrapper(mapEngagementWithIds.get(attId), 
                                                                                                                        res.similiarity, res.rank)});           
                    }
                }
            }
        }
        
        //returning results
        return mapOfListEngagementWrapper;
    }
    //Method to return the 2 character ISO code for seleted countries
    private static String getISOCodesByCountries(String countries) {
        
        String countriesISOCodes;
        
        //Check if it's a non hull value
        if(countries != null) {
            
            //split by semicolon(;)
            List<String> listCountries = countries.split(';');
            
            //loop through the countries
            for(String country : listCountries) {
                
                //Check if country has data tio check
                if(country != null && country != '') {
                    
                    //Convert into lowercase for map 
                    country = country.toLowerCase();
                
                    if(Constants.MAP_COUNTRY_WITH_ISO_CODE.containsKey(country)) {
                        
                        //Add ISO code
                        if(countriesISOCodes == null || countriesISOCodes == '')
                            countriesISOCodes = Constants.MAP_COUNTRY_WITH_ISO_CODE.get(country);
                        else
                            countriesISOCodes += ';' + Constants.MAP_COUNTRY_WITH_ISO_CODE.get(country);
                    }
                }
            }
        }
        
        return countriesISOCodes;
    }
}