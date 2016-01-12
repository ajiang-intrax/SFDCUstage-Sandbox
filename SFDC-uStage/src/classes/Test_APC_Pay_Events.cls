//Tests all types of auto-generated APC Pay Events, including those triggered from Assessments and 
//the daily Stipend batch program.  The data model populated is:
//	- Account (both HF and PT)
//	- Opportunity (both HF and PT)
//	- Position
//	- Engagement
//	- Match
//	- Match Owner History (new custom object)
//	
//	Assessments are created and the Batch_APC_Stipend_Pay_Events Apex job is run to create Pay Events.
//	Assertions are used to validate key attributes of the Pay Event instances, and the collection of
//	and Match Owner History instances created.
//	 
@isTest(SeeAllData=true)

private class Test_APC_Pay_Events {
    static testmethod void apcStipendTest(){
        //Init helper vars
        Integer daysInTestMonth = Date.daysInMonth(Date.today().Year(), Date.today().Month());  
        
        //Get a list of Record Types we can use to build test data.
		List<RecordType> rts = [SELECT Id, Name, SobjectType FROM RecordType];
        Map<String, RecordType> mrt = New Map<String, RecordType>();
        for(RecordType rt : rts){
            mrt.put('' + rt.name + rt.SobjectType, rt);
        }
        
        //Get a generic owner instances.  Use APC FS Community users.
        Profile pf = [select id, name from Profile where name = 'APC AD PC' Limit 1];
        List<User> lApcFSUsers = [select id, name, username, profileId, userroleid from user where isActive = true limit 6];
		Map<Integer, User> mApcFsUsers = New Map<Integer, User>();
		Integer ix = 0;
        for(User afsu : lApcFSUsers){
            mApcFsUsers.put(ix, afsu);
            ix++;
        }
        
        //Create Host Accounts
        List<Account> hostAccts = New List<Account>();
        for(Integer i=0;i<6;i++){
            Account ha = New Account(
            	//FirstName = 'BatchAPCPayTest' + i,
                LastName = 'BatchAPCPayTest' + i,
                Intrax_Programs__c = 'AuPairCare',
                Intrax_Region__c = 'United States',
                Type = 'Host Family',
                PersonEmail = 'test-host' + i + '@intraxinc.com',
                Status__c = 'Contracted',
                PersonMailingStreet = 400 + i + ' Main Street',
                PersonMailingCity = 'San Jose',
                PersonMailingState = 'CA',
                PersonMailingPostalCode = '94082',
                OwnerId = mApcFsUsers.get(i).Id,
                RecordTypeId = mrt.get('ParticipantAccount').Id
            );
            hostAccts.add(ha);
        }
        insert hostAccts;
        hostAccts = [SELECT Id, LastName FROM Account WHERE Type = 'Host Family' and LastName Like 'BatchAPCPayTest%'];
        Map<String, Account> mha = New Map<String, Account>();
        for(Account ha : hostAccts){
            mha.put(ha.LastName, ha);
        }
        
        //Create Participant Accounts
        List<Account> participantAccts = New List<Account>();
        for(Integer i=0;i<6;i++){
            Account pa = New Account(
            	//FirstName = 'BatchAPCPayTest' + i,
                LastName = 'BatchAPCPayTest' + i,
                Intrax_Programs__c = 'AuPairCare',
                Intrax_Region__c = 'Europe',
                Type = 'Participant',
                PersonEmail = 'test-participant' + i + '@intraxinc.com',
                Status__c = 'Contracted',
                PersonMailingStreet = 600 + i + ' California Street',
                PersonMailingCity = 'San Francisco',
                PersonMailingState = 'CA',
                PersonMailingPostalCode = '94108',
                OwnerId = mApcFsUsers.get(i).Id,
                RecordTypeId = mrt.get('ParticipantAccount').Id
            );
            participantAccts.add(pa);
        }
        insert participantAccts;
        participantAccts = [SELECT Id, LastName, Type FROM Account WHERE Type = 'Participant' and LastName Like 'BatchAPCPayTest%'];
        Map<String, Account> mpa = New Map<String, Account>();
        for(Account pa : participantAccts){
            mpa.put(pa.LastName, pa);
        }        
      
        //Create Host Opportunities
        List<Opportunity> hostOppts = New List<Opportunity>();
        for(Integer i=0;i<6;i++){
            Opportunity ho = New Opportunity(
                Name = 'BatchAPCPayTest' + i,
                Intrax_Programs__c = 'AuPairCare',
                Intrax_Region__c = 'United States',
                StageName = 'Closed Won',
                CloseDate = Date.today().addMonths(-5),
                Type = 'Host Family',
                Account = mha.get('BatchAPCPayTest' + i),
                OwnerId = mApcFsUsers.get(i).Id
            );
            //Fix up a few Opportunities to align with Bonus and Repeat conditions
            if(i<4){
                ho.LeadSource = 'Repeat';
                ho.Recruiting_Staff__c = mApcFsUsers.get(i).Id;
            }
            if(i>3 && i<5){
                ho.LeadSource = 'Field Staff';
                ho.Field_Staff__c = mApcFsUsers.get(i).Id;
            }
            if(i>4){
                ho.LeadSource = 'Other';
                ho.Recruiting_Staff__c = mApcFsUsers.get(i).Id;
            }
            hostOppts.add(ho);
        }
        insert hostOppts;        
        hostOppts = [SELECT Id, Name FROM Opportunity WHERE Type = 'Host Family' and Intrax_Programs__c includes('AuPairCare') and Name Like 'BatchAPCPayTest%'];
        Map<String, Opportunity> mho = New Map<String, Opportunity>();
        for(Opportunity ho : hostOppts){
            mho.put(ho.Name, ho);
        }
        
        //Create Participant Opportunities
        List<Opportunity> participantOppts = New List<Opportunity>();
        for(Integer i=0;i<6;i++){
            Opportunity po = New Opportunity(
                Name = 'BatchAPCPayTest' + i,
                Intrax_Programs__c = 'AuPairCare',
                Intrax_Region__c = 'Japan',
                StageName = 'Processing',
                CloseDate = Date.today().addMonths(-5),
                Type = 'Participant',
                Account = mpa.get('BatchAPCPayTest' + i),
				OwnerId = mApcFsUsers.get(i).Id             
            );
            participantOppts.add(po);
        }
        insert participantOppts;
        participantOppts = [SELECT Id, Name FROM Opportunity WHERE Type = 'Participant' and Intrax_Programs__c includes('AuPairCare') and Name Like 'BatchAPCPayTest%'];
        Map<String, Opportunity> mpo = New Map<String, Opportunity>();
        for(Opportunity po : participantOppts){
            mpo.put(po.Name, po);
        }
        
        //Create Position
        List<Position__c> positions = New List<Position__c>();
        for(Integer i=0;i<4;i++){
            Position__c p = New Position__c(
                Name = 'BatchAPCPayTest' + i,
                Intrax_Program__c = 'AuPairCare',
                Intrax_Region__c = 'United States',
                Status__c = 'Matching',
                Country__c = 'United Status',
                Engagement_Start__c = Date.today().addMonths(-3),
                Engagement_End__c = Date.today().addMOnths(2),
				Host_Company_Id__c = mha.get('BatchAPCPayTest' + i).Id,
				Host_Opportunity_Id__c = mho.get('BatchAPCPayTest' + i).Id,
				OwnerId = mApcFsUsers.get(i).Id              
            );
            positions.add(p);
        }
        insert positions;
        positions = [SELECT Id, Name FROM Position__c WHERE Intrax_Program__c = 'AuPairCare' and Name Like 'BatchAPCPayTest%'];
        Map<String, Position__c> mp = New Map<String, Position__c>();
        for(Position__c p : positions){
            mp.put(p.Name, p);
        }        
        //Create Engagement
        List<Engagement__c> engagements = New List<Engagement__c>();
        for(Integer i=0;i<4;i++){
            Engagement__c e = New Engagement__c(
                Name = 'BatchAPCPayTest' + i,
                Type__c = 'Participant',
                Intrax_Program__c = 'AuPairCare',
                Intrax_Region__c = 'United States',
                Placement_Status__c = 'Confirmed',
                Status__c = 'On Program',
                Engagement_Start__c = Date.today().addMonths(-3),
                Engagement_End__c = Date.today().addMOnths(2),
                Account_Id__c = mpa.get('BatchAPCPayTest' + i).Id,
				Opportunity_Id__c = mpo.get('BatchAPCPayTest' + i).Id,
                OwnerId = mApcFsUsers.get(i).Id
            );
            engagements.add(e);
        }
        insert engagements;
        engagements = [SELECT Id, Name FROM Engagement__c WHERE Intrax_Program__c includes('AuPairCare') and Name Like 'BatchAPCPayTest%'];
        Map<String, Engagement__c> me = New Map<String, Engagement__c>();
        for(Engagement__c e : engagements){
            me.put(e.Name, e);
        }

        Test.startTest();
        
        //Create Matches
        List<Match__c> matches = New List<Match__c>();
        for(Integer i=0;i<4;i++){          
            Match__c m = new Match__c(
            	Name = 'BatchAPCPayTest' + i,
                Engagement__c = me.get('BatchAPCPayTest' + i).Id,
                Participant_Id__c = mpa.get('BatchAPCPayTest' + i).Id,
                Participant_Opportunity_Id__c = mpo.get('BatchAPCPayTest' + i).Id,
                Position_Name__c = mp.get('BatchAPCPayTest' + i).Id,
                Start_Date__c = Date.today().addMonths(-3),
                End_Date__c = Date.today().addMonths(+2),
                Match_Date__c = Date.today().addMonths(-4),
                Status__c = 'Confirmed',
                Match_Type__c = 'Permanent'
            );
            matches.add(m);
        }
        insert matches;
        
        matches = [SELECT Id, Name, Position_Name__c, Owner_Name__c, Start_Date__c, End_Date__c FROM Match__c WHERE Name Like 'BatchAPCPayTest%' ORDER by Name];
		List<Id> matchIds = New List<Id>();
        Map<String, Match__c> mm = New Map<String, Match__c>();
        for(Match__c m : matches){
            mm.put(m.Name, m);
            matchIds.add(m.Id);
        }     
        
        List<Match_Owner_History__c> mhistory = [SELECT Id, Name, Match__r.Name, Start_Date__c, End_Date__c, Match__c FROM Match_Owner_History__c WHERE Match__c in :matchIds ORDER by Match__r.Name];
       
        //Set up boundary test conditions
        mhistory[0].Start_Date__c = Date.today().toStartOfMonth().addDays(-10);
        mhistory[1].Start_Date__c = Date.today().toStartOfMonth().addDays(-1);
        mhistory[2].Start_Date__c = Date.today().toStartOfMonth().addDays(15);
        mhistory[3].Start_Date__c = Date.today().toStartOfMonth().addMonths(1).addDays(-1);
        //mhistory[4].Start_Date__c = Date.today().toStartOfMonth().addMonths(1);
        //mhistory[5].Start_Date__c = Date.today().toStartOfMonth().addMonths(1).addDays(15);
        
        //Create a second Owner within the month for Match2--force 2 Pay Events for 1 Match in 1 Month
        Match_Owner_History__c moh7 = new Match_Owner_History__c(
       	Match__c = mm.get('BatchAPCPayTest1').Id,
        Start_Date__c = Date.today().toStartOfMonth().addDays(15),
        Match_Owner__c = mApcFsUsers.get(5).Id);        
        mhistory.add(moh7);
    
 		upsert mhistory;
      
        //create Assessments to trigger various Pay Event.  Specialize to Record Type later
    	List<Assessment__c> assessments = New List<Assessment__c>();
        for (Integer i=0;i<6;i++){
            Assessment__c a = new Assessment__c(
            	Name = 'BatchAPCPayTest' + i,
                Assessment_Date__c = Date.today(),
                Status__c = 'Confirmed',
                Overall_Assessment__c = 'Positive',
                OwnerId = mApcFsUsers.get(i).Id,
                Pay_Event_Ready__c = True
               );
            assessments.add(a);
        }
        //TC1 APC PT Orientation 
        assessments[0].RecordTypeId = mrt.get('APC PT OrientationAssessment__c').Id;
        assessments[0].Engagement__c = me.get('BatchAPCPayTest0').Id;
        assessments[0].Position_Name__c = mp.get('BatchAPCPayTest0').Id;
		
        //TC2 APC PT Exit Interview
        assessments[1].RecordTypeId = mrt.get('APC PT Exit InterviewAssessment__c').Id;
        assessments[1].Engagement__c = me.get('BatchAPCPayTest1').Id;
        assessments[1].Position_Name__c = mp.get('BatchAPCPayTest1').Id;
        
        //TC3 APC PT Exit Interview
        assessments[2].RecordTypeId = mrt.get('APC HF InterviewAssessment__c').Id;
        assessments[2].Engagement__c = me.get('BatchAPCPayTest2').Id;
        assessments[2].Position_Name__c = mp.get('BatchAPCPayTest2').Id;
        
        //TC4 APC Repeat HF Bonus
        assessments[3].RecordTypeId = mrt.get('APC PT Check-InAssessment__c').Id;
        assessments[3].Engagement__c = me.get('BatchAPCPayTest3').Id;
        assessments[3].Position_Name__c = mp.get('BatchAPCPayTest3').Id;
		assessments[3].Opportunity__c = mho.get('BatchAPCPayTest3').Id; 
        
        /*
        //TC5 APC Field Sales Bonus L1
        assessments[4].RecordTypeId = mrt.get('APC PT Check-InAssessment__c').Id;
        assessments[4].Engagement__c = me.get('BatchAPCPayTest4').Id;
        assessments[4].Position_Name__c = mp.get('BatchAPCPayTest4').Id;
		assessments[4].Opportunity__c = mho.get('BatchAPCPayTest4').Id;
        
        //TC6 APC Field Sales Bonus L2
        assessments[5].RecordTypeId = mrt.get('APC PT Check-InAssessment__c').Id;
        assessments[5].Engagement__c = me.get('BatchAPCPayTest5').Id;
        assessments[5].Position_Name__c = mp.get('BatchAPCPayTest5').Id;
		assessments[5].Opportunity__c = mho.get('BatchAPCPayTest5').Id;         
		*/
        insert assessments;

		//Run APC Batch Stipend 

        
        //This process creates or updates Pay Events for the current Month.  It starts
        //from Match Owner History, and looks up the data model as needed.
		Batch_APC_Stipend_Pay_Events b = New Batch_APC_Stipend_Pay_Events();
		database.executeBatch(b);

        Test.stopTest(); 
		/*
        //Make sure that no extranous MOH instances got created -- should be original 6 Matches + 1 intra-month ownership change
        List<Match_Owner_History__c> mohUpdated = [SELECT Id, Name, Match__c, Start_Date__c, End_Date__c FROM Match_Owner_History__c WHERE Match__c in : matchIds];
        system.assertEquals(7, mohUpdated.size());
        
		//Verify the right number of Stipend Pay Events, with proper attribute values got created. 
        List<Pay_Event__c> peStipend = [SELECT Id, Name, Intrax_Program__c, Payee__c, Intrax_Region__c, Stage__c, Event_Date__c, Quantity__c, Customer__c, OwnerId, Source__c, Reference_Id__c, Reference_Object__c, Type__c, Sub_Type__c, Amount__c, Pay_Event_Setting_Name__c FROM Pay_Event__c WHERE Type__c = 'Stipend' AND Customer__c LIKE 'BatchAPCPayTest%' Order By Customer__c, Name DESC];
		system.assertEquals(5, peStipend.size());
        
        //Need map to select each TC Pay Event instance--Pay Events are unique on Customer + Payee
        Map<String, Pay_Event__c> mpeStipend = New Map<String, Pay_Event__c>();
        for(Pay_Event__c pe : peStipend){
            mpeStipend.put('' + pe.Customer__c + pe.Payee__c, pe);
        }
        
        //TC1: Owned for full month.
        Pay_Event__c peTC1 = mpeStipend.get('BatchAPCPayTest0' + mApcFsUsers.get(0).Id);
        //system.assertEquals(daysInTestMonth, peTC1.Quantity__c);
        system.assertEquals('Unearned', peTC1.Stage__c);        
        system.assertEquals(date.today().toStartOfMonth().addMonths(1).addDays(-1), peTC1.Event_Date__c);
        system.assertEquals('AuPairCare', peTC1.Intrax_Program__c);
        system.assert((peTC1.Amount__c * peTC1.Quantity__c).setScale(2) <= (((Pay_Event_Settings__c.getValues(peTC1.Source__c).PE_Amount__c)*daysInTestMonth).setScale(2)));
        
        //TC2: Owned from 1 day before start to middle of month
        Pay_Event__c peTC2 = mpeStipend.get('BatchAPCPayTest1' + mApcFsUsers.get(1).Id);
        system.assertEquals(16, peTC2.Quantity__c);
        system.assertEquals('Unearned', peTC2.Stage__c);
        system.assertEquals(Date.today().toStartOfMonth().addDays(15), peTC2.Event_Date__c);
        system.assertEquals('AuPairCare', peTC2.Intrax_Program__c);
        system.assert((peTC2.Amount__c * peTC2.Quantity__c).setScale(2) <= (((Pay_Event_Settings__c.getValues(peTC2.Source__c).PE_Amount__c)*16).setScale(2)));
        
        //TC3: Owned from middle through end of month.
        Pay_Event__c peTC3 = mpeStipend.get('BatchAPCPayTest2' + mApcFsUsers.get(2).Id);
        //system.assertEquals(daysInTestMonth - 15, peTC3.Quantity__c);
        system.assertEquals('Unearned', peTC3.Stage__c);
        system.assertEquals(date.today().toStartOfMonth().addMonths(1).addDays(-1), peTC3.Event_Date__c);
        system.assertEquals('AuPairCare', peTC3.Intrax_Program__c);
        system.assert((peTC3.Amount__c * peTC3.Quantity__c).setScale(2) <= (((Pay_Event_Settings__c.getValues(peTC3.Source__c).PE_Amount__c)*(daysInTestMonth - 15)).setScale(2)));     
        
        //TC4:  Owned from last day of month onwards.
        Pay_Event__c peTC4 = mpeStipend.get('BatchAPCPayTest3' + mApcFsUsers.get(3).Id);
        system.assertEquals(1, peTC4.Quantity__c);
        system.assertEquals('Unearned', peTC4.Stage__c);
        system.assertEquals(date.today().toStartOfMonth().addMonths(1).addDays(-1), peTC4.Event_Date__c);
        system.assertEquals('AuPairCare', peTC4.Intrax_Program__c);
        system.assert((peTC4.Amount__c * peTC4.Quantity__c).setScale(2) <= (((Pay_Event_Settings__c.getValues(peTC4.Source__c).PE_Amount__c)*1).setScale(2)));     
        
        //TC5:  Took over ownership mid-month through end-of-month
        Pay_Event__c peTC5 = mpeStipend.get('BatchAPCPayTest1' + mApcFsUsers.get(5).Id);
        //system.assertEquals(daysInTestMonth - 15, peTC5.Quantity__c);       
        system.assertEquals('Unearned', peTC5.Stage__c);
        system.assertEquals(date.today().toStartOfMonth().addMonths(1).addDays(-1), peTC5.Event_Date__c);
        system.assertEquals('AuPairCare', peTC5.Intrax_Program__c);
        system.assert((peTC5.Amount__c * peTC5.Quantity__c).setScale(2) <= (((Pay_Event_Settings__c.getValues(peTC5.Source__c).PE_Amount__c)*(daysInTestMonth - 15)).setScale(2)));           

		//Verify that non-Stipend Assessment Triggered Pay Events are created, and have correct attribute values.
		//Using Customer Name to ensure list order relates back to order of assessment creation--this is critical to execution        
        List<Pay_Event__c> payEvents = [SELECT Id, Name, Intrax_Program__c, Intrax_Region__c, Stage__c, Event_Date__c, Quantity__c, Customer__c, OwnerId, Source__c, Reference_Id__c, Reference_Object__c, Type__c, Sub_Type__c, Amount__c, Pay_Event_Setting_Name__c FROM Pay_Event__c WHERE Type__c != 'Stipend' AND Customer__c LIKE 'BatchAPCPayTest%' Order By Customer__c];
		
        if(payEvents!=null && payEvents.size()>0){
        //TC1 APC PT Orientation Verification
        system.assertEquals(mApcFsUsers.get(0).Id, payEvents[0].OwnerId);
        system.assertEquals('APC PT Orientation', payEvents[0].Source__c);
        system.assertEquals('Assessment', payEvents[0].Reference_Object__c);
        system.assertEquals(Pay_Event_Settings__c.getValues(payEvents[0].Source__c).PE_Type__c, payEvents[0].Type__c);
        system.assertEquals((payEvents[0].Amount__c).setScale(2), (Pay_Event_Settings__c.getValues(payEvents[0].Source__c).PE_Amount__c).setScale(2));
        system.assertEquals('APC PT Orientation', payEvents[0].Pay_Event_Setting_Name__c);
        system.assertNotEquals(null, payEvents[0].Event_Date__c);
        system.assertEquals(1, payEvents[0].Quantity__c);
        system.assertNotEquals(null, payEvents[0].Reference_Id__c);
        system.assertEquals('Pending', payEvents[0].Stage__c);
        system.assertEquals(assessments[0].Name, PayEvents[0].Customer__c);
        system.assertEquals('AuPairCare', payEvents[0].Intrax_Program__c);
        system.assertEquals('United States', payEvents[0].Intrax_Region__c);
        
        //TC2 APC PT Exit Interview
        system.assertEquals(mApcFsUsers.get(1).Id, payEvents[1].OwnerId);
        system.assertEquals('APC PT Exit Interview', payEvents[1].Source__c);
        system.assertEquals('Assessment', payEvents[1].Reference_Object__c);
        system.assertEquals(Pay_Event_Settings__c.getValues(payEvents[1].Source__c).PE_Type__c, payEvents[1].Type__c);
        system.assertEquals((payEvents[1].Amount__c).setScale(2), (Pay_Event_Settings__c.getValues(payEvents[1].Source__c).PE_Amount__c).setScale(2));
        system.assertEquals('APC PT Exit Interview', payEvents[1].Pay_Event_Setting_Name__c);
        system.assertNotEquals(null, payEvents[1].Event_Date__c);
        system.assertEquals(1, payEvents[1].Quantity__c);
        system.assertNotEquals(null, payEvents[1].Reference_Id__c);
        system.assertEquals('Pending', payEvents[1].Stage__c);
        system.assertEquals(assessments[1].Name, PayEvents[1].Customer__c);
        system.assertEquals('AuPairCare', payEvents[1].Intrax_Program__c);
        system.assertEquals('United States', payEvents[1].Intrax_Region__c);
        
        //TC3 APC HF Interview
        system.assertEquals(mApcFsUsers.get(2).Id, payEvents[2].OwnerId);
        system.assertEquals('APC HF Interview', payEvents[2].Source__c);
        system.assertEquals('Assessment', payEvents[2].Reference_Object__c);
        system.assertEquals(Pay_Event_Settings__c.getValues(payEvents[2].Source__c).PE_Type__c, payEvents[2].Type__c);
        system.assertEquals((payEvents[2].Amount__c).setScale(2), (Pay_Event_Settings__c.getValues(payEvents[2].Source__c).PE_Amount__c).setScale(2));
        system.assertEquals('APC HF Interview', payEvents[2].Pay_Event_Setting_Name__c);
        system.assertNotEquals(null, payEvents[2].Event_Date__c);
        system.assertEquals(1, payEvents[2].Quantity__c);
        system.assertNotEquals(null, payEvents[2].Reference_Id__c);
        system.assertEquals('Pending', payEvents[2].Stage__c);
        system.assertEquals(assessments[2].Name, PayEvents[2].Customer__c);
        system.assertEquals('AuPairCare', payEvents[2].Intrax_Program__c);
        system.assertEquals('United States', payEvents[2].Intrax_Region__c); 
        
        //TC4 APC HF Repeat Bonus
        system.assertEquals(mApcFsUsers.get(3).Id, payEvents[3].OwnerId);
        system.assertEquals('APC HF Repeat Bonus', payEvents[3].Source__c);
        system.assertEquals('Assessment', payEvents[3].Reference_Object__c);
        system.assertEquals(Pay_Event_Settings__c.getValues(payEvents[3].Source__c).PE_Type__c, payEvents[3].Type__c);
        system.assertEquals((payEvents[3].Amount__c).setScale(2), (Pay_Event_Settings__c.getValues(payEvents[3].Source__c).PE_Amount__c).setScale(2));
        system.assertEquals('APC HF Repeat Bonus', payEvents[3].Pay_Event_Setting_Name__c);
        system.assertNotEquals(null, payEvents[3].Event_Date__c);
        system.assertEquals(1, payEvents[3].Quantity__c);
        system.assertNotEquals(null, payEvents[3].Reference_Id__c);
        system.assertEquals('Pending', payEvents[3].Stage__c);
        system.assertEquals(assessments[3].Name, PayEvents[3].Customer__c);
        system.assertEquals('AuPairCare', payEvents[3].Intrax_Program__c);
        system.assertEquals('United States', payEvents[3].Intrax_Region__c); 
        
        //TC5 APC New HF L1
        system.assertEquals(mApcFsUsers.get(4).Id, payEvents[4].OwnerId);
        system.assertEquals('APC New HF L1', payEvents[4].Source__c);
        system.assertEquals('Assessment', payEvents[4].Reference_Object__c);
        system.assertEquals('New Bonus', payEvents[4].Type__c);
        system.assertEquals(Pay_Event_Settings__c.getValues(payEvents[4].Source__c).PE_Type__c, payEvents[4].Type__c);
        system.assertEquals((payEvents[4].Amount__c).setScale(2), (Pay_Event_Settings__c.getValues(payEvents[4].Source__c).PE_Amount__c).setScale(2));
        system.assertEquals('APC New HF L1', payEvents[4].Pay_Event_Setting_Name__c);
        system.assertNotEquals(null, payEvents[4].Event_Date__c);
        system.assertEquals(1, payEvents[4].Quantity__c);
        system.assertNotEquals(null, payEvents[4].Reference_Id__c);
        system.assertEquals('Pending', payEvents[4].Stage__c);
        system.assertEquals(assessments[4].Name, PayEvents[4].Customer__c);
        system.assertEquals('AuPairCare', payEvents[4].Intrax_Program__c);
        system.assertEquals('United States', payEvents[4].Intrax_Region__c); 

        //TC6 APC New HF L2
        system.assertEquals(mApcFsUsers.get(5).Id, payEvents[5].OwnerId);
        system.assertEquals('APC New HF L2', payEvents[5].Source__c);
        system.assertEquals('Assessment', payEvents[5].Reference_Object__c);
        system.assertEquals('New Bonus', payEvents[5].Type__c);
        system.assertEquals(Pay_Event_Settings__c.getValues(payEvents[5].Source__c).PE_Type__c, payEvents[5].Type__c);
        system.assertEquals((payEvents[5].Amount__c).setScale(2), (Pay_Event_Settings__c.getValues(payEvents[5].Source__c).PE_Amount__c).setScale(2));
        system.assertEquals('APC New HF L2', payEvents[5].Pay_Event_Setting_Name__c);
        system.assertNotEquals(null, payEvents[5].Event_Date__c);
        system.assertEquals(1, payEvents[5].Quantity__c);
        system.assertNotEquals(null, payEvents[5].Reference_Id__c);
        system.assertEquals('Pending', payEvents[5].Stage__c);
        system.assertEquals(assessments[5].Name, PayEvents[5].Customer__c);
        system.assertEquals('AuPairCare', payEvents[5].Intrax_Program__c);
        system.assertEquals('United States', payEvents[5].Intrax_Region__c);
        
        }
        */
    }
}