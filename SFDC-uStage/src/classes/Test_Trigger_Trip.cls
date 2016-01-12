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
@isTest
private class Test_Trigger_Trip {

 /*   Purpose         :   Test class for Trigger_Trip.
                
    Created Date    :   09/04/2014
    
    Current Version :   v1.0
    
    Revision Log    :    
*/

    static testMethod void testUpdateOpportunityOperationStageByMatchStatus() {
    
        //Fetch record type Id from database of Type Business Account
        List<RecordType> hostRecordType = [Select Id from RecordType where DeveloperName = 'Ayusa_PT' AND IsPersonType = false AND SObjectType = 'Engagement__c' AND IsActive = true ];
        
        //insert engagement instance
        Engagement__c eng = new Engagement__c(Name='Engagement',RecordTypeId = hostRecordType[0].Id,Intrax_Program__c = 'Ayusa', Intrax_Program_Options__c = 'YES', Intrax_Region__c = 'United States',
                                                        Type__c = 'Participant', 
                                                        Engagement_Start__c = date.today(), Engagement_End__c = (date.today() + 100),
                                                        Program_Duration__c ='1 - 4 weeks',
                                                        Program_Year__c ='2013', Status__c = 'Program Ready', Needs_Travel__c ='Yes');
        
        insert eng;
        
        //Create test data
        List<Trip__c> listTrips = new List<Trip__c>();
        List<Trip__c> listTrips2 = new List<Trip__c>();
        
        //insert in list
        for(Integer i = 0; i < 1; i++) {
            listTrips.add(new Trip__c(Name = 'Test Trip' + i, Engagement__c = eng.Id, Arrival_to_Host_Community__c=True,
                                            Arrival_to_Host_Country__c=True, Departure_from_host_community__c=True));
        }
        
        //insert data in bulk 
        insert listTrips;
        
              
        
        for(Trip__c t:listTrips){
            t.Arrival_to_Host_Community__c=False;
            t.Arrival_to_Host_Country__c=False;
            t.Departure_from_host_community__c=False;
        }
        
        update listTrips;
        
        for(Trip__c t:listTrips){
            t.Arrival_to_Host_Community__c=true;
            t.Arrival_to_Host_Country__c=true;
            t.Departure_from_host_community__c=true;
        }
        
        update listTrips;
        
        delete listTrips[0]; 
    
    }

}