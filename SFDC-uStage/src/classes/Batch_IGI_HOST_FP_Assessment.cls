global class Batch_IGI_HOST_FP_Assessment implements Database.Batchable<sObject> {
    
     public static integer rows_count = 0; 
    
    global Database.queryLocator start(Database.BatchableContext BC){
        list<Engagement__c> engListForBatch = new list<Engagement__c>();
        
        return Database.getQueryLocator([SELECT Id, Status__c, (Select CreatedBy__c from Applicant_Info__r), Intrax_Program__c, Intrax_Program_Options__c, Engagement_Start__c , Engagement_End__c FROM Engagement__c
                                                    WHERE Intrax_Program__c =: 'Internship'
                                                    AND Visa_Type__c=: 'J-1'
                                                    AND (Status__c =: 'On Program') 
                                                   // AND Engagement_End__c > :date.today() 
                                                    AND Id NOT IN (select Engagement__c from Notification__c WHERE Type__c = 'Host Final Program') 
                                          ]);
    }
    
    global void execute (Database.BatchableContext BC, list<Engagement__c> DummyengList){
        
        
        system.debug('DummyengList' + DummyengList);
        list<ID> engList = new list<ID>();
        Integer NoOfDays;
        Integer NoOfDaysToday;
        if(DummyengList != NULL)
        {
            for (Engagement__c en : DummyengList)
            {
               
              
               system.debug('***** adding to engList' );
                if(en.Engagement_Start__c != NULL && en.Engagement_End__c != NULL)
                {
                    NoOfDays =  en.Engagement_Start__c.daysBetween(en.Engagement_End__c);
                    NoOfDaysToday= date.today().daysBetween(en.Engagement_End__c);
                    if (  (NoOfDaysToday<= 7 && NoOfDays <= 60) || (NoOfDaysToday<= 14 && NoOfDays > 60 && NoOfDays <= 120 ) || (NoOfDaysToday<= 30 && NoOfDays >120 ))
                    {
                        engList.add(en.id);
                    }
                }
                                              
            }
            
           
        }
        system.debug('engList'+engList);
        if(engList != NULL && engList.size() > 0)
        {
            list<Match__c> Matchlist = [SELECT ID, Name, Final_Evaluation_Sent__c FROM Match__c WHERE Status__c = 'Confirmed' AND Start_Date__c < :date.today() AND End_Date__c >= :date.today() AND Engagement__c=: engList];
            
            if (Matchlist.size() > 0)
            {
                for(Match__c matSingle: Matchlist)
                {
                    matSingle.Final_Evaluation_Sent__c = system.now();
                }
                update Matchlist;
                system.debug('@@ calling new class');
                Notification_Generator.CreateIGISupervisorEvaluations('FP',Matchlist);
            }
        }
    } 
    
    global void finish(Database.BatchableContext BC){
    
    }   
}