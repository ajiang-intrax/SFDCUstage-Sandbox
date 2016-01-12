/*
    IGI - Batch used to update In-Active User that are created as a part of Not Serviced Application in order to remove the 
          Portal Enabled Contact(Created From Not Serviced Application) tagged with Users.
*/
global class BatchOnUserDeletion implements Database.batchable<SObject>, Schedulable{ 
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        
        return Database.getQueryLocator([select Id, isActive, isPortalEnabled, IsUserNotServiced__c from User where isActive = false and IsUserNotServiced__c = true and isPortalEnabled = true]);
    }
    
    global void execute(Database.BatchableContext bc , List<User> userList){
        list<User> lstUser = new list<User>();
        for(User itrUser : userList){
            if(itrUser.isPortalEnabled){
                itrUser.isPortalEnabled = false;
                lstUser.add(itrUser);
            }
        }
        if(lstUser.size() > 0){         
            update lstUser;
        }
    }
    
    global void finish(Database.BatchableContext bc ){
        //BatchOnUserDeletion.startJob(System.now());    
        BatchOnContactDeletion batch = new BatchOnContactDeletion();
        Database.executeBatch(batch, 50);
    }
    
    global void execute(SchedulableContext sc){
        BatchOnUserDeletion batch = new BatchOnUserDeletion();
        Database.executeBatch(batch, 50);
    }
    
    /*public static void startJob(DateTime sysTime){
        sysTime = sysTime.addMinutes(5);
        String chronJobId = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        system.debug('chronJobId:'+chronJobId);
        BatchOnUserDeletion userSched = new BatchOnUserDeletion();
        System.schedule('Batch On User Deletion'+chronJobId, chronJobId, userSched);
        
    }*/
}