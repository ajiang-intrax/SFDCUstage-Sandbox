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
@isTest(seeAllData=false)
private class Test_ApplicantProductWrapper {
    static testMethod void myUnitTest1() {
        
        //Create Test data
        Account account  = new Account(Name = 'Test');
        insert account;
        
        //Contact
        Contact contact = new Contact(LastName = 'LastName', AccountId = account.Id);
        insert contact;
        
        //get Profile record
        List<Profile> profiles = [Select Id from Profile where Name = 'OCPM PT' limit 1];
        
        //Insert user
        if(profiles.size() > 0) {
        
            User user = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                    ContactId = contact.Id, Intrax_Id__c ='Test',
                                    Username = Math.random() + '@test.com');
            
            insert user;
            
            //Create a new test account and set contact as portal contact
            Account portalAccount = new Account(Name = 'TestName', Portal_Contact_Name__c = contact.Id, Type = 'Partner');
            insert portalAccount;
            
            //Fetch intract Id for this account id
            portalAccount = [Select Id, Intrax_Id__c from Account where Id =: portalAccount.Id];
        
            User sysAdmin = [select Id from User where userName = :Constants.SYS_ADMIN];
            //Run in user context
            System.runAs(sysAdmin) {
                
                //Create Test Data
                Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test', Street__c = 'test', City__c = 'test', 
                                        State__c = 'CA', Postal_Code__c = '12345',
                                        Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',
                                        Partner_Intrax_Id__c = portalAccount.Intrax_Id__c, Home_Responsibilities__c = 'Test',
                                        Application_Stage__c = 'Declined - Agent', Disabilities__c = 'No',
                                        Private_High_School_Indicated__c = 'No', Parent_Marital_Status__c = 'Other',
                                        GPA_Self_Reported__c = 'Test', Curfew_Indicated__c = 'No', Home_Type__c  = 'Test',
                                        Prior_Exchange_Experience__c = 'No', Live_With_Pets__c = 'No',
                                        Meal_Self_Sufficient__c = 'No', Special_Diet_Indicated__c = 'No',
                                        Primary_Language__c = 'English', Community_Type__c = 'Test',
                                        School_Transportation__c = 'Bus', Gender_Preference__c = 'female');
                insert appInfo;
                
                Product2 prod = new product2(name='unittest1', family = 'Academic Excellence', Description = 'Test');
                insert prod;
                
                
                //Applicant Product
                Applicant_product__c appProduct = new Applicant_product__c (Applicant_Info__c = appInfo.Id,
                                                                             Description__c = 'test', List_Price__c = 200,
                                                                             Product__c = prod.Id, Quantity__c = 2,
                                                                             Service_Date__c = System.today());
                                                                             
                //Insert Applicant Product
                insert appProduct; 
                
                //Boolean Variable
                Boolean selected = false;
                
                //Test Start From Here
                Test.startTest();
                
                //Calling Constructor
                ApplicantProductWrapper controller = new ApplicantProductWrapper(selected, appInfo, appProduct);
                
                //Test Stop Here
                Test.stopTest();
                
            }
        }
    }
    
}