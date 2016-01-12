public without sharing class NotificationRedirectionController {

	list<Notification__c> notifyComplete =  new list<Notification__c>();
	list<Notification__c> notifyToBeUpdated =  new list<Notification__c>();
public pagereference redirect()
{
	
		Pagereference p;
		if(Apexpages.currentPage().getparameters().get('posId')!=null)
		{
			notifyComplete = [SELECT Id, Status__c, Type__c, Intrax_Program__c,Action_URL__c, Subject__c, ownerId, Body__c, Is_Parent__c, Engagement__c
							FROM Notification__c  WHERE position__c =:Apexpages.currentPage().getparameters().get('posId') and status__c='Not Started' and OwnerId =: userInfo.getUserId()
							AND Is_Parent__c =: false];
			if(notifyComplete!=null && notifyComplete.size()>0)
			{
				For(Notification__c notify: notifyComplete)
				{
					notify.status__c='Complete';
					notifyToBeUpdated.add(notify);
				}
				if(notifyToBeUpdated!=null && notifyToBeUpdated.size()>0)
				update notifyToBeUpdated;
			}
			p=new pagereference('/apex/profiles');
		}
		if(Apexpages.currentPage().getparameters().get('NotifyRec')!=null)
		{
			notifyComplete = [SELECT Id, Status__c, Type__c, Intrax_Program__c,Action_URL__c, Subject__c, ownerId, Body__c, Is_Parent__c, Engagement__c
							FROM Notification__c  WHERE OwnerId =: userInfo.getUserId()
							AND Is_Parent__c =: false
							AND (Status__c = 'Not Started' OR Status__c = 'Incomplete') and Type__c ='Recommended Students'];
			if(notifyComplete!=null && notifyComplete.size()>0)
			{
				For(Notification__c notify: notifyComplete)
				{
					notify.status__c='Complete';
					notifyToBeUpdated.add(notify);
				}
				if(notifyToBeUpdated!=null && notifyToBeUpdated.size()>0)
				update notifyToBeUpdated;
			}
			p=new pagereference('/apex/profiles?ShowRecommended=true');
		}		
		if(Apexpages.currentPage().getparameters().get('ConfmatId')!=null)
		{
			notifyComplete = [SELECT Id, Status__c, Type__c, Intrax_Program__c,Action_URL__c, Subject__c, ownerId, Body__c, Is_Parent__c, Engagement__c
							FROM Notification__c  WHERE position__c =:Apexpages.currentPage().getparameters().get('ConfmatId') and status__c='Not Started' and Type__c ='Confirmed Students' and OwnerId =: userInfo.getUserId()
							AND Is_Parent__c =: false];
			if(notifyComplete!=null && notifyComplete.size()>0)
			{
				For(Notification__c notify: notifyComplete)
				{
					notify.status__c='Complete';
					notifyToBeUpdated.add(notify);
				}
				if(notifyToBeUpdated!=null && notifyToBeUpdated.size()>0)
				update notifyToBeUpdated;
			}
			p=new pagereference('/apex/MyStudents?ConfMatch=true');
		}
		
       return p;			
}

}