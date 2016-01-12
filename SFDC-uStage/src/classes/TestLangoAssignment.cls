/*
 * This class contains unit tests for validating the behavior of the LangoLeadAssignment
 * trigger and related classes.
 *
 * Generally, test data is created within the class.  However, the tests are dependent on
 * the following:
 *
 * Email Template:  Visualforce email template named Lango_Lead_to_Franchise_VFT
 *
 * Org Wide Email Address:  Lango Team
 *
 * 
 */
@isTest
private class TestLangoAssignment {

    static testMethod void testAssignToFranchise(){

        //First, create a Franchise test Account
        /*Account acct = new Account(name='ApexTest Lango Franchise', Phone='4445556666', 
                                   Intrax_Programs__c='Ayusa;Lango;', Type='Franchise',
                                   Inception_Date__c = date.today().addMonths(-6), 
                                   Termination_Date__c = date.today().addMonths(6) );
        insert acct;
        acct = [SELECT Id, Name, Territory_Codes__c, Intrax_Programs__c 
                FROM Account WHERE Name = 'ApexTest Lango Franchise'];
        System.assertEquals('ApexTest Lango Franchise', acct.Name);
        System.assertNotEquals(null, acct.Id);
        System.assertEquals('Ayusa;Lango', acct.Intrax_Programs__c);
        
        //Case1:  Account, but no Territory_Codes__c values, and Account has no Contacts
        Lead leadAcctOnly = new Lead(lastname='ATF-test',firstname='ATF-justacct',
                                     postalcode='09999', Phone='1112223333', Lead_Type__c='Participant', 
                                     Intrax_Programs__c='Ayusa;Lango;', email='dlampson@intraxinc.com');
        insert leadAcctOnly;
        Lead atfLead = [SELECT Id, Lead_Type__c, Status, PostalCode, Route_to_Franchise__c, 
                            Description, Intrax_Programs__c 
                        FROM Lead WHERE lastname = 'ATF-test' AND firstname = 'ATF-justacct'];
        System.assertEquals('Participant', atfLead.Lead_Type__c);
        System.assertEquals('Open - New', atfLead.Status);
        System.assertEquals('09999', atfLead.PostalCode);
        System.assertEquals('Ayusa;Lango', atfLead.Intrax_Programs__c);
        System.assertEquals(true, atfLead.Route_to_Franchise__c);   
        Task noFranchiseTask = [SELECT Description FROM Task WHERE WhoId = :atfLead.Id]; 
        System.assertEquals('System Task: Failed.  Tried to assign Lead to Franchise, but no Franchisee or Sales Contact for postal code 09999', noFranchiseTask.Description);

        //Case 2: Force update and Verify still unrouted
        atfLead.Description = 'Case2';
        update atfLead;
        Lead uAtfLead = [SELECT Id, Lead_Type__c, Status, PostalCode, Route_to_Franchise__c, Description 
                         FROM Lead 
                         WHERE lastname = 'ATF-test' AND firstname = 'ATF-justacct'];
        System.assertEquals('Participant', uAtfLead.Lead_Type__c);
        System.assertEquals('Open - New', uAtfLead.Status);
        System.assertEquals('09999', uAtfLead.PostalCode);
        System.assertEquals(true, uAtfLead.Route_to_Franchise__c);   
        Task uNoFranchiseTask = [SELECT Description FROM Task WHERE WhoId = :uatfLead.Id]; 
        System.assertEquals('System Task: Failed.  Tried to assign Lead to Franchise, but no Franchisee or Sales Contact for postal code 09999', uNoFranchiseTask.Description);

        //Case3:  Bulk Lead inserts with mix of matching / not territory-matching leads        
        Contact[] contactsToCreate = new Contact[]{};
        for(Integer x=0; x<3;x++){
            Contact ct = new Contact(AccountId=acct.Id,lastname='test'+x,firstname='contact'+x,
                                    email='dlampson@intraxinc.com', Is_Sales_Contact__c = false, 
                                    Intrax_Programs__c='Ayusa;Lango;Study Abroad');

            contactsToCreate.add(ct);
        }
        contactsToCreate[0].Is_Sales_Contact__c = true; //Set one Contact as Sales contact      
        insert contactsToCreate;
        
        //Add Territory_Codes to test account
        acct.Territory_Codes__c = '09995,09996';
        update(acct);
        
        //Verify Territory_Codes set
        acct = [SELECT a.Id, a.Name, Territory_Codes__c, 
                    (Select Birthdate, Description, Email, Fax, FirstName, Id, Is_Sales_Contact__c, 
                     IsPersonAccount, LastName, MailingCity, MailingCountry, 
                     MailingPostalCode, MailingState, MailingStreet, MasterRecordId, MobilePhone, 
                     Name, OtherCity, OtherCountry, OtherPhone, OtherPostalCode, OtherState, 
                     OtherStreet, Phone, Salutation, Title 
                     From Contacts 
                     Where Is_Sales_Contact__c = true AND Intrax_Programs__c includes('Lango')) 
                FROM Account a 
                WHERE Name = 'ApexTest Lango Franchise'];
        System.assertEquals('09995,09996', acct.Territory_Codes__c);
        System.assertEquals('dlampson@intraxinc.com', acct.Contacts[0].email);
        System.assertEquals(true, acct.Contacts[0].Is_Sales_Contact__c);


        Lead[] leadsToCreate = new Lead[]{};
        for(Integer x=0, z=5; x<5;x++){
            Lead lead = new Lead(lastname='ATCtest'+x,firstname='lead'+x,
                        postalcode='0999'+z,  
                        Intrax_Programs__c='Ayusa;Lango;Study Abroad', 
                        phone='11223344'+z,
                        Lead_Type__c = 'Participant',
                        email='dlampson@intraxinc.com');
            leadsToCreate.add(lead);
            z++;
        }
        leadsToCreate[3].PostalCode = null; //Force null into lookup match for territory
        leadsToCreate[1].PostalCode = '09996-1234';  //Force 5x4 zipcode 
        leadsToCreate[4].PostalCode = '0999';  //Force short invalid postal code     
        
        //Now insert data causing lead triggers to fire. 
        //Test.startTest();
        insert leadsToCreate;
        //Test.stopTest();
        
        // Verify Lead 1 matched to Account using Zipcode/Territory 09995.
        System.assertEquals('09995,09996', acct.Territory_Codes__c);
        Contact ct1 = [SELECT Id, Email, Is_Sales_Contact__c 
                       FROM Contact 
                       WHERE Is_Sales_Contact__c = true AND email <> null
                                AND firstname='contact0' AND lastname='test0'];
        System.assertEquals('dlampson@intraxinc.com', ct1.Email);
        System.assertEquals(true, ct1.Is_Sales_Contact__c);
        Lead updatedLead0 = [SELECT Id, Status, PostalCode, Related_To_Id__c, Route_to_Franchise__c, Description 
                             FROM Lead 
                             WHERE lastname = 'ATCtest0' AND firstname = 'lead0'];
        System.assertEquals('09995', updatedLead0.PostalCode);
        System.assertEquals(true, updatedLead0.Related_To_Id__c == acct.Id);
        System.assertEquals(false, updatedLead0.Route_to_Franchise__c);    
        System.assertEquals('Working - Contacted', updatedLead0.Status);
        Task fTask0 = [SELECT Description FROM Task WHERE WhoId = :updatedLead0.Id];
        System.assertEquals('System Task:  Franchisee ApexTest Lango Franchise notified of new lead using email to: dlampson@intraxinc.com', fTask0.Description); 

        // Verify Lead 2 matched to Account using Zipcode/Territory 09996-1234.    
        Lead updatedLead1 = [SELECT Id, Status, PostalCode, Related_To_Id__c, Route_to_Franchise__c, Description 
                             FROM Lead 
                             WHERE lastname = 'ATCtest1' AND firstname = 'lead1'];
        System.assertEquals('09996-1234', updatedLead1.PostalCode);
        System.assertEquals(true, updatedLead1.Related_To_Id__c == acct.Id);
        System.assertEquals(false, updatedLead1.Route_to_Franchise__c);    
        System.assertEquals('Working - Contacted', updatedLead1.Status);   
        Task fTask1 = [SELECT Description FROM Task WHERE WhoId = :updatedLead1.Id];
        System.assertEquals('System Task:  Franchisee ApexTest Lango Franchise notified of new lead using email to: dlampson@intraxinc.com', fTask1.Description); 


        // Verify Lead 3 does not matched to Account using Zipcode/Territory 09997.         
        Lead updatedLead2 = [SELECT Id, Status, PostalCode, Related_To_Id__c, Route_to_Franchise__c, Description 
                             FROM Lead 
                             WHERE lastname = 'ATCtest2' AND firstname = 'lead2'];
        System.assertEquals('Open - New', updatedLead2.Status);
        System.assertEquals('09997', updatedLead2.PostalCode);
        System.assertEquals(true, updatedLead2.Related_To_Id__c == null);
        System.assertEquals(true, updatedLead2.Route_to_Franchise__c);    
        Task fTask2 = [SELECT Description FROM Task WHERE WhoId = :updatedLead2.Id];
        System.assertEquals('System Task: Failed.  Tried to assign Lead to Franchise, but no Franchisee or Sales Contact for postal code 09997', fTask2.Description); 


        // Verify Lead 4 does not matched to Account using Zipcode/Territory 09998.        
        Lead updatedLead3= [SELECT Id, Status, PostalCode, Related_To_Id__c, 
                                   Route_to_Franchise__c, Description 
                             FROM Lead 
                             WHERE lastname = 'ATCtest3' AND firstname = 'lead3'];
        System.assertEquals(null, updatedLead3.PostalCode);
        System.assertEquals(true, updatedLead3.Route_to_Franchise__c);    
        System.assertEquals('Open - New', updatedLead3.Status);
        Task fTask3 = [SELECT Description FROM Task WHERE WhoId = :updatedLead3.Id];
        System.assertEquals('System Task: Failed.  Tried to assign Lead to Franchise, but no Franchisee or Sales Contact for postal code null', fTask3.Description); 

        // Verify Lead 5 does not matched to Account using Zipcode/Territory 0999.        
        Lead updatedLead4= [SELECT Id, Status, PostalCode, Related_To_Id__c, 
                                   Route_to_Franchise__c, Description 
                             FROM Lead 
                             WHERE lastname = 'ATCtest4' AND firstname = 'lead4'];
        System.assertEquals('0999', updatedLead4.PostalCode);
        System.assertEquals(true, updatedLead4.Route_to_Franchise__c);    
        System.assertEquals('Open - New', updatedLead3.Status);
        Task fTask4 = [SELECT Description FROM Task WHERE WhoId = :updatedLead4.Id];
        System.assertEquals('System Task: Failed.  Tried to assign Lead to Franchise, but no Franchisee or Sales Contact for postal code 0999', fTask4.Description); 


            
        
        //Case3:  Account with Territory_Codes (matching) and Contact, but contact email is null.       
        Contact salesContactNE = [SELECT Email FROM Contact 
                                  WHERE lastname = 'test0' AND firstname = 'contact0'];  
        salesContactNE.Email = null;
        update salesContactNE;
        Contact updatedContactNE = [SELECT Email FROM Contact 
                                    WHERE lastname = 'test0' AND firstname = 'contact0'];  
        System.assertEquals(null, updatedContactNE.Email);
        Lead leadCNE = new Lead(lastname='test',firstname='leadCNE',postalcode='09995', 
                                Intrax_Programs__c='Lango', Lead_Type__c = 'Participant', 
                                phone='1122334443', email='dlampson@intraxinc.com');
        insert leadCNE;
        Lead updatedLeadCNE = [SELECT Status, PostalCode, Related_To_Id__c, Route_to_Franchise__c 
                               FROM Lead 
                               WHERE lastname = 'test' AND firstname = 'leadCNE' AND 
                               PostalCode = '09995'];
        System.assertEquals('09995', updatedLeadCNE.PostalCode); 
        System.assertEquals(null, updatedLeadCNE.Related_To_Id__c);    
        System.assertEquals('Open - New', updatedLeadCNE.Status);
        System.assertEquals(true, updatedLeadCNE.Route_to_Franchise__c);
        Task fTaskCNE = [SELECT Description FROM Task WHERE WhoId = :updatedLeadCNE.Id];
        System.assertEquals('System Task: Failed.  Tried to assign Lead to Franchise, but no Franchisee or Sales Contact for postal code 09995', fTaskCNE.Description); 
        


        //Case4:  Account with Territory_Codes (matching) but no Sales Contact Checked       
        Contact salesContact = [SELECT Is_Sales_Contact__c FROM Contact 
                                WHERE lastname = 'test0' AND firstname = 'contact0'];  
        salesContact.Is_Sales_Contact__c = false;
        update salesContact;
        Contact updatedContactNC = [SELECT Email, Is_Sales_Contact__c FROM Contact 
                                    WHERE lastname = 'test0' AND firstname = 'contact0'];  
        System.assertEquals(false, updatedContactNC.Is_Sales_Contact__c);
      
        Lead leadNoC = new Lead(lastname='test',firstname='leadNoC', PostalCode='09995', 
                                Intrax_Programs__c='Lango', Lead_Type__c='Participant', 
                                phone='1122334422', email='dlampson@intraxinc.com');
        insert leadNoC;
        Lead uLeadNoC = [SELECT Status, PostalCode, Route_to_Franchise__c, Related_To_Id__c 
                           FROM Lead 
                           WHERE lastname = 'test' AND firstname = 'leadNoC' 
                           AND PostalCode = '09995'];
        System.assertEquals('Open - New', uLeadNoC.Status);
        System.assertEquals('09995', uLeadNoC.PostalCode); 
        System.assertEquals(true, uLeadNoC.Route_to_Franchise__c); 
        System.assertEquals(null, uLeadNoC.Related_To_Id__c);
        Task fTaskNoC = [SELECT Description FROM Task WHERE WhoId = :uLeadNoC.Id];
        System.assertEquals('System Task: Failed.  Tried to assign Lead to Franchise, but no Franchisee or Sales Contact for postal code 09995', fTaskNoC.Description);*/ 

        //Test Cleanup
       /* salesContact = [SELECT Is_Sales_Contact__c FROM Contact 
                        WHERE lastname = 'test0' AND firstname = 'contact0'];  
        salesContact.Is_Sales_Contact__c = true;
        salesContact.Email = 'dlampson@intraxinc.com';
        update salesContact;
        Contact uSalesContact = [SELECT Email, Is_Sales_Contact__c FROM Contact 
                                 WHERE lastname = 'test0' AND firstname = 'contact0'];          

   
        //Case X:  Lango Franchise lead (should not be routed)
        Lead leadLF = new Lead(lastname='test',firstname='leadLF', PostalCode='09996', 
                                Intrax_Programs__c='Lango', Lead_Type__c='Franchise', 
                                phone='1122234232', email='dlampson@intraxinc.com');
        insert leadLF;
        Lead uLeadLF = [SELECT Status, PostalCode, Route_to_Franchise__c, Related_To_Id__c 
                           FROM Lead 
                           WHERE lastname = 'test' AND firstname = 'leadLF' 
                           AND PostalCode = '09996'];
        System.assertEquals('Open - New', uLeadLF.Status);
        System.assertEquals('09996', uLeadLF.PostalCode); 
        System.assertEquals(false, uLeadLF.Route_to_Franchise__c); 
        System.assertEquals(null, uLeadLF.Related_To_Id__c);
        List<Task> fTaskLF = [SELECT Description FROM Task WHERE WhoId = :uLeadLF.Id];
        System.assertEquals(0, fTaskLF.Size()); 

        
        //Case X:  Non-Lango participant lead (should not be routed)
        Lead leadAy = new Lead(lastname='test',firstname='leadAy', PostalCode='09996', 
                                Intrax_Programs__c='Ayusa', Lead_Type__c='Participant', 
                                phone='1634234232', email='dlampson@intraxinc.com');
        insert leadAy;
        Lead uleadAy = [SELECT Status, PostalCode, Route_to_Franchise__c, Related_To_Id__c 
                           FROM Lead 
                           WHERE lastname = 'test' AND firstname = 'leadAy' 
                           AND PostalCode = '09996'];
        System.assertEquals('Open - New', uleadAy.Status);
        System.assertEquals('09996', uleadAy.PostalCode); 
        System.assertEquals(false, uleadAy.Route_to_Franchise__c); 
        System.assertEquals(null, uleadAy.Related_To_Id__c);
        List<Task> fTaskAy = [SELECT Description FROM Task WHERE WhoId = :uleadAy.Id];
        System.assertEquals(0, fTaskAy.Size());         
        
        //Case X:  Update on a previously failed routing
        updatedLead2.Description = 'Force Update';
        update updatedLead2;         
        Lead uLeadUr = [SELECT Id, Status, PostalCode, Related_To_Id__c, Route_to_Franchise__c, Description 
                             FROM Lead 
                             WHERE lastname = 'ATCtest2' AND firstname = 'lead2'];
        System.assertEquals('Open - New', uLeadUr.Status);
        System.assertEquals('09997', uLeadUr.PostalCode);
        System.assertEquals(true, uLeadUr.Related_To_Id__c == null);
        System.assertEquals(true, uLeadUr.Route_to_Franchise__c);    
        Task fTaskUr = [SELECT Description FROM Task WHERE WhoId = :uLeadUr.Id];
        System.assertEquals('System Task: Failed.  Tried to assign Lead to Franchise, but no Franchisee or Sales Contact for postal code 09997', fTaskUr.Description); 
        
        //Case X:  Add Territory Code to Acct, then update previously route failed lead matching 09997
        //(NOTE:  Depends on earlier TC state)
        acct.Territory_Codes__c = '09995, 09996, 09997';
        update(acct);
        acct = [SELECT a.Id, a.Name, Territory_Codes__c, 
                    (Select Birthdate, Description, Email, Fax, FirstName, Id, Is_Sales_Contact__c, 
                     IsPersonAccount, LastName, MailingCity, MailingCountry, 
                     MailingPostalCode, MailingState, MailingStreet, MasterRecordId, MobilePhone, 
                     Name, OtherCity, OtherCountry, OtherPhone, OtherPostalCode, OtherState, 
                     OtherStreet, Phone, Salutation, Title 
                     From Contacts 
                     Where Is_Sales_Contact__c = true AND Intrax_Programs__c includes('Lango')) 
                FROM Account a 
                WHERE Name = 'ApexTest Lango Franchise'];
        System.assertEquals('09995, 09996, 09997', acct.Territory_Codes__c);
        System.assertEquals('dlampson@intraxinc.com', acct.Contacts[0].email);
        System.assertEquals(true, acct.Contacts[0].Is_Sales_Contact__c);
        //Now force an update on the lead to try matching again
        uLeadUr.Description = 'Force Update';
        update uLeadUr;         
        Lead uLeadRl = [SELECT Id, Status, PostalCode, Related_To_Id__c, Route_to_Franchise__c, Description 
                             FROM Lead 
                             WHERE lastname = 'ATCtest2' AND firstname = 'lead2'];
        System.assertEquals('Working - Contacted', uLeadRl.Status);
        System.assertEquals('09997', uLeadRl.PostalCode);
        System.assertEquals(false, uLeadRl.Related_To_Id__c == null);
        System.assertEquals(false, uLeadRl.Route_to_Franchise__c);    
        List<Task>  fTaskRl = [SELECT Description FROM Task WHERE WhoId = :uLeadRl.Id ORDER BY CreatedDate DESC];
        System.assertEquals(2, fTaskRl.Size());
        System.assertEquals('System Task:  Franchisee ApexTest Lango Franchise notified of new lead using email to: dlampson@intraxinc.com', fTaskRl[0].Description); 
        
        //Case X:  Update a previously matched lead (re-route) (NOTE:  Depends on earlier TC state)
        updatedLead0.Related_To_Id__c = null;
        updatedLead0.PostalCode = '09997';
        update updatedLead0;
        Lead uLeadRs = [SELECT Id, Status, PostalCode, Related_To_Id__c, Route_to_Franchise__c, Description 
                             FROM Lead 
                             WHERE lastname = 'ATCtest0' AND firstname = 'lead0'];
        System.assertEquals('09997', uLeadRs.PostalCode);
        System.assertEquals(true, uLeadRs.Related_To_Id__c == null);
        System.assertEquals(false, uLeadRs.Route_to_Franchise__c);    
        System.assertEquals('Working - Contacted', uLeadRs.Status);
        List<Task> fTaskRs = [SELECT Description FROM Task WHERE WhoId = :uLeadRs.Id ORDER BY CreatedDate DESC];
        System.assertEquals('System Task:  Franchisee ApexTest Lango Franchise notified of new lead using email to: dlampson@intraxinc.com', fTaskRs[0].Description); 
        //Now force re-route by checking Route_To_Franchise
        uLeadRs.Route_to_Franchise__c = true;
        update uLeadRs;
        Lead uLeadRrl = [SELECT Id, Status, PostalCode, Related_To_Id__c, Route_to_Franchise__c, Description 
                             FROM Lead 
                             WHERE lastname = 'ATCtest0' AND firstname = 'lead0'];  
        System.assertEquals('09997', uLeadRrl.PostalCode);
        System.assertEquals(true, uLeadRrl.Related_To_Id__c == acct.Id);
        System.assertEquals(false, uLeadRrl.Route_to_Franchise__c);    
        System.assertEquals('Working - Contacted', uLeadRrl.Status);
        List<Task> fTaskRrl = [SELECT Description FROM Task WHERE WhoId = :uLeadRrl.Id ORDER BY CreatedDate DESC];
        System.assertEquals(2, fTaskRrl.Size());
        System.assertEquals('System Task:  Franchisee ApexTest Lango Franchise notified of new lead using email to: dlampson@intraxinc.com', fTaskRrl[0].Description); 
                                
        
        //Case X:  Test email limit -- Route 11 leads in one transaction
        //Second collection of leads for ensuring we're missing the governor limits
        Lead[] elLeadsToCreate = new Lead[]{};
        for(Integer x=0; x<12; x++){
            Lead lead = new Lead(lastname='ElTest'+x,firstname='ElLead'+x,
                        postalcode='09996',  
                        Intrax_Programs__c='Ayusa;Lango;Study Abroad', 
                        phone=String.valueOf(1122334409 + x),
                        Lead_Type__c = 'Participant',
                        email='dlampson@intraxinc.com');
            elLeadsToCreate.add(lead);
        }   
        insert elLeadsToCreate; */
        
//        Lead elLead = [SELECT Id, Status, PostalCode, Related_To_Id__c, Route_to_Franchise__c, Description 
//                         FROM Lead 
//                         WHERE lastname = 'ElTest11' AND firstname = 'ElLead11'];
//        System.assertEquals('09996', elLead.PostalCode);
//        System.assertEquals(true, elLead.Related_To_Id__c == acct.Id);
//        System.assertEquals(false, elLead.Route_to_Franchise__c);    
//        System.assertEquals('Working - Contacted', elLead.Status);
//        List<Task> fTaskEl = [SELECT Description FROM Task WHERE WhoId = :elLead.Id ORDER BY CreatedDate DESC];
//        System.assertEquals(1, fTaskEl.Size());
//        System.assertEquals('System Task:  Franchisee ApexTest Lango Franchise notified of new lead using email to: dlampson@intraxinc.com', fTaskEl[0].Description); 
    }   
}