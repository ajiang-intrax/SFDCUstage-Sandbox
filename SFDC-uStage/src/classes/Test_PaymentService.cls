@isTest
private class Test_PaymentService {

    static testMethod void myUnitTest1() {
        
        
        //Record Type
         RecordType rt = [select id,Name from RecordType where SobjectType='Account' and Name='Partner Admin' Limit 1];
        
        //Assert for Results
        System.assertEquals(true, rt!=null);
        
         //Record Type (Centers)
        RecordType rtAPC = [select id, Name from RecordType where SobjectType='Applicant_Info__c' and Name='AuPairCare HF' Limit 1];
       
        //Assert for Results
        System.assertEquals(true, rtAPC!=null);
        
        //Account
        Account account  = new Account(Name = 'Test', RecordTypeId = rt.Id, Type = 'Partner');
        insert account;
        
        
        //Contact
        Contact contact = new Contact(LastName = 'LastName', AccountId = account.Id, Email = 'test@test.com');
        insert contact;
        
        //sAccount
        sAccount__c sAccount = new sAccount__c(Name = 'Test sAccount', Account_Name__c = account.Id, Intrax_Id__c = 'I-000168');
        insert sAccount;
        
        //Get Profile record
        List<Profile> profiles = [Select Id from Profile where Name = 'OCPM PT' limit 1];
        
        User sysAdmin = [select Id from User where username = :Constants.SYS_ADMIN];
        sysAdmin.User_Interests__c='Hosting an au pair';
        
        //Check for list Size
        if(profiles.size() > 0) {
        
            //Portal User
            User user = new User(Alias = 'alias', Email = 'testUser@test.com', EmailEncodingKey = 'UTF-8', 
                                    LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                                    ProfileId = profiles[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                    ContactId = contact.Id, Intrax_Id__c ='Test',
                                    Username = Math.random() + '@test.com', User_Interests__c='Hosting an au pair');
            
            insert user;
            
            //Create a new test account and set contact as portal contact
            Account portalAccount = new Account(Name = 'TestName', Portal_Contact_Name__c = contact.Id, Type = 'Partner');
            insert portalAccount;
            
            //Fetch intract Id for this account id
            portalAccount = [Select Id, Intrax_Id__c from Account where Id =: portalAccount.Id];
        
            //Run in user context
            System.runAs(sysAdmin) {
                
                //Applicant Info
                Applicant_Info__c appInfo = new Applicant_Info__c(Name = 'test-APC', Street__c = 'test', City__c = 'test', Meal_Self_Sufficient__c = 'No', First_Name__c = 'Jose',
                                                                  Postal_Code__c = '12345',  Type__c = 'Host Family', Home_Type__c = 'Duplex', Language_spoken_3__c = 'spanish', Intrax_Center__c='true',
                                                                  Country__c = 'United States', Home_Phone__c = '12345', Interests__c = 'Dance',
                                                                  Partner_Intrax_Id__c = portalAccount.Intrax_Id__c, Home_Responsibilities__c = 'Test',
                                                                  Application_Stage__c = 'Declined - Agent', Disabilities__c = 'No', Submitted__c = true,
                                                                  Community_Type__c ='Urban', Private_High_School_Indicated__c = 'No', State__c = 'CA', 
                                                                  Month_Arrival__c ='1', Aupair_Preferences__c = 'Country', Casper_Id__c='654321',
                                                                  Parent_Marital_Status__c = 'Other', GPA_Self_Reported__c = 'Test', 
                                                                  Curfew_Indicated__c = 'No', RecordTypeId = rtAPC.Id, Special_Diet_Indicated__c = 'No',
                                                                  Prior_Exchange_Experience__c = 'No', Live_With_Pets__c = 'No', 
                                                                  Primary_Language__c = 'English', School_Transportation__c = 'Bus', 
                                                                  Engagement_Start__c = System.today(), Accommodation_Preference__c = 'Homestay',
                                                                  Gender_Preference__c = 'female', Study_Weeks__c = 1, Program_Start_Opinion__c = 'Yes',createdBy__c = user.Id);
                insert appInfo;

                //Personal Info
                Person_Info__c personInfo = new Person_Info__c(Primary_Applicant__c = true, Marital_Status__c = 'Married', Family_Member__c = true, Email__c='test76457@lkj.com',
                                                    First_Name__c  = UserInfo.getFirstName(), Gender__c = 'Male',
                                                    Applicant_Info__c = appInfo.Id, Emergency_Contact_Indicated__c = 'Yes',
                                                    Birth_City__c = 'Test', Last_Name__c = 'Test', Role__c ='EmergencyContact',
                                                    Date_of_Birth__c = date.newInstance(1980, 2, 17) );
                insert personInfo;
                
                Payment__c payment = new Payment__c( Card_Holder__c= appinfo.id, Billing_Street_1__c='Test', Billing_Street_2__c='Test', Billing_City__c='Test', Billing_State__c='KA', Billing_Country__c='USA',Billing_Postal_Code__c='94106',
                							 		Billing_LastName__c='Test', Billing_FirstName__c='Test' , Billing_Email__c='Test@hotmail98734.com');
                
                insert payment;
                
               
		
                
                //Start Test From Here
                Test.startTest();
                
                PaymentWrapper payWrapper = new PaymentWrapper();
                
                payWrapper.cvvNumber = '111';
                 
               	//testing PaymentServices.cls
               	paymentScheduledWebServiceInterface.paymentTransactionResultSetDto paymentResponse1 = PaymentService.makeCreditCardTransactionRequest(payment, appInfo, personInfo, payWrapper);
               	paymentScheduledWebServiceInterface.encryptedPaymentTransactionResultSetDto paymentResponse2 = PaymentService.makeEncryptedCreditCardTransactionRequest(payment,appInfo, personInfo, payWrapper);
               	
               	//testing PaymentHelper.cls
               	PaymentHelper.parseWebServiceResponse(payment, paymentResponse1);
               	PaymentHelper.parseEncryptedWebServiceResponse(payment, paymentResponse2);
               	
               	//testing EncryptionDecryptionHandler.cls
               	String encryptedText = 'Test';
               	EncryptionDecryptionHandler.decrypt(encryptedText);
               
               //testing paymentScheduledWebServiceInterface.cls
               
               paymentScheduledWebServiceInterface pay1 = new paymentScheduledWebServiceInterface();
               paymentScheduledWebServiceInterface.encryptedPaymentTransactionResultDto pay2 = new paymentScheduledWebServiceInterface.encryptedPaymentTransactionResultDto();
               paymentScheduledWebServiceInterface.encryptedPaymentTransactionResultSetDto pay3 = new paymentScheduledWebServiceInterface.encryptedPaymentTransactionResultSetDto();
               paymentScheduledWebServiceInterface.createCreditCardTransaction pay4 = new paymentScheduledWebServiceInterface.createCreditCardTransaction();
               paymentScheduledWebServiceInterface.encryptedCreateCreditCardTransactionResponse pay5 = new paymentScheduledWebServiceInterface.encryptedCreateCreditCardTransactionResponse();
               paymentScheduledWebServiceInterface.createCreditCardTransactionRequest pay6 = new paymentScheduledWebServiceInterface.createCreditCardTransactionRequest();
               paymentScheduledWebServiceInterface.paymentTransactionResultDto pay7 = new paymentScheduledWebServiceInterface.paymentTransactionResultDto();
               paymentScheduledWebServiceInterface.encryptedCreateCreditCardTransactionRequest pay8 = new paymentScheduledWebServiceInterface.encryptedCreateCreditCardTransactionRequest();
               paymentScheduledWebServiceInterface.encryptedCreateCreditCardTransaction pay9 = new paymentScheduledWebServiceInterface.encryptedCreateCreditCardTransaction();
               paymentScheduledWebServiceInterface.paymentTransactionResultSetDto pay10 = new paymentScheduledWebServiceInterface.paymentTransactionResultSetDto();
               paymentScheduledWebServiceInterface.createCreditCardTransactionResponse pay11 = new paymentScheduledWebServiceInterface.createCreditCardTransactionResponse();
               paymentScheduledWebServiceInterface.PaymentTransactionServicePort pay12 = new paymentScheduledWebServiceInterface.PaymentTransactionServicePort();
               
               //testing paymentScheduledWebServiceInterface.cls
               
               paymentScheduledWebServiceInterface payN1 = new paymentScheduledWebServiceInterface();
               paymentScheduledWebServiceInterface.createCreditCardTransactionRequest payN2 = new paymentScheduledWebServiceInterface.createCreditCardTransactionRequest();
               paymentScheduledWebServiceInterface.paymentTransactionResultDto payN3 = new paymentScheduledWebServiceInterface.paymentTransactionResultDto();
               paymentScheduledWebServiceInterface.paymentTransactionResultSetDto payN4 = new paymentScheduledWebServiceInterface.paymentTransactionResultSetDto();
               paymentScheduledWebServiceInterface.createCreditCardTransactionResponse payN5 = new paymentScheduledWebServiceInterface.createCreditCardTransactionResponse();
               paymentScheduledWebServiceInterface.PaymentTransactionServicePort payN6 = new paymentScheduledWebServiceInterface.PaymentTransactionServicePort();
               
               //testing PaymentConstants.cls
               PaymentConstants patcons = new PaymentConstants();
               
               Test.stopTest();
                
            }
        }
    }
}