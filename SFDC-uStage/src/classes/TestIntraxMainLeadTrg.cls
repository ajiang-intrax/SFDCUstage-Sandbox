/* *
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
@isTest
private class TestIntraxMainLeadTrg {

    static testMethod void Updating_Regions() {
        /* Test Case 1.1: Positive Case - European Region */
        Lead ld = new Lead(Id = null, FirstName = 'Lead_TEST', LastName = 'Tester', Lead_Type__c = 'Participant',
            Intrax_Programs__c = 'Lango', Intrax_Programs_Chgs__c = null, Projects_of_Interest_Chgs__c = null,
            Email='dlampson@intraxinc.com', Projects_of_Interest__c = 'Education', mkto2__Inferred_Country__c = 'Spain'
            );
            test.startTest();
            insert ld;
            Lead l1 = [SELECT name, Inferred_Intrax_Region__c, FirstName FROM Lead where FirstName = 'Lead_TEST'];
            system.assertEquals('Lead_TEST', l1.FirstName);
            system.assertEquals('Europe', l1.Inferred_Intrax_Region__c);
                    
            /* Test Case 1.2: Positive Case - USA Region*/
            
            Lead ld2 = new Lead(Id = null, FirstName = 'Lead_TEST2', LastName = 'Tester',
            Lead_Type__c = 'Participant',Intrax_Programs__c = 'Lango',Intrax_Programs_Chgs__c = null,
            Projects_of_Interest_Chgs__c = null,Email='dlampson@intraxinc.com', Projects_of_Interest__c = 'Education',
            mkto2__Inferred_Country__c = 'Malawi');
                        
            insert ld2;
            Lead l2 = [SELECT name, Inferred_Intrax_Region__c, FirstName FROM Lead where FirstName = 'Lead_TEST2'];
            system.assertEquals('Lead_TEST2', l2.FirstName);
            system.assertEquals('United States', l2.Inferred_Intrax_Region__c);

            /* Test Case 1.3: Positive Case - Other Region*/
            
            Lead ld3 = new Lead(Id = null, FirstName = 'Lead_TEST3', LastName = 'Tester',
            Lead_Type__c = 'Participant',Intrax_Programs__c = 'Lango',Intrax_Programs_Chgs__c = null,
            Projects_of_Interest_Chgs__c = null,Email='dlampson@intraxinc.com', Projects_of_Interest__c = 'Education',
            mkto2__Inferred_Country__c = 'Korea, Republic of');
            
            insert ld3;
            Lead l3 = [SELECT name, Inferred_Intrax_Region__c, FirstName FROM Lead where FirstName = 'Lead_TEST3'];
            system.assertEquals('Lead_TEST3', l3.FirstName);
            system.assertEquals('Korea', l3.Inferred_Intrax_Region__c);
            
            /* Test Case 2: Trying to fire the trigger twice(after the lead has been created) */
            ld.mkto2__Inferred_Country__c = null;
            ld.Country = 'China';
            
            update ld;
            Lead l4 = [SELECT name, Inferred_Intrax_Region__c, FirstName FROM Lead where FirstName = 'Lead_TEST'];
            system.assertEquals('Lead_TEST', l4.FirstName);
            system.assertEquals('Europe', l4.Inferred_Intrax_Region__c);
            
            /* Test Case 3.1: Testing the Intrax Region result if only the country has been specified - Europe Region */
            Lead ld5 = new Lead(Id = null,FirstName = 'Lead_TEST5', LastName = 'Tester',Lead_Type__c = 'Participant',
            Intrax_Programs__c = 'Lango',postalCode = '94108',Intrax_Programs_Chgs__c = null,Projects_of_Interest_Chgs__c = null,
            Email='dlampson@intraxinc.com',Projects_of_Interest__c = 'Education',Country = 'Germany');
            
            insert ld5;
            Lead l5 = [SELECT name, Inferred_Intrax_Region__c, FirstName FROM Lead where FirstName = 'Lead_TEST5'];
            system.assertEquals('Lead_TEST5', l5.FirstName);
            system.assertEquals('Europe', l5.Inferred_Intrax_Region__c);
            
            /* Test Case 3.2: Testing the Intrax Region result if only the country has been specified - USA Region */
            Lead ld6 = new Lead(Id = null,FirstName = 'Lead_TEST6', LastName = 'Tester',Lead_Type__c = 'Participant',
            Intrax_Programs__c = 'Lango',postalCode = '94108',Intrax_Programs_Chgs__c = null,Projects_of_Interest_Chgs__c = null,
            Email='dlampson@intraxinc.com',Projects_of_Interest__c = 'Education',Country = 'Martinique');
            
            insert ld6;
            Lead l6 = [SELECT name, Inferred_Intrax_Region__c, FirstName FROM Lead where FirstName = 'Lead_TEST6'];
            system.assertEquals('Lead_TEST6', l6.FirstName);
            system.assertEquals('United States', l6.Inferred_Intrax_Region__c);
            
            /* Test Case 3.3: Testing the Intrax Region result if only the country has been specified - Canada */
            Lead ld13 = new Lead(Id = null,FirstName = 'Lead_TEST13', LastName = 'Tester',Lead_Type__c = 'Participant',
            Intrax_Programs__c = 'Lango',postalCode = '94108',Intrax_Programs_Chgs__c = null,Projects_of_Interest_Chgs__c = null,
            Email='dlampson@intraxinc.com',Projects_of_Interest__c = 'Education',Country = 'Canada');
            
            insert ld13;
            Lead l13 = [SELECT name,Inferred_Intrax_Region__c, FirstName FROM Lead where FirstName = 'Lead_TEST13'];
            system.assertEquals('Lead_TEST13', l13.FirstName);
            system.assertEquals('Canada', l13.Inferred_Intrax_Region__c);
            
            /* Test Case 3.4: Testing the Intrax Region result if only the country has been specified - Peru */
            Lead ld14 = new Lead(Id = null,FirstName = 'Lead_TEST14', LastName = 'Tester',Lead_Type__c = 'Participant',
            Intrax_Programs__c = 'Lango',postalCode = '94108',Intrax_Programs_Chgs__c = null,Projects_of_Interest_Chgs__c = null,
            Email='dlampson@intraxinc.com',Projects_of_Interest__c = 'Education',Country = 'Peru');
            
            insert ld14;
            Lead l14 = [SELECT name,Inferred_Intrax_Region__c, FirstName FROM Lead where FirstName = 'Lead_TEST14'];
            system.assertEquals('Lead_TEST14', l14.FirstName);
            system.assertEquals('Peru', l14.Inferred_Intrax_Region__c);
            
            /* Test Case 3.5: Testing the Intrax Region result if only the country has been specified - Chile */
            Lead ld15 = new Lead(Id = null,FirstName = 'Lead_TEST15', LastName = 'Tester',Lead_Type__c = 'Participant',
            Intrax_Programs__c = 'Lango',postalCode = '94108',Intrax_Programs_Chgs__c = null,Projects_of_Interest_Chgs__c = null,
            Email='dlampson@intraxinc.com',Projects_of_Interest__c = 'Education',Country = 'Chile');
            
            insert ld15;
            Lead l15 = [SELECT name,Inferred_Intrax_Region__c, FirstName FROM Lead where FirstName = 'Lead_TEST15'];
            system.assertEquals('Lead_TEST15', l15.FirstName);
            system.assertEquals('Chile', l15.Inferred_Intrax_Region__c);
            
            /* Test Case 3.6: Testing the Intrax Region result if only the country has been specified - Japan */
            Lead ld7 = new Lead(Id = null,FirstName = 'Lead_TEST7', LastName = 'Tester',Lead_Type__c = 'Participant',
            Intrax_Programs__c = 'Lango',postalCode = '94108',Intrax_Programs_Chgs__c = null,Projects_of_Interest_Chgs__c = null,
            Email='dlampson@intraxinc.com',Projects_of_Interest__c = 'Education',Country = 'Japan');
            
            insert ld7;
            Lead l7 = [SELECT name,Inferred_Intrax_Region__c, FirstName FROM Lead where FirstName = 'Lead_TEST7'];
            system.assertEquals('Lead_TEST7', l7.FirstName);
            system.assertEquals('Japan', l7.Inferred_Intrax_Region__c);
            
            /* Test Case 4.1: Testing the Intrax Region result if only the CITIZENSHIP has been specified - European Region */
            Lead ld8 = new Lead(Id = null,FirstName = 'Lead_TEST8', LastName = 'Tester',Lead_Type__c = 'Participant',
            Intrax_Programs__c = 'Lango',postalCode = '94108',Intrax_Programs_Chgs__c = null,Projects_of_Interest_Chgs__c = null,
            Email='dlampson@intraxinc.com', Projects_of_Interest__c = 'Education',Citizenship__c = 'Austria');
            
            insert ld8;
            Lead l8 = [SELECT name,Inferred_Intrax_Region__c, FirstName FROM Lead where FirstName = 'Lead_TEST8'];
            system.assertEquals('Lead_TEST8', l8.FirstName);
            system.assertEquals('Europe', l8.Inferred_Intrax_Region__c);
            
            /* Test Case 4.2: Testing the Intrax Region result if only the CITIZENSHIP has been specified - USA Region */
            Lead ld9 = new Lead(Id = null,FirstName = 'Lead_TEST9', LastName = 'Tester',Lead_Type__c = 'Participant',
            Intrax_Programs__c = 'Lango',postalCode = '94108',Intrax_Programs_Chgs__c = null,Projects_of_Interest_Chgs__c = null,
            Email='dlampson@intraxinc.com', Projects_of_Interest__c = 'Education',Citizenship__c = 'Argentina');
            
            insert ld9;
            Lead l9 = [SELECT name, Inferred_Intrax_Region__c, FirstName FROM Lead where FirstName = 'Lead_TEST9'];
            system.assertEquals('Lead_TEST9', l9.FirstName);
            system.assertEquals('United States', l9.Inferred_Intrax_Region__c);
            
            /* Test Case 4.3: Testing the Intrax Region result if only the CITIZENSHIP has been specified - Canada */
            Lead ld16 = new Lead(Id = null,FirstName = 'Lead_TEST16',   LastName = 'Tester',Lead_Type__c = 'Participant',
            Intrax_Programs__c = 'Lango',postalCode = '94108',Intrax_Programs_Chgs__c = null,Projects_of_Interest_Chgs__c = null,
            Email='dlampson@intraxinc.com', Projects_of_Interest__c = 'Education',Citizenship__c = 'Canada');
            
            insert ld16;
            Lead l16 = [SELECT name, Inferred_Intrax_Region__c, FirstName FROM Lead where FirstName = 'Lead_TEST16'];
            system.assertEquals('Lead_TEST16', l16.FirstName);
            system.assertEquals('Canada', l16.Inferred_Intrax_Region__c);
            
            /* Test Case 4.3: Testing the Intrax Region result if only the CITIZENSHIP has been specified */
            Lead ld10 = new Lead(Id = null,FirstName = 'Lead_TEST10',   LastName = 'Tester',Lead_Type__c = 'Participant',
            Intrax_Programs__c = 'Lango',postalCode = '94108',Intrax_Programs_Chgs__c = null,Projects_of_Interest_Chgs__c = null,
            Email='dlampson@intraxinc.com', Projects_of_Interest__c = 'Education',Citizenship__c = 'Japan');
            
            insert ld10;
            Lead l10 = [SELECT name, Inferred_Intrax_Region__c, FirstName FROM Lead where FirstName = 'Lead_TEST10'];
            system.assertEquals('Lead_TEST10', l10.FirstName);
            system.assertEquals('Japan', l10.Inferred_Intrax_Region__c);
            
            /* Test Case 5.1: Testing the Intrax Region result if only the INTRAX_COUNTRY has been specified INCORRECTLY */
            Lead ld11 = new Lead(Id = null,FirstName = 'Lead_TEST11',   LastName = 'Tester',Lead_Type__c = 'Participant',
            Intrax_Programs__c = 'Lango',postalCode = '94108',Intrax_Programs_Chgs__c = null,Projects_of_Interest_Chgs__c = null,
            Email='dlampson@intraxinc.com', Projects_of_Interest__c = 'Education', Country = 'Japana');
            
            insert ld11;
            Lead l11 = [SELECT name, Inferred_Intrax_Region__c, FirstName FROM Lead where FirstName = 'Lead_TEST11'];
            system.assertEquals('Lead_TEST11', l11.FirstName);
            system.assertEquals('Japan', l11.Inferred_Intrax_Region__c);
            
            /* Test Case 5.2: Testing the Intrax Region result if INTRAX_COUNTRY == Russia */
            Lead ld12 = new Lead(Id = null,FirstName = 'Lead_TEST12',   LastName = 'Tester',Lead_Type__c = 'Participant',
            Intrax_Programs__c = 'Lango',postalCode = '94108',Intrax_Programs_Chgs__c = null,Projects_of_Interest_Chgs__c = null,
            Email='dlampson@intraxinc.com', Projects_of_Interest__c = 'Education', Country = 'Russia'
            );
            
            insert ld12;
            Lead l12 = [SELECT name, Inferred_Intrax_Region__c, FirstName FROM Lead where FirstName = 'Lead_TEST12'];
            system.assertEquals('Lead_TEST12', l12.FirstName);
            system.assertEquals('United States', l12.Inferred_Intrax_Region__c);
            test.stopTest(); 
    }
 
    static testMethod void update_IntraxPrograms() {
        // TO DO: implement unit test
        String newIntrax_Programs;
        Lead lead; 
        
        lead = new Lead(lastname='TEST_D',firstname='ATF-justacct',
                                     postalcode='09999', Phone='1112223333', Lead_Type__c='Participant', 
                                     Intrax_Programs__c='Ayusa;Lango', Intrax_Program_Options__c = 'Business English',
                                     email='dlampson@intraxinc.com');
                                     
        insert lead;                                                         
        lead.Intrax_Programs__c = 'Ayusa;Lango;AuPairCare';
        lead.Intrax_Program_Options__c = 'Business English;Cambridge Test Prep';
        //------------------- Running as User 1 --------------------'
        //User u1 = [SELECT Id FROM User WHERE UserName = 'marketosfdc@intraxinc.com'];
       // System.runAs(u1){
            update lead;
            System.assertEquals('Ayusa;Lango;AuPairCare', lead.Intrax_Programs__c); 
            System.assertEquals('Business English;Cambridge Test Prep', lead.Intrax_Program_Options__c);    
            lead.Intrax_Programs__c = 'Ayusa';
            lead.Intrax_Program_Options__c = 'Cambridge Test Prep';
            update lead;
            System.assertEquals('Ayusa', lead.Intrax_Programs__c);
            System.assertEquals('Cambridge Test Prep', lead.Intrax_Program_Options__c); 
        //}
        lead.Intrax_Programs__c = 'Ayusa;Lango';
        lead.Intrax_Program_Options__c = 'Cambridge Test Prep; Camp Lango';
        //'------------------- Running as User 2 --------------------'
        Profile p = [SELECT ID FROM Profile Where Name = 'System Administrator'];
        User u2 = [SELECT Id FROM User WHERE profileId =: p.Id AND isActive =: true LIMIT 1];
        System.runAs(u2){
            update lead;
            System.assertEquals('Ayusa;Lango', lead.Intrax_Programs__c);    
            System.assertEquals('Cambridge Test Prep; Camp Lango', lead.Intrax_Program_Options__c);
        }                        
    }
    
    static testMethod void test_baseURL(){
        
        //Case 1.1 - http://www.google.com/asf?asdf
        Lead l1 = new Lead(lastname='TEST_D',firstname='ATF-justacct',
                                     postalcode='09999', Phone='1112223333', Lead_Type__c='Participant', 
                                     Intrax_Programs__c='Ayusa;Lango', Intrax_Program_Options__c = 'Business English',
                                     email='dgutierrezcodina@intraxinc.com', 
                                     mkto2__Original_Referrer__c = 'http://www.google.com/asf?asdf');
        insert l1;
        
        Lead ln1 = [SELECT Original_Referrer_BaseURL__c FROM Lead where id =: l1.Id];
        system.assertEquals('www.google.com', ln1.Original_Referrer_BaseURL__c);
        
        //Case 1.2 - google.com/asf?asdf
        Lead l2 = new Lead(lastname='TEST_D',firstname='ATF-justacct',
                                     postalcode='09999', Phone='1112223333', Lead_Type__c='Participant', 
                                     Intrax_Programs__c='Ayusa;Lango', Intrax_Program_Options__c = 'Business English',
                                     email='dgutierrezcodina@intraxinc.com', 
                                     mkto2__Original_Referrer__c = 'google.com/asf?asdf');
        insert l2;
        
        Lead ln2 = [SELECT Original_Referrer_BaseURL__c FROM Lead where id =: l2.Id];
        system.assertEquals('google.com', ln2.Original_Referrer_BaseURL__c);

        //Case 1.3 - www.google.com?asf/asdf
        Lead l3 = new Lead(lastname='TEST_D',firstname='ATF-justacct',
                                     postalcode='09999', Phone='1112223333', Lead_Type__c='Participant', 
                                     Intrax_Programs__c='Ayusa;Lango', Intrax_Program_Options__c = 'Business English',
                                     email='dgutierrezcodina@intraxinc.com', 
                                     mkto2__Original_Referrer__c = 'www.google.com?asf/asdf');
        insert l3;
        
        Lead ln3 = [SELECT Original_Referrer_BaseURL__c FROM Lead where id =: l3.Id];
        system.assertEquals('www.google.com', ln3.Original_Referrer_BaseURL__c);
    }
}