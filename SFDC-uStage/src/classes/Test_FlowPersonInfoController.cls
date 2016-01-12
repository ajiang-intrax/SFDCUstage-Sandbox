@isTest(seeAllData=false)
private class Test_FlowPersonInfoController{

    static testMethod void myUnitTest() {
    	//Applicant Info
        Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-AY', Street__c = 'test', City__c = 'test', Meal_Self_Sufficient__c = 'No',
                                                          Postal_Code__c = '12345',  Type__c = 'Participant', Home_Type__c = 'Duplex',
                                                          Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',
                                                          Home_Responsibilities__c = 'Test',
                                                          Application_Stage__c = 'Submitted', Disabilities__c = 'No', Submitted__c = true,
                                                          Community_Type__c ='Urban', Private_High_School_Indicated__c = 'No', State__c = 'CA', 
                                                          Parent_Marital_Status__c = 'Other', GPA_Self_Reported__c = 'Test', 
                                                          Curfew_Indicated__c = 'No', 
                                                          Special_Diet_Indicated__c = 'No', 
                                                          Prior_Exchange_Experience__c = 'No', Live_With_Pets__c = 'No', 
                                                          Primary_Language__c = 'English', School_Transportation__c = 'Bus', 
                                                          Engagement_Start__c = System.today(), Program_Duration__c = '1-3 Weeks',
                                                          Accommodation_Preference__c = 'Homestay', Program_Year__c  = '2013',
                                                          Gender_Preference__c = 'female', Study_Weeks__c = 1, Application_Level__c ='Main', 
                                                          Program_Start_Opinion__c = 'YES', Intrax_Program__c = 'Ayusa', 
                                                          Intrax_Program_Options__c = 'YES');
        insert appInfo;
        
        //Personal Info
        Person_Info__c personInfo = new Person_Info__c(Primary_Applicant__c = true, Family_Member__c = true,
                                            First_Name__c  = UserInfo.getFirstName(), Gender__c = 'Male',
                                            Applicant_Info__c = appInfo.Id, Emergency_Contact_Indicated__c = 'Yes',
                                            Birth_City__c = 'Test', Last_Name__c = 'Test', Role__c ='EmergencyContact',
                                            Date_of_Birth__c = date.newInstance(1980, 2, 17) );
        insert personInfo;
        
    	ApexPages.StandardController sc = new ApexPages.StandardController(personInfo);
    	ApexPages.CurrentPage().getParameters().put('persId', personInfo.Id);
     	FlowPersonInfoController pic = new FlowPersonInfoController(sc);
     	pic.getFinishPage();
     	pic.DeclineReference();
    }
    
}