/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest(SeeAllData=true)
private class Test_RankingMatchController {
/*
    Purpose         :   Test class for RankingtchController.
               
    Created Date    :   06/06/2012
    
    Current Version :   v1.0
    
    Revision Log    :   V_1.1 Created
*/
    static testMethod void myUnitTest_APC() {
        //start testing from here
        Test.startTest();
        
        //Fetch record type Id from database of Type Business Account
        List<RecordType> hostRecordType = [Select Id from RecordType where DeveloperName = 'AuPairCare_HF' AND SObjectType = 'Account' AND IsActive = true ];
        List<RecordType> participantRecordType = [Select Id from RecordType where DeveloperName = 'Participant' AND IsPersonType = true AND SObjectType = 'Account' AND IsActive = true ];
        
        //check for the record type size 
        if(hostRecordType.size() > 0 && participantRecordType.size() > 0) {
            //Create a host company record
            Account hostFamily = new Account(FirstName = 'TestHost - Family', LastName = 'Test', gender__pc = 'Female', PersonEmail='test@test.com', RecordTypeId = hostRecordType[0].Id, Type = 'Host Family');
            insert hostFamily;
            
            Member__c spouse = new Member__c(Name = 'Spouse', Role__c = 'Spouse or Partner', Account_Name__c = hostFamily.Id, Gender__c = 'Female');
            insert spouse;
            Member__c child1 = new Member__c(Name = 'Child1', Role__c = 'Child', Special_Needs_Indicated__c = 'Yes', Account_Name__c = hostFamily.Id, Date_of_Birth__c = (date.today() - 300));
            insert child1;
            
            //Insert Host Opportunity
            Engagement__c PTEngagement = new Engagement__c(Name = 'TestHost - Opp', Status__c = 'Test',Placement_Status__c = 'Not Placed' ,
                                                            Intrax_Program__c = 'AuPairCare', Engagement_Start__c = date.today(), 
                                                            Engagement_End__c = date.today().addDays(30));
            insert PTEngagement;
            
            //Insert Position Instance
            Position__c position = new Position__c(Name = 'TestPosition', Host_Company_ID__c = hostFamily.Id, 
                                                    Intrax_Program__c = 'AuPairCare', Engagement_Start__c = date.today(),
                                                    Engagement_End__c = date.today().addDays(15), 
                                                    Pets__c = 'Yes', Pet_Types__c ='Dog;Cat');
            
            insert position;
                     
            //Create test data
            List<Account> listAccount = new List<Account>();
            
            //insert in list
            for(Integer i = 0; i < 20; i++) {
                listAccount.add(new Account(LastName = 'Test' + i, RecordTypeId = participantRecordType[0].Id, PersonEmail = 'test@test.com',
                                            Type = 'Participant', Status__c = 'Prospect'));
            }
            
            //insert data in bulk 
            insert listAccount;
            
            //Create list of opportunities
            List<Engagement__c> listEngagement = new List<Engagement__c>();
            
            //insert in list
            for(Account acc : listAccount) {
                listEngagement.add(new Engagement__c(Name = 'Test', Type__c='Participant',status__c='On Program', Account_Id__c = acc.Id,Placement_Status__c = 'Not Placed' ,
                                                    Intrax_Program__c = 'AuPairCare',Engagement_Start__c = date.today().addDays(-15),Engagement_End__c = date.today().addDays(35)));
            }
            
            insert listEngagement;
            
            Position__c positionDummy = new Position__c();
            
            //instantiate controller 
            RankingController controller = new RankingController(new ApexPages.StandardController(position));
            
            //RankingController controller1 = new RankingController(new ApexPages.StandardController(position1));
            //Set program options
            positionDummy = controller.getDummyObj();
            
            list<SelectOption> GenderPref=controller.GenderPref;
            list<SelectOption> Nationality = controller.Nationality;
            list<SelectOption> lstLangs = controller.lstLangs;
            list<SelectOption> ageOptions = controller.apc_ageOptions;
            list<SelectOption> diets = controller.apc_specialDiet;
            list<SelectOption> hobbies = controller.hobbiesOptions;
            list<SelectOption> experienceAges = controller.ExperienceAgesOptions;
            list<SelectOption> experienceTypes = controller.ExperienceTypeOptions;
            
            controller.PositionEngagementStart = date.today() + 10;
            controller.PositionEngagementEnd = date.today() + 100;
            
            
            controller.swimmersSelected = 'true';
            controller.DrivingLicenseIndicated = 'true';
            controller.specialNeedsIndicated = 'Circulate SN';
            controller.inCountrySelected = 'false';
            controller.infantSpecializedSelected = 'true';
            controller.firstname = 'Test';
            controller.lastName = 'Test';
            controller.inCountrySelected = 'true';
            controller.HobbiesSelected = new list<String>{'Soccer'};
            controller.specialDietSelected = new list<String>{'Diabetic'};
            controller.selectGenderPref = 'Female';
            controller.selectNationality = new list<String>{'Spanish'};
            controller.selectLangs = new list<String>{'Spanish'};
            controller.selectAgeRange = '19';
            controller.experienceAgesSelected = new list<String>{'0 - 1'};
            controller.experienceTypeSelected = new list<String>{'Camp'};
            
            

            //controller.inItAPC();
            
            //Call method manually as webservice can not be hit through test method
            controller.mapOfListEngagementWrapper = new Map<Integer, List<EngagementWrapper>>();
            controller.mapOfListEngagementWrapper.put(1, new List<EngagementWrapper>{new EngagementWrapper(new Engagement__c(), 1, 1)});
            
            //Call method
            controller.sortDir = 'ASC';
            //controller.sortResults();
            
            //select records in list
            //controller.getNext();
            //controller.getPrevious();
            
            for(Integer i = 0; i < controller.resultsStopNumber; i++)
                controller.getPossibleMatchesList()[i].selected = true;
            
            controller.save();
            
            //stop test here
            Test.stopTest();
        }
    }
    
    static testMethod void myUnitTest() {
        //start testing from here
        Test.startTest();
        
        //Fetch record type Id from database of Type Business Account
        List<RecordType> hostRecordType = [Select Id from RecordType where DeveloperName = 'Host_Company' AND IsPersonType = false AND SObjectType = 'Account' AND IsActive = true ];
        List<RecordType> participantRecordType = [Select Id from RecordType where DeveloperName = 'Participant' AND IsPersonType = true AND SObjectType = 'Account' AND IsActive = true ];
        
        //check for the record type size 
        if(hostRecordType.size() > 0 && participantRecordType.size() > 0) {
            //Create a host company record
            Account hostCompany = new Account(Name = 'TestHost - Company', RecordTypeId = hostRecordType[0].Id);
            insert hostCompany;
           
            //Insert Host Opportunity
            Engagement__c hostEngagement = new Engagement__c(Name = 'TestHost - Opp', Account_Id__c = hostCompany.Id, Status__c = 'Test',Placement_Status__c = 'Not Placed' ,
                                                            Intrax_Program__c = 'Internship', Engagement_Start__c = date.today(), Engagement_End__c = date.today().addDays(15));
            insert hostEngagement;
            //Insert Position Instance
            Position__c position = new Position__c(Name = 'TestPosition', Host_Company_ID__c = hostCompany.Id, 
                                                    Intrax_Program__c = 'Internship', Engagement_Start__c = date.today(),Engagement_End__c = date.today().addDays(15) );
            
            insert position;
             Position__c position1 = new Position__c(Name = 'TestPosition1', Host_Company_ID__c = hostCompany.Id, 
                                                    Intrax_Program__c = 'Ayusa', Engagement_Start__c = date.today(),Engagement_End__c = date.today().addDays(15) );
            
            insert position1;
            
           
            //Create test data
            List<Account> listAccount = new List<Account>();
            
            //insert in list
            for(Integer i = 0; i < 20; i++) {
                listAccount.add(new Account(LastName = 'Test' + i, RecordTypeId = participantRecordType[0].Id, PersonEmail = 'test@test.com',
                                            Type = 'Participant', Status__c = 'Prospect'));
            }
            
            //insert data in bulk 
            insert listAccount;
            
            //Create list of opportunities
            List<Engagement__c> listEngagement = new List<Engagement__c>();
            
            //insert in list
            for(Account acc : listAccount) {
                listEngagement.add(new Engagement__c(Name = 'Test', Type__c='Participant',status__c='On Program', Account_Id__c = acc.Id,Placement_Status__c = 'Not Placed' ,
                                                    Intrax_Program__c = 'Internship',Engagement_Start__c = date.today().addDays(-15),Engagement_End__c = date.today().addDays(35)));
            }
            
            insert listEngagement;
             Position__c positionDummy = new Position__c();
            //instantiate controller 
            RankingController controller = new RankingController(new ApexPages.StandardController(position));
              RankingController controller1 = new RankingController(new ApexPages.StandardController(position1));
            //Set program options
            positionDummy = controller.getDummyObj();
            List<SelectOption> programOptions = controller.programOptions;
            List<SelectOption> langLevel = controller.langLevel;
            List<SelectOption> langLevelList = controller.lstlangLevel;
            List<SelectOption> serviceLevel = controller.lstserviceLevel;
            List<SelectOption> religionList = controller.Religion;
            List<SelectOption> programDuration = controller.ProgramDuration;
            List<SelectOption> IntraxProgCat = controller.lstIntraxProgCategory;
            List<SelectOption> PrepRating = controller.PrepRating;
            List<SelectOption> lstCitizenship = controller.lstCitizenship;
            List<SelectOption> CompType = controller.CompType;
            List<SelectOption> lstLangs = controller.lstLangs;
            List<SelectOption> lstFuncAreas = controller.lstFuncAreas;
            List<SelectOption> lstEduGrade= controller.lstEduGrade;
            List<SelectOption> lstAgeRange =controller.lstAgeRange;
            List<SelectOption> PositionType=controller.PositionType;
            List<SelectOption> ProgDuration=controller1.ProgDuration;
             List<SelectOption> lstAges=controller1.lstAges;
              List<SelectOption> GenderPref=controller1.GenderPref;
               List<SelectOption> Categories=controller1.Categories;
                List<SelectOption> SmokerFamily=controller1.SmokerFamily;
                 List<SelectOption> Interests=controller1.Interests;
                  List<SelectOption> Pets=controller1.Pets;
                   List<SelectOption> PersonalityRating=controller1.PersonalityRating;
                    List<SelectOption> AyusaProgramOptions=controller1.AyusaProgramOptions;
                     List<SelectOption> lstSpecialDiet=controller1.lstSpecialDiet;
                      List<SelectOption> lstSnk=controller1.lstSNK;
                      List<SelectOption> TuitionRange=controller1.TuitionRange;
                      List<SelectOption> lstNationality=controller1.Nationality;
                      List<SelectOption> lstDPIndicated=controller1.lstDPIndicated;
                      List<SelectOption> lstIntCountries=controller1.lstIntCountries;
                      List<SelectOption> lstLangSpoken=controller1.lstLangSpoken;
                     // List<String> AgeRange = controller1.selectAgeRanges;
                    
            controller.inItIntern();
            controller.inItAyusa();
            
            //Call method manually as webservice can not be hit through test method
            controller.mapOfListEngagementWrapper = new Map<Integer, List<EngagementWrapper>>();
            controller.mapOfListEngagementWrapper.put(1, new List<EngagementWrapper>{new EngagementWrapper(new Engagement__c(), 1, 1)});
            
            //Call method
            controller.sortDir = 'ASC';
            controller.sortResults();
            
            //select records in list
            controller.getNext();
            controller.getPrevious();
            
            for(Integer i = 0; i < controller.resultsStopNumber; i++)
                controller.getPossibleMatchesList()[i].selected = true;
            //controller.save();
            
            //Search functionality
            controller.selectProgramOption = 'Test-Unique';
            controller.selectlangLevel = '5';
            controller.selectCitizenships.add('Bahamas');
            controller.interest = 'Test';
            controller.selectPrepRating = '3';   
            controller.selectAges = new list<String>{'15'};        
            //controller.selectProgramOption = 'Test-Unique';
            // controller.selectProgramOption = 'Test-Unique';
            controller.inItIntern();
            
             //Call method manually as webservice can not be hit through test method
            controller1.mapOfListEngagementWrapper = new Map<Integer, List<EngagementWrapper>>();
            controller1.mapOfListEngagementWrapper.put(1, new List<EngagementWrapper>{new EngagementWrapper(new Engagement__c(), 1, 1)});
            
            //Call method
            controller1.sortDir = 'ASC';
           // controller1.sortResults();
            
            //select records in list
           // controller1.getNext();
            //controller1.getPrevious();
            
            for(Integer i = 0; i < controller1.resultsStopNumber; i++)
                controller1.getPossibleMatchesList()[i].selected = true;
           // controller1.save();
            
            //Search functionality
            controller1.selectGenderPref = 'Yes';
            controller1.selectAyusaProgramOptions.add('Yes');
            controller1.selectNationalPreferences.add('Bahamas');
            controller1.selectInterests.add('Test');
            controller1.selectLanguagesSpoken.add('English');
            controller1.selectPartner = 'abc';
            controller1.selectIntCountries.add('abc');
           // controller1.selectAgeRanges.add('1');
            //controller.selectProgramOption = 'Test-Unique';
           // controller.selectProgramOption = 'Test-Unique';
            controller1.inItAyusa();
            
            
            
            
            
            controller.selectProgramOption = 'Hospitality Internship';
            controller.selectlangLevel = '5';
            controller.selectCitizenships.add('Bahamas');
            controller.interest = 'Test';
            controller.selectPrepRating = '3';
            controller.selectEduGrade='Post Graduate';
            controller.selectPositionTypes.add('Business Management');
            controller.selectPartner='Test';
             controller.selectLangs.add('--None--');
              controller.selectIntCountries.add('--None--');
              controller.selectAreas.add('--None--');
              controller.selectPositionTypes.add('--None--');
              
            controller.inItIntern();
            
           controller.selectProgramOption = 'Business Internship';
            controller.selectlangLevel = '1';
            controller.selectCitizenships.add('Bahamas');
            controller.interest = 'Test';
            controller.selectPrepRating = '3';
            controller.selectEduGrade='Sophomore';
            controller.selectAreas.add('Marketing');
            controller.inItIntern();
            
            controller.selectProgramOption = 'Summer Entrepreneurship';
            controller.selectlangLevel = '1';
            controller.selectCitizenships.add('Bahamas');
            controller.interest = 'Test';
            controller.selectPrepRating = '3';
            controller.selectEduGrade='Sophomore';
            controller.selectAreas.add('Marketing');
            controller.inItIntern();
            
            controller.selectProgramOption = 'WEST';
            controller.selectlangLevel = '1';
            controller.selectCitizenships.add('Bahamas');
            controller.interest = 'Test';
            controller.selectPrepRating = '3';
            controller.selectEduGrade='Sophomore';
            controller.selectAreas.add('Marketing');
            controller.inItIntern();
            
             controller.selectProgramOption = 'Test-Unique';
            controller.selectlangLevel = '2';
            controller.selectCitizenships.add('Bahamas');
            controller.interest = 'Test';
            controller.selectPrepRating = '3';
            controller.selectEduGrade='Freshman';
            controller.selectAgeRange='>30';
            controller.inItIntern();
            
            controller.selectProgramOption = 'Test-Unique';
            controller.selectlangLevel = '2';
            controller.selectCitizenships.add('--None--');
            controller.interest = 'Test';
            controller.selectPrepRating = '3';
            controller.selectEduGrade='Senior';
            controller.inItIntern();
            
            controller.selectProgramOption = 'Test-Unique';
            controller.selectlangLevel = '4';
            controller.selectCitizenships.add('--None--');
            controller.interest = 'Test';
            controller.selectPrepRating = '3';
            controller.selectPersRating ='5';
            controller.selectExpRating ='7';
            controller.selectExpRating ='7';
            controller.schoolName='Test';
            controller.major='Test';
            controller.selectEduGrade='Junior';
            controller.selectAgeRange='18-20';
            controller.selectLangs.add('Chinese');
            controller.selectCompType='Hourly';
            controller.selectAreas.add('Accounting');
            
           
            controller.inItIntern();
            //Coverage for Opportunity Wrapper
            EngagementWrapper eWrapper = new EngagementWrapper(new Engagement__c());
            System.assert(!eWrapper.selected);
            System.assert(eWrapper.engagement != null);
            
            //Create a instance of Result Set manually 
            wwwIntraxincComMatchRanking.resultSet resultSet = new wwwIntraxincComMatchRanking.resultSet();
            wwwIntraxincComMatchRanking.result res = new wwwIntraxincComMatchRanking.result();
            wwwIntraxincComMatchRanking.attribute attribute = new wwwIntraxincComMatchRanking.attribute();
            attribute.Id = 1;
            
            res.attributes = new List<wwwIntraxincComMatchRanking.attribute>();
            res.attributes.add(attribute);
            resultSet.list_x = new List<wwwIntraxincComMatchRanking.result>();
            resultSet.list_x.add(res);
            
            RankingMatchUtility.mapEngagementWithIds = new Map<Integer, Engagement__c>{1 => new Engagement__c()};
            Map<Integer, List<EngagementWrapper>> mapResult = RankingMatchUtility.parseResponseForEng(resultSet);
            
            RankingMatchUtility.prepareEntityProps(position1);
            RankingMatchUtility.prepareEntityProps(hostEngagement);
            RankingMatchUtility.prepareHFPositionProps(position1);
            List<Engagement__c> engList = new List<Engagement__c>();
            engList.add(hostEngagement);
            RankingMatchUtility.prepareCandidateList(engList);
            //Opportunity
            List<Opportunity> listOpp = new List<Opportunity>();
             for(Account acc : listAccount) {
                listOpp.add(new Opportunity(Name = 'Test Opportunity 1', Intrax_Programs__c = 'Ayusa', Intrax_Program_Options__c = 'YES', 
                                                    Intrax_Region__c = 'United States', PAX__c = 1, CloseDate = System.today().addDays(10),
                                                    StageName = 'Prospecting', AccountId = acc.Id, Program_Year__c = '2013',
                                                    Agreement_Status__c = 'No Agreement', Job_Desc_Status__c = 'Not Started'));
             }
            insert listOpp;
        
        
        
            RankingMatchUtility.prepareCandidateList(listOpp);
            RankingMatchUtility.prepareEngagementList(engList);
            List<Position__c> posList = new List<Position__c>();
            posList.add(position1);
            RankingMatchUtility.preparePositionList(posList);
           // RankingMatchUtility.getISOCodesByCountries('United States');
            
                        //Assert for the result
            System.assertEquals(1, mapResult.size());
            
            //stop test here
            Test.stopTest();
        }
    }
}