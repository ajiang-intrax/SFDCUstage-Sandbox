trigger pushAccountToProWorld on Account (after insert) {
	//I have to exclude this trigger if Auto Sync Application.
    if(TriggerExclusion.isTriggerExclude('Account')){
    	return;
    }
    
for (Account i : Trigger.new) {
//List<recordType> recordType = [select id from recordType where sObjectType = 'Account' and Name='Institution'];

if ( i.RecordTypeID == '01230000000rv8T' && i.Institution_Type__c == 'University'){
    List<PartnerNetworkConnection> Connections = 
    [select Id from PartnerNetworkConnection where ConnectionStatus = 'Accepted' and ConnectionName = 'ProWorld'];
    PartnerNetworkRecordConnection newConnection =
                        new PartnerNetworkRecordConnection(
                            ConnectionId = Connections[0].Id,
                            LocalRecordId = i.Id,
                            SendClosedTasks = false,
                            SendOpenTasks = false,
                            SendEmails = false
                            );
            insert newConnection;
        }
    }
}