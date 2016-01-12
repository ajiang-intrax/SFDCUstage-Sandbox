global class Batch_IGI_HOST_MP_Assessment implements Database.Batchable<sObject> {
    
     public static integer rows_count = 0; 
    
    global Database.queryLocator start(Database.BatchableContext BC){
        list<Engagement__c> engListForBatch = new list<Engagement__c>();
        
        return Database.getQueryLocator([SELECT Id, Status__c,  Intrax_Program__c, Intrax_Program_Options__c, Engagement_Start__c , Engagement_End__c FROM Engagement__c
                                                    WHERE Intrax_Program__c =: 'Internship'
                                                    AND (Status__c =: 'On Program') 
                                                    AND Id NOT IN (select Engagement__c from Notification__c WHERE Type__c = 'Host Mid Program') ]);
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
               
               if ( en.Intrax_Program_Options__c != 'WEST' ){ 
               system.debug('***** not WEST ' );
                if(en.Engagement_Start__c != NULL && en.Engagement_End__c != NULL)
                {
                    NoOfDays =  en.Engagement_Start__c.daysBetween(en.Engagement_End__c);
                    NoOfDaysToday= en.Engagement_Start__c.daysBetween(date.today());
                    if (NoOfDaysToday >= NoOfDays/2 && NoOfDays > 180 )
                    {
                        engList.add(en.id);
                    }
                }
               }
               else {
                system.debug('*****  WEST ' );
                list<Match__c> match_exist = [SELECT Start_Date__c, End_Date__c
                                                    FROM Match__c 
                                                    WHERE Engagement__c =: en.Id and Status__c=: 'Confirmed' order by CreatedDate desc ];
                  if (match_exist.size() > 0)  
                  {    
                    system.debug('*****  WEST and found match  with seze = ' + match_exist.size()  );                         
                  if( match_exist[0].Start_Date__c   != NULL && match_exist[0].End_Date__c != NULL)
                  {
                     
                    NoOfDays = match_exist[0].Start_Date__c.daysBetween(match_exist[0].End_Date__c);
                    NoOfDaysToday= match_exist[0].Start_Date__c.daysBetween(date.today());
                    if (NoOfDaysToday >= NoOfDays/2 && NoOfDays > 180 )
                    {
                        engList.add(en.id);
                    }
                }
               }
               }
                
            }
        }
        system.debug('engList'+engList);
        if(engList != NULL && engList.size() > 0)
        {
            list<Match__c> Matchlist = [SELECT ID, Name, Mid_Evaluation_Sent__c FROM Match__c WHERE Status__c = 'Confirmed' AND Start_Date__c < :date.today() AND End_Date__c >= :date.today() AND Engagement__c=: engList];
            
            if (Matchlist.size() > 0)
            {
                for(Match__c matSingle: Matchlist)
                {
                    matSingle.Mid_Evaluation_Sent__c = system.now();
                }
                 update Matchlist;
                system.debug('@@ calling new class');
                Notification_Generator.CreateIGISupervisorEvaluations('MP',Matchlist);
            }
        }
    } 
    
    global void finish(Database.BatchableContext BC){
    
    }   
}