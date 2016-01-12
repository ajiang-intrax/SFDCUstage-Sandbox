/*
    IGI - Batch used to delete Contact Record that are created from Not Serviced Application. 
*/
global class BatchOnContactDeletion implements Database.batchable<SObject>, Schedulable{ 
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        
        return Database.getQueryLocator([select Id, IsContactNotServiced__c from Contact where IsContactNotServiced__c = true]);
    }
    
    global void execute(Database.BatchableContext bc , List<Contact> contactList){
        list<Contact> lstContact = new list<Contact>();
        for(Contact itrContact : contactList){
            if(itrContact.IsContactNotServiced__c){
                itrContact.IsContactNotServiced__c = false;
                lstContact.add(itrContact);
            }
        }
        if(lstContact.size() > 0){
            delete lstContact;
        }
    }
    
    global void finish(Database.BatchableContext bc ){
        //BatchOnContactDeletion.startJob(System.now());
    }
    
    global void execute(SchedulableContext sc){
        BatchOnContactDeletion batch = new BatchOnContactDeletion();
        Database.executeBatch(batch, 50);
    }
    
    /*public static void startJob(DateTime sysTime){
        sysTime = sysTime.addMinutes(7);
        String chronJobId = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        system.debug('chronJobId:'+chronJobId);
        BatchOnContactDeletion contactSched = new BatchOnContactDeletion();
        System.schedule('Batch On Contact Deletion'+chronJobId, chronJobId, contactSched);
        
    }*/
    
}