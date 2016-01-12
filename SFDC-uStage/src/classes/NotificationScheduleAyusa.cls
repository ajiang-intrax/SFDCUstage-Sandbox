global class NotificationScheduleAyusa implements schedulable
{
    global void execute(SchedulableContext sc)
    {
    NotificationBatch NB = new NotificationBatch('Select Id,End_Date__c,URL_Monthly_HF__c,Position_Name__c,Participant_Id__c from Match__c m where m.Id in (Select a.Match_Name__c From Assessment__c a where a.Assessment_Date__c = NULL) and  (m.end_date__c = LAST_N_DAYS:30 or m.end_date__c > Today) and m.start_date__c <= Today and m.RecordTypeId in (select Id from RecordType where sObjectType = \'Match__c\' and Name=\'Ayusa\')',
    'Match__c'); //ur batch class
      database.executebatch(NB);
    }

}