@isTest()
public class Test_GA_Snapshot {
    
    @testSetup static void methodName(){
        //Set Global Constants email address
        Global_Constants__c gc = new Global_Constants__c(Fault_Email_Address__c = 'SFDCNotify@intraxinc.com');
        insert gc; 
    }     
    
	//Forces GA oAuth exception
    static testmethod void gaAuthFailTest(){
        //Create Custom Setting for GA oAuth request that will fail
        KPI_GA_oAuth__c oAuthSetting = new KPI_GA_oAuth__c(Endpoint__c = 'https://www.googleapis.com/oauth2/v3/tokenFailure',
                                                           Use_Notification_Email__c = 'SFDCNotify@intraxinc.com',
                                                 		   ISS__c = 'iss@google.com', Scope__c = 'https://www.googleapis.com/auth/analytics');
        insert oAuthSetting;        
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpAuthFailFactory());
 
    	Batch_GA_Snapshot b = New Batch_GA_Snapshot();
    	database.executeBatch(b);

        Test.stopTest();

        List<MA_Snapshot__c> maRows = [SELECT Id FROM MA_Snapshot__c];
		system.assertEquals(0, maRows.size());        
    }
    
	//Forces DML Save exception
    static testmethod void maSnapshotSaveFailTest(){
        //Create Custom Setting for GA oAuth request that will Succeed
        KPI_GA_oAuth__c oAuthSetting = new KPI_GA_oAuth__c(Endpoint__c = 'https://www.googleapis.com/oauth2/v3/tokenSuccess',
                                                           Use_Notification_Email__c = 'SFDCNotify@intraxinc.com',
                                                 		   ISS__c = 'iss@google.com', Scope__c = 'https://www.googleapis.com/auth/analytics');
        insert oAuthSetting;  
        
        List<KPI_GA_Query_Info__c> kpiQueries = new List<KPI_GA_Query_Info__c>();
        //T6:  Full parameter payload, "Lead Query" with field overflow forced Execution phase exception
        kpiQueries.add(new KPI_GA_Query_Info__c(
            Name = 'Test6', Query_Number__c = 6, Filter__c = 'filterString',
        	Dimensions__c = 'dimensionString', Metrics__c = 'metricString',
        	ProfileId__c = '6666666', Sort_List__c = 'sortString', Start_Index__c = 1,
        	Max_Results__c = 10000, Segment__c = 'segmentString',
        	GA_Analytics_Endpoint__c = 'https://www.googleapis.com/analytics/v3/data/ga',
        	Active__c = true, Max_Days__c = 2, Sys_Admin_Tag__c = 'T6', Source_System_Code__c = 'GA'));  

        insert kpiQueries;        
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpQueryFactory());
 
    	Batch_GA_Snapshot b = New Batch_GA_Snapshot();
    	database.executeBatch(b);

        Test.stopTest();
        
        List<MA_Snapshot__c> maRows = [SELECT Id FROM MA_Snapshot__c];
        //Note this test could be improved to insert > 200 new MA_Snapshot records, and then vary the order
        //of the record triggering the overflow exception.  Each batch is its own transaction, so if the 
        //exception occurred on record 201, the first 200 new MA_Snapshot records would commit and not be rolled
        //back.
		system.assertEquals(0, maRows.size());           
    } 
    
	//Forces Final phase save exception on KPI Dates processed
    static testmethod void KPIgaQueryUpdateFailTest(){
        //Create Custom Setting for GA oAuth request that will Succeed
        KPI_GA_oAuth__c oAuthSetting = new KPI_GA_oAuth__c(Endpoint__c = 'https://www.googleapis.com/oauth2/v3/tokenSuccess',
                                                           Use_Notification_Email__c = 'SFDCNotify@intraxinc.com',
                                                 		   ISS__c = 'iss@google.com', Scope__c = 'https://www.googleapis.com/auth/analytics');
        insert oAuthSetting;  
        
        List<KPI_GA_Query_Info__c> kpiQueries = new List<KPI_GA_Query_Info__c>();
        //T7:  Full parameter payload, "Lead Query" with Start_Date__c coordinated with 'isRunningTest()' code to force
        //a Final stage failure.  isRunningTest loops through update list looking for a Start Date of Today-20 days, and
        //then throws a custom ServiceCalloutException in the Final batch stage.
        kpiQueries.add(new KPI_GA_Query_Info__c(
            Name = 'Test7', Query_Number__c = 7, Filter__c = 'filterString',
        	Dimensions__c = 'dimensionString', Metrics__c = 'metricString',
        	ProfileId__c = '7777777', Sort_List__c = 'sortString', Start_Index__c = 1,
        	Max_Results__c = 10000, Segment__c = 'segmentString', Start_Date__c = Date.today().addDays(-20),
        	GA_Analytics_Endpoint__c = 'https://www.googleapis.com/analytics/v3/data/ga',
        	Active__c = true, Max_Days__c = 1, Sys_Admin_Tag__c = 'T7', Source_System_Code__c = 'GA'));  

        insert kpiQueries;        
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpQueryFactory());
 
    	Batch_GA_Snapshot b = New Batch_GA_Snapshot();
    	database.executeBatch(b);

        Test.stopTest();
        
        List<MA_Snapshot__c> maRows = [SELECT Id FROM MA_Snapshot__c];
        //Note that if >200 new MA_Snapshots were processed in more than 1 batch, only the last batch of MA_Snapshot
        //records would fail to get inserted.  This test case could be enhanced at some point to include large-scale
        //tests of these conditions.
		system.assertEquals(0, maRows.size());           
    } 

	//Forces MaxResults exception (GA returns rows equal to limit, which implies some data will be missing in MA_Snapshots)
    static testmethod void KPIgaMaxResultFailTest(){
        //Create Custom Setting for GA oAuth request that will Succeed
        KPI_GA_oAuth__c oAuthSetting = new KPI_GA_oAuth__c(Endpoint__c = 'https://www.googleapis.com/oauth2/v3/tokenSuccess',
                                                           Use_Notification_Email__c = 'SFDCNotify@intraxinc.com',
                                                 		   ISS__c = 'iss@google.com', Scope__c = 'https://www.googleapis.com/auth/analytics');
        insert oAuthSetting;  
        
        List<KPI_GA_Query_Info__c> kpiQueries = new List<KPI_GA_Query_Info__c>();
        //T8:  Full parameter payload, "Lead Query",MaxResults (3) equals response body rows (3) implies limit truncated available GA data
        kpiQueries.add(new KPI_GA_Query_Info__c(
            Name = 'Test8', Query_Number__c = 8, Filter__c = 'filterString',
        	Dimensions__c = 'dimensionString', Metrics__c = 'metricString',
        	ProfileId__c = '1111111', Sort_List__c = 'sortString', Start_Index__c = 1,
        	Max_Results__c = 3, Segment__c = 'segmentString', Start_Date__c = Date.today().addDays(-2),
        	GA_Analytics_Endpoint__c = 'https://www.googleapis.com/analytics/v3/data/ga',
        	Active__c = true, Max_Days__c = 1, Sys_Admin_Tag__c = 'T8', Source_System_Code__c = 'GA'));  

        insert kpiQueries;        
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpQueryFactory());
 
    	Batch_GA_Snapshot b = New Batch_GA_Snapshot();
    	database.executeBatch(b);

        Test.stopTest();
        
        List<MA_Snapshot__c> maRows = [SELECT Id FROM MA_Snapshot__c];
        //Note as with other TCs, larget batches of >200 records may have partial commits.
		system.assertEquals(0, maRows.size());           
    }     

    //GA Query tests
    static testmethod void gaSnapshotTest(){
        //Create Custom Setting for GA oAuth request that will Succeed
        KPI_GA_oAuth__c oAuthSetting = new KPI_GA_oAuth__c(Endpoint__c = 'https://www.googleapis.com/oauth2/v3/tokenSuccess',
                                                           Use_Notification_Email__c = 'SFDCNotify@intraxinc.com',
                                                 		   ISS__c = 'iss@google.com', Scope__c = 'https://www.googleapis.com/auth/analytics');
        insert oAuthSetting;

		//Tests all three "GA Query" Types we need:  Lead, Event and Goal         
        List<KPI_GA_Query_Info__c> kpiQueries = new List<KPI_GA_Query_Info__c>();
        //T1:  Full parameter payload, "Lead Query" first-time (no prior data downloaded) request -- 1 Day
        kpiQueries.add(new KPI_GA_Query_Info__c(
            Name = 'Test1', Query_Number__c = 1, Filter__c = 'filterString',
        	Dimensions__c = 'dimensionString', Metrics__c = 'metricString',
        	ProfileId__c = '1111111', Sort_List__c = 'sortString', Start_Index__c = 1,
        	Max_Results__c = 10000, Segment__c = 'segmentString',
        	GA_Analytics_Endpoint__c = 'https://www.googleapis.com/analytics/v3/data/ga',
        	Active__c = true, Max_Days__c = 2, Sys_Admin_Tag__c = 'T1', Source_System_Code__c = 'GA'));

        //T2:  Minimal parameter payload, "Event Query" incremental (prior data download) request -- 2 Days
        kpiQueries.add(new KPI_GA_Query_Info__c(
            Name = 'Test2', Query_Number__c = 2,
        	Dimensions__c = 'dimensionString', Metrics__c = 'metricString',
        	ProfileId__c = '2222222', Max_Results__c = 10000, Last_GA_Update_At__c = Date.Today().addDays(-3), 
            GA_Analytics_Endpoint__c = 'https://www.googleapis.com/analytics/v3/data/ga',
        	Active__c = true, Max_Days__c = 2, Sys_Admin_Tag__c = 'T2', Source_System_Code__c = 'GA'));

        //T3:  Minimal parameter payload, "Goal Query" backfill (gap data download) -- 2 Days (Date range is 2 days, but Max_Days is 1)
        //Tests moving up fill-in Start Date
        kpiQueries.add(new KPI_GA_Query_Info__c(
            Name = 'Test3', Query_Number__c = 3,
        	Dimensions__c = 'dimensionString', Metrics__c = 'metricString',
        	ProfileId__c = '3333333', Max_Results__c = 10000, Last_GA_Update_At__c = Date.Today().addDays(-1), 
            GA_Analytics_Endpoint__c = 'https://www.googleapis.com/analytics/v3/data/ga',
            Start_Date__c = Date.Today().addDays(-10), End_Date__c = Date.Today().addDays(-9),
        	Active__c = true, Max_Days__c = 1, Sys_Admin_Tag__c = 'T3', Source_System_Code__c = 'GA')); 

        //T4:  Minimal parameter payload, "Goal Query" backfill (gap data download) -- 2 Days (Date range is 2 days, Max Days is 3)
        //Tests stopping fill-in and clearing backfill Start/End dates when backfill is complete
        kpiQueries.add(new KPI_GA_Query_Info__c(
            Name = 'Test4', Query_Number__c = 4,
        	Dimensions__c = 'dimensionString', Metrics__c = 'metricString',
        	ProfileId__c = '4444444', Max_Results__c = 10000, Last_GA_Update_At__c = Date.Today().addDays(-1), 
            GA_Analytics_Endpoint__c = 'https://www.googleapis.com/analytics/v3/data/ga',
            Start_Date__c = Date.Today().addDays(-10), End_Date__c = Date.Today().addDays(-9),
        	Active__c = true, Max_Days__c = 3, Sys_Admin_Tag__c = 'T4', Source_System_Code__c = 'GA')); 

        //T5:  Full parameter payload, "Lead Query" with forced GA API Query Callout failure
        kpiQueries.add(new KPI_GA_Query_Info__c(
            Name = 'Test5', Query_Number__c = 5, Filter__c = 'filterString',
        	Dimensions__c = 'dimensionString', Metrics__c = 'metricString',
        	ProfileId__c = '5555555', Sort_List__c = 'sortString', Start_Index__c = 1,
        	Max_Results__c = 10000, Segment__c = 'segmentString',
        	GA_Analytics_Endpoint__c = 'https://www.googleapis.com/analytics/v3/data/ga',
        	Active__c = true, Max_Days__c = 2, Sys_Admin_Tag__c = 'T5', Source_System_Code__c = 'GA'));        
       
        insert kpiQueries;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpQueryFactory());
 
    	Batch_GA_Snapshot b = New Batch_GA_Snapshot();
    	database.executeBatch(b);

        Test.stopTest(); 
  
        List<MA_Snapshot__c> maRows = [SELECT Id, Landing_Page_Path__c, Users__c, Bounces__c, Sessions__c, Page_Views__c,
                                       Goal_Completions_All__c, Pageviews_Per_Session__c, Name, Date__c, Profile_Id__c,
                                       Account_Id__c, Query_Number__c, Source_System__c, Sys_Admin_Tag__c, Traffic_Type__c,
                                       Page_Path__c, Event_Label__c, Event_Category__c, Event_Action__c, Goal_1_Completions__c,
                                       Goal_Completion_Location__c, Goal_Previous_Step_1__c, Goal_Previous_Step_2__c
                                       FROM MA_Snapshot__c];
        
		system.assertEquals(42, maRows.size());
        
        Integer t1Count = 0;
        Integer t2Count = 0;
        Integer t3Count = 0;
        Integer t4Count = 0;
        
        for(MA_Snapshot__c mas : maRows){
            if(mas.Query_Number__c == 1) t1Count++;
            if(mas.Query_Number__c == 2) t2Count++;
            if(mas.Query_Number__c == 3) t3Count++;
            if(mas.Query_Number__c == 4) t4Count++;
            
            if(mas.Query_Number__c == 1 && mas.Traffic_Type__c == 'referral' && mas.Page_Path__c == '/'){
                system.assertEquals('/', mas.Landing_Page_Path__c);
                system.assertEquals(157, mas.Users__c);
                system.assertEquals(160, mas.Bounces__c);
                system.assertEquals(167, mas.Sessions__c);
                system.assertEquals(175, mas.Page_Views__c);
                system.assertEquals(0, mas.Goal_Completions_All__c);
                system.assertEquals(1.048, mas.Pageviews_Per_Session__c);
                system.assertEquals('Exclude Office Traffic', mas.Name);
                system.assertEquals(date.newinstance(2015, 5, 30), mas.Date__c); //Note date is static in test res body
                system.assertEquals('72882671', mas.Profile_Id__c);
                system.assertEquals('40579181', mas.Account_Id__c);
                system.assertEquals(1, mas.Query_Number__c);
                system.assertEquals('GA', mas.Source_System__c);
                system.assertEquals('T1', mas.Sys_Admin_Tag__c);
            } else if(mas.Query_Number__c == 2 && mas.Event_Label__c == 'Baseline'){
                system.assertEquals('Baseline', mas.Event_Label__c);
                system.assertEquals('Scroll Depth', mas.Event_Category__c);
                system.assert(mas.Event_Action__c.contains('/23423/43234234'));
                system.assertEquals(5, mas.Goal_1_Completions__c);
            } else if(mas.Query_Number__c == 3 && mas.Goal_Completion_Location__c.contains('/A3423')){
                system.assert(mas.Goal_Previous_Step_1__c.contains('/B3423'));
                system.assert(mas.Goal_Previous_Step_2__c.contains('/C3423'));
                system.assertEquals(1, mas.Goal_Completions_All__c);
            }
        }
        system.assertEquals(3, t1Count);
        system.assertEquals(12, t2Count);
        system.assertEquals(9, t3Count);
        system.assertEquals(18, t4Count);        
    }

    //Test Schedule setup
    public static CronTrigger fetchCronTrigger(String jobId) 
    {
        return [SELECT CronExpression, State, TimesTriggered, NextFireTime
        		FROM CronTrigger
        		WHERE Id = :jobId];
    }
    static testMethod void scheduleBatchTest() 
    {
     Test.startTest();
     String jobId = System.schedule('Test Batch GA Snapshots','0 40 1 * * ? *', new Batch_GA_Snapshot());
     CronTrigger ct = fetchCronTrigger(jobId);
     system.assert(ct.Id != null);
     system.assertEquals(0, ct.TimesTriggered);
     system.assertEquals(40, ct.NextFireTime.minute());
     system.assertEquals('WAITING', ct.State);
     Test.stopTest();
    }    

    //Creates the appropriate mock response based on incoming request.  Note GA response strings have
    //the headers and rows towards the end, but other parts of the JSON are also used.  If changes
    //become necessary, suggest adding a system debug to the batch class and running it manually in an 
    //SB to collect an actual request result and then shorten it as needed.  
    //
    //Three data callouts are required because there are 3 different "query types" that return different
    //dimension/metric attributes, and we want to test 100% of the MA_Snapshot attribute assignments.
    public class MockHttpQueryFactory implements HttpCalloutMock
    {
		public String resAuth = '{"access_token": "ya29.ngELhxoZ7u6OUwgmI9LmH6Yav8WAg9W9s1NHT2fDMh3DgvawPP-KGHLqy8yBgbvvBsPQlgb69ttFEw", "token_type": "Bearer", "expires_in": 3600}';
		//Positive: Has 3 rows of query type "Lead"
        public String resTest1 = '{"kind":"analytics#gaData","id":"https://www.googleapis.com/analytics/v3/data/ga?ids=ga:72882671&dimensions=ga:medium,ga:source,ga:landingPagePath,ga:pagePath&metrics=ga:users,ga:bounces,ga:sessions,ga:pageviews,ga:goalCompletionsAll,ga:goalConversionRateAll,ga:pageviewsPerSession&sort=-ga:medium&start-date=2015-05-30&end-date=2015-05-30&max-results=10000","query":{"start-date":"2015-05-30","end-date":"2015-05-30","ids":"ga:72882671","dimensions":"ga:medium,ga:source,ga:landingPagePath,ga:pagePath","metrics":["ga:users","ga:bounces","ga:sessions","ga:pageviews","ga:goalCompletionsAll","ga:goalConversionRateAll","ga:pageviewsPerSession"],"sort":["-ga:medium"],"start-index":1,"max-results":10000},"itemsPerPage":10000,"totalResults":251,"selfLink":"https://www.googleapis.com/analytics/v3/data/ga?ids=ga:72882671&dimensions=ga:medium,ga:source,ga:landingPagePath,ga:pagePath&metrics=ga:users,ga:bounces,ga:sessions,ga:pageviews,ga:goalCompletionsAll,ga:goalConversionRateAll,ga:pageviewsPerSession&sort=-ga:medium&start-date=2015-05-30&end-date=2015-05-30&max-results=10000","profileInfo":{"profileId":"72882671","accountId":"40579181","webPropertyId":"UA-40579181-1","internalWebPropertyId":"69811682","profileName":"Exclude Office Traffic","tableId":"ga:72882671"},"containsSampledData":false,"columnHeaders":[{"name":"ga:medium","columnType":"DIMENSION","dataType":"STRING"},{"name":"ga:source","columnType":"DIMENSION","dataType":"STRING"},{"name":"ga:landingPagePath","columnType":"DIMENSION","dataType":"STRING"},{"name":"ga:pagePath","columnType":"DIMENSION","dataType":"STRING"},{"name":"ga:users","columnType":"METRIC","dataType":"INTEGER"},{"name":"ga:bounces","columnType":"METRIC","dataType":"INTEGER"},{"name":"ga:sessions","columnType":"METRIC","dataType":"INTEGER"},{"name":"ga:pageviews","columnType":"METRIC","dataType":"INTEGER"},{"name":"ga:goalCompletionsAll","columnType":"METRIC","dataType":"INTEGER"},{"name":"ga:goalConversionRateAll","columnType":"METRIC","dataType":"PERCENT"},{"name":"ga:pageviewsPerSession","columnType":"METRIC","dataType":"FLOAT"}],"totalsForAllResults":{"ga:users":"650","ga:bounces":"160","ga:sessions":"384","ga:pageviews":"788","ga:goalCompletionsAll":"5","ga:goalConversionRateAll":"1.3020833333333335","ga:pageviewsPerSession":"2.0520833333333335"},"rows":[["referral","4webmasters.org","/","/","157","160","167","175","0","0.0","1.0479041916167664"],["referral","4webmasters.org","/","/ga_c.php","1","0","0","0","0","0.0","0.0"],["referral","best-seo-offer.com","/23423/43234234/3kljsdfkel/32kjasdflkjasldflkjkj/asdflkjlkj3223kljlkjlkjasdfjk/lkjallksjdflkjlkjwelkjlkjlkjasdflkjljlkewrweasdfj209asdfkjlkjwelkjasdafdasdflkjdaosdfiowuewelkjsladijafowiejlaksdflkjlkwejoisjklewjlkjfoiewlkajlkjlasdflkjweroiujlfadslakjdksdfowielkjadlkfjlkjweoijlkjasdlfkj","/23423/43234234/3kljsdfkel/32kjasdflkjasldflkjkj/asdflkjlkj3223kljlkjlkjasdfjk/lkjallksjdflkjlkjwelkjlkjlkjasdflkjljlkewrweasdfj209asdfkjlkjwelkjasdafdasdflkjdaosdfiowuewelkjsladijafowiejlaksdflkjlkwejoisjklewjlkjfoiewlkajlkjlasdflkjweroiujlfadslakjdksdfowielkjadlkfjlkjweoijlkjasdlfkj","5","0","5","5","0","0.0","1.0"]]}';
		//Positive: Has 6 rows of query type "Event"
        public String resTest2= '{"kind":"analytics#gaData","id":"https://www.googleapis.com/analytics/v3/data/ga?ids=ga:72882671&dimensions=ga:pagePath,ga:eventCategory,ga:eventLabel,ga:eventAction&metrics=ga:pageviews,ga:sessions,ga:bounces,ga:goalCompletionsAll,ga:goal1Completions&sort=-ga:eventCategory&start-date=2015-06-24&end-date=2015-06-24&max-results=10000","query":{"start-date":"2015-06-24","end-date":"2015-06-24","ids":"ga:72882671","dimensions":"ga:pagePath,ga:eventCategory,ga:eventLabel,ga:eventAction","metrics":["ga:pageviews","ga:sessions","ga:bounces","ga:goalCompletionsAll","ga:goal1Completions"],"sort":["-ga:eventCategory"],"start-index":1,"max-results":10000},"itemsPerPage":10000,"totalResults":6,"selfLink":"https://www.googleapis.com/analytics/v3/data/ga?ids=ga:72882671&dimensions=ga:pagePath,ga:eventCategory,ga:eventLabel,ga:eventAction&metrics=ga:pageviews,ga:sessions,ga:bounces,ga:goalCompletionsAll,ga:goal1Completions&sort=-ga:eventCategory&start-date=2015-06-24&end-date=2015-06-24&max-results=10000","profileInfo":{"profileId":"72882671","accountId":"40579181","webPropertyId":"UA-40579181-1","internalWebPropertyId":"69811682","profileName":"Exclude Office Traffic","tableId":"ga:72882671"},"containsSampledData":false,"columnHeaders":[{"name":"ga:pagePath","columnType":"DIMENSION","dataType":"STRING"},{"name":"ga:eventCategory","columnType":"DIMENSION","dataType":"STRING"},{"name":"ga:eventLabel","columnType":"DIMENSION","dataType":"STRING"},{"name":"ga:eventAction","columnType":"DIMENSION","dataType":"STRING"},{"name":"ga:pageviews","columnType":"METRIC","dataType":"INTEGER"},{"name":"ga:sessions","columnType":"METRIC","dataType":"INTEGER"},{"name":"ga:bounces","columnType":"METRIC","dataType":"INTEGER"},{"name":"ga:goalCompletionsAll","columnType":"METRIC","dataType":"INTEGER"},{"name":"ga:goal1Completions","columnType":"METRIC","dataType":"INTEGER"}],"totalsForAllResults":{"ga:pageviews":"0","ga:sessions":"9","ga:bounces":"0","ga:goalCompletionsAll":"0","ga:goal1Completions":"0"},"rows":[["/","link","Begin Application","click","0","3","0","0","0"],["/","link","MyIntrax","click","0","1","0","0","0"],["/","Scroll Depth","1750","Pixel Depth","0","2","0","0","0"],["/","Scroll Depth","25%","Percentage","0","1","0","0","0"],["/","Scroll Depth","50%","Percentage","0","1","0","0","0"],["/","Scroll Depth","Baseline","/23423/43234234/3kljsdfkel/32kjasdflkjasldflkjkj/asdflkjlkj3223kljlkjlkjasdfjk/lkjallksjdflkjlkjwelkjlkjlkjasdflkjljlkewrweasdfj209asdfkjlkjwelkjasdafdasdflkjdaosdfiowuewelkjsladijafowiejlaksdflkjlkwejoisjklewjlkjfoiewlkajlkjlasdflkjweroiujlfadslakjdksdfowielkjadlkfjlkjweoijlkjasdlfkj","2","1","5","10","5"]]}';
		//Positive: Has 9 rows of query type "Goal"
        public String resTest3and4= '{"kind":"analytics#gaData","id":"https://www.googleapis.com/analytics/v3/data/ga?ids=ga:72882671&dimensions=ga:goalCompletionLocation,ga:goalPreviousStep1,ga:goalPreviousStep2&metrics=ga:goalCompletionsAll&sort=-ga:goalCompletionLocation&start-date=2015-06-25&end-date=2015-06-25&max-results=10000","query":{"start-date":"2015-06-25","end-date":"2015-06-25","ids":"ga:72882671","dimensions":"ga:goalCompletionLocation,ga:goalPreviousStep1,ga:goalPreviousStep2","metrics":["ga:goalCompletionsAll"],"sort":["-ga:goalCompletionLocation"],"start-index":1,"max-results":10000},"itemsPerPage":10000,"totalResults":9,"selfLink":"https://www.googleapis.com/analytics/v3/data/ga?ids=ga:72882671&dimensions=ga:goalCompletionLocation,ga:goalPreviousStep1,ga:goalPreviousStep2&metrics=ga:goalCompletionsAll&sort=-ga:goalCompletionLocation&start-date=2015-06-25&end-date=2015-06-25&max-results=10000","profileInfo":{"profileId":"72882671","accountId":"40579181","webPropertyId":"UA-40579181-1","internalWebPropertyId":"69811682","profileName":"Exclude Office Traffic","tableId":"ga:72882671"},"containsSampledData":false,"columnHeaders":[{"name":"ga:goalCompletionLocation","columnType":"DIMENSION","dataType":"STRING"},{"name":"ga:goalPreviousStep1","columnType":"DIMENSION","dataType":"STRING"},{"name":"ga:goalPreviousStep2","columnType":"DIMENSION","dataType":"STRING"},{"name":"ga:goalCompletionsAll","columnType":"METRIC","dataType":"INTEGER"}],"totalsForAllResults":{"ga:goalCompletionsAll":"14"},"rows":[["/request-information-thank-you","(entrance)","(not set)","1"],["/request-information-thank-you","/request-information","(entrance)","3"],["/request-information-thank-you","/request-information","/","2"],["/request-information-thank-you","/request-information","/host-companies/faq","1"],["/request-information-thank-you","/request-information","/internships/business-management","2"],["/request-information-thank-you","/request-information","/internships/hospitality-tourism","1"],["/request-information-thank-you","/request-information","/j1visa-service","2"],["/request-information-thank-you","/request-information","/search-internships/results/?cat=Business","1"],["/A3423/43234234/3kljsdfkel/32kjasdflkjasldflkjkj/asdflkjlkj3223kljlkjlkjasdfjk/lkjallksjdflkjlkjwelkjlkjlkjasdflkjljlkewrweasdfj209asdfkjlkjwelkjasdafdasdflkjdaosdfiowuewelkjsladijafowiejlaksdflkjlkwejoisjklewjlkjfoiewlkajlkjlasdflkjweroiujlfadslakjdksdfowielkjadlkfjlkjweoijlkjasdlfkj","/B3423/43234234/3kljsdfkel/32kjasdflkjasldflkjkj/asdflkjlkj3223kljlkjlkjasdfjk/lkjallksjdflkjlkjwelkjlkjlkjasdflkjljlkewrweasdfj209asdfkjlkjwelkjasdafdasdflkjdaosdfiowuewelkjsladijafowiejlaksdflkjlkwejoisjklewjlkjfoiewlkajlkjlasdflkjweroiujlfadslakjdksdfowielkjadlkfjlkjweoijlkjasdlfkj","/C3423/43234234/3kljsdfkel/32kjasdflkjasldflkjkj/asdflkjlkj3223kljlkjlkjasdfjk/lkjallksjdflkjlkjwelkjlkjlkjasdflkjljlkewrweasdfj209asdfkjlkjwelkjasdafdasdflkjdaosdfiowuewelkjsladijafowiejlaksdflkjlkwejoisjklewjlkjfoiewlkajlkjlasdflkjweroiujlfadslakjdksdfowielkjadlkfjlkjweoijlkjasdlfkj","1"]]}';
		//Positive: Has 3 rows of query type "Lead"
        public String resTest5 = '{"kind":"analytics#gaData","id":"https://www.googleapis.com/analytics/v3/data/ga?ids=ga:72882671&dimensions=ga:medium,ga:source,ga:landingPagePath,ga:pagePath&metrics=ga:users,ga:bounces,ga:sessions,ga:pageviews,ga:goalCompletionsAll,ga:goalConversionRateAll,ga:pageviewsPerSession&sort=-ga:medium&start-date=2015-05-30&end-date=2015-05-30&max-results=10000","query":{"start-date":"2015-05-30","end-date":"2015-05-30","ids":"ga:72882671","dimensions":"ga:medium,ga:source,ga:landingPagePath,ga:pagePath","metrics":["ga:users","ga:bounces","ga:sessions","ga:pageviews","ga:goalCompletionsAll","ga:goalConversionRateAll","ga:pageviewsPerSession"],"sort":["-ga:medium"],"start-index":1,"max-results":10000},"itemsPerPage":10000,"totalResults":251,"selfLink":"https://www.googleapis.com/analytics/v3/data/ga?ids=ga:72882671&dimensions=ga:medium,ga:source,ga:landingPagePath,ga:pagePath&metrics=ga:users,ga:bounces,ga:sessions,ga:pageviews,ga:goalCompletionsAll,ga:goalConversionRateAll,ga:pageviewsPerSession&sort=-ga:medium&start-date=2015-05-30&end-date=2015-05-30&max-results=10000","profileInfo":{"profileId":"72882671","accountId":"40579181","webPropertyId":"UA-40579181-1","internalWebPropertyId":"69811682","profileName":"Exclude Office Traffic","tableId":"ga:72882671"},"containsSampledData":false,"columnHeaders":[{"name":"ga:medium","columnType":"DIMENSION","dataType":"STRING"},{"name":"ga:source","columnType":"DIMENSION","dataType":"STRING"},{"name":"ga:landingPagePath","columnType":"DIMENSION","dataType":"STRING"},{"name":"ga:pagePath","columnType":"DIMENSION","dataType":"STRING"},{"name":"ga:users","columnType":"METRIC","dataType":"INTEGER"},{"name":"ga:bounces","columnType":"METRIC","dataType":"INTEGER"},{"name":"ga:sessions","columnType":"METRIC","dataType":"INTEGER"},{"name":"ga:pageviews","columnType":"METRIC","dataType":"INTEGER"},{"name":"ga:goalCompletionsAll","columnType":"METRIC","dataType":"INTEGER"},{"name":"ga:goalConversionRateAll","columnType":"METRIC","dataType":"PERCENT"},{"name":"ga:pageviewsPerSession","columnType":"METRIC","dataType":"FLOAT"}],"totalsForAllResults":{"ga:users":"650","ga:bounces":"160","ga:sessions":"384","ga:pageviews":"788","ga:goalCompletionsAll":"5","ga:goalConversionRateAll":"1.3020833333333335","ga:pageviewsPerSession":"2.0520833333333335"},"rows":[["referral","4webmasters.org","/","/","157","160","167","175","0","0.0","1.0479041916167664"],["referral","4webmasters.org","/","/ga_c.php","1","0","0","0","0","0.0","0.0"],["referral","best-seo-offer.com","/23423/43234234/3kljsdfkel/32kjasdflkjasldflkjkj/asdflkjlkj3223kljlkjlkjasdfjk/lkjallksjdflkjlkjwelkjlkjlkjasdflkjljlkewrweasdfj209asdfkjlkjwelkjasdafdasdflkjdaosdfiowuewelkjsladijafowiejlaksdflkjlkwejoisjklewjlkjfoiewlkajlkjlasdflkjweroiujlfadslakjdksdfowielkjadlkfjlkjweoijlkjasdlfkj","/23423/43234234/3kljsdfkel/32kjasdflkjasldflkjkj/asdflkjlkj3223kljlkjlkjasdfjk/lkjallksjdflkjlkjwelkjlkjlkjasdflkjljlkewrweasdfj209asdfkjlkjwelkjasdafdasdflkjdaosdfiowuewelkjsladijafowiejlaksdflkjlkwejoisjklewjlkjfoiewlkajlkjlasdflkjweroiujlfadslakjdksdfowielkjadlkfjlkjweoijlkjasdlfkj","5","0","5","5","0","0.0","1.0"]]}';
        //Negative: Has 3 rows of query type "Lead", with the last row having a SObject field overflow, which should work on the assignment but fail on the save in the Execute phase
		//All 3 rows should fail to commit.
        public String resTest6 = '{"kind":"analytics#gaData","id":"https://www.googleapis.com/analytics/v3/data/ga?ids=ga:72882671&dimensions=ga:medium,ga:source,ga:landingPagePath,ga:pagePath&metrics=ga:users,ga:bounces,ga:sessions,ga:pageviews,ga:goalCompletionsAll,ga:goalConversionRateAll,ga:pageviewsPerSession&sort=-ga:medium&start-date=2015-05-30&end-date=2015-05-30&max-results=10000","query":{"start-date":"2015-05-30","end-date":"2015-05-30","ids":"ga:72882671","dimensions":"ga:medium,ga:source,ga:landingPagePath,ga:pagePath","metrics":["ga:users","ga:bounces","ga:sessions","ga:pageviews","ga:goalCompletionsAll","ga:goalConversionRateAll","ga:pageviewsPerSession"],"sort":["-ga:medium"],"start-index":1,"max-results":10000},"itemsPerPage":10000,"totalResults":251,"selfLink":"https://www.googleapis.com/analytics/v3/data/ga?ids=ga:72882671&dimensions=ga:medium,ga:source,ga:landingPagePath,ga:pagePath&metrics=ga:users,ga:bounces,ga:sessions,ga:pageviews,ga:goalCompletionsAll,ga:goalConversionRateAll,ga:pageviewsPerSession&sort=-ga:medium&start-date=2015-05-30&end-date=2015-05-30&max-results=10000","profileInfo":{"profileId":"72882671","accountId":"40579181","webPropertyId":"UA-40579181-1","internalWebPropertyId":"69811682","profileName":"A very long profile name intended to cause an object save exception to test exception handling in the batch Execute phase","tableId":"ga:72882671"},"containsSampledData":false,"columnHeaders":[{"name":"ga:medium","columnType":"DIMENSION","dataType":"STRING"},{"name":"ga:source","columnType":"DIMENSION","dataType":"STRING"},{"name":"ga:landingPagePath","columnType":"DIMENSION","dataType":"STRING"},{"name":"ga:pagePath","columnType":"DIMENSION","dataType":"STRING"},{"name":"ga:users","columnType":"METRIC","dataType":"INTEGER"},{"name":"ga:bounces","columnType":"METRIC","dataType":"INTEGER"},{"name":"ga:sessions","columnType":"METRIC","dataType":"INTEGER"},{"name":"ga:pageviews","columnType":"METRIC","dataType":"INTEGER"},{"name":"ga:goalCompletionsAll","columnType":"METRIC","dataType":"INTEGER"},{"name":"ga:goalConversionRateAll","columnType":"METRIC","dataType":"PERCENT"},{"name":"ga:pageviewsPerSession","columnType":"METRIC","dataType":"FLOAT"}],"totalsForAllResults":{"ga:users":"650","ga:bounces":"160","ga:sessions":"384","ga:pageviews":"788","ga:goalCompletionsAll":"5","ga:goalConversionRateAll":"1.3020833333333335","ga:pageviewsPerSession":"2.0520833333333335"},"rows":[["referral","4webmasters.org","/","/","157","160","167","175","0","0.0","1.0479041916167664"],["referral","4webmasters.org","/","/ga_c.php","1","0","0","0","0","0.0","0.0"],["referral","best-seo-offer.com","/23423/43234234/3kljsdfkel/32kjasdflkjasldflkjkj/asdflkjlkj3223kljlkjlkjasdfjk/lkjallksjdflkjlkjwelkjlkjlkjasdflkjljlkewrweasdfj209asdfkjlkjwelkjasdafdasdflkjdaosdfiowuewelkjsladijafowiejlaksdflkjlkwejoisjklewjlkjfoiewlkajlkjlasdflkjweroiujlfadslakjdksdfowielkjadlkfjlkjweoijlkjasdlfkj","/23423/43234234/3kljsdfkel/32kjasdflkjasldflkjkj/asdflkjlkj3223kljlkjlkjasdfjk/lkjallksjdflkjlkjwelkjlkjlkjasdflkjljlkewrweasdfj209asdfkjlkjwelkjasdafdasdflkjdaosdfiowuewelkjsladijafowiejlaksdflkjlkwejoisjklewjlkjfoiewlkajlkjlasdflkjweroiujlfadslakjdksdfowielkjadlkfjlkjweoijlkjasdlfkj","5","0","5","5","0","0.0","1.0"]]}';

        //Sets up mock callout responses.  
        public HTTPResponse respond(HTTPRequest req) 
        {   
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            system.debug(' ..... Request Header : Endpoint : Body: ' + req.getEndpoint() + ' : ' + req.getEndpoint() + ' : ' + req.getBody());
            res.setStatusCode(200);
            if(req.getEndpoint().contains('tokenSuccess'))
                res.setBody(resAuth);
            else if(req.getEndpoint().contains('1111111'))
                res.setBody(resTest1);
            else if(req.getEndpoint().contains('2222222'))
                res.setBody(resTest2);
            else if(req.getEndpoint().contains('3333333') || req.getEndpoint().contains('4444444'))
                res.setBody(resTest3and4);
            else if(req.getEndpoint().contains('5555555')){
                res.setBody(resTest5);
                res.setStatusCode(400);
            	}  
            else if(req.getEndpoint().contains('6666666'))
                res.setBody(resTest6);
            else if(req.getEndpoint().contains('7777777'))
                res.setBody(resTest6);             
            return res;
        }
    } 

	//Couldn't think of a strategy to combine the failure/success oAuth mock res, so created this secon
	//one to handle the failure case.    
    public class MockHttpAuthFailFactory implements HttpCalloutMock
    {
		public String resAuthFail = '{"access_token": "ya29.ngELhxoZ7u6OUwgmI9LmH6Yav8WAg9W9s1NHT2fDMh3DgvawPP-KGHLqy8yBgbvvBsPQlgb69ttFEw", "token_type": "Bearer", "expires_in": 3600}';

        public HTTPResponse respond(HTTPRequest req) 
        {   
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            if(req.getEndpoint().contains('tokenFailure'))
                res.setBody(resAuthFail);
            res.setStatusCode(400);
            return res;
        }
    }     
    
}