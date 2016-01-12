trigger Trigger_Development_Plan on Development_Plan__c (after update, after insert, after delete) {
	    if(Trigger.isAfter) {
	   		if(trigger.isUpdate){
	   			for (Development_Plan__c newValues : Trigger.new){
	   				List<Match__c> matches = [select Id, Engagement__c from Match__c where Id = :newValues.Match_Name__c];
	   				Engagement__c engagement = [SELECT ID, Name, Sevis_UEV_SOA_Edit__c FROM Engagement__c WHERE ID = :matches[0].Engagement__c];
	   				if (newValues.Start__c != NULL && newValues.Start__c != Trigger.oldMap.get(newValues.Id).Start__c){
	   					//List<Match__c> matches = [select Id, Engagement__c from Match__c where Id = :newValues.Match_Name__c];
	   					Match__c match = matches[0];
	   					
	   					System.debug('*** Match ID is: ' + match.Id);
	   					List<Development_Plan__c> dev_plan_list= [select Id, Name, Start__c, Phase__c from Development_Plan__c where Match_Name__c = :match.Id and Start__c != null order by Start__c];
	   					List<Development_Plan__c> dev_plan_list_to_update = new List<Development_Plan__c>();
	   					if (dev_plan_list.size() > 0){
	   						Integer phase_number = 1;
	   						System.debug('*** Number of development plans found for match is ' + dev_plan_list.size());
	   						for (Development_Plan__c dev_plan : dev_plan_list){
        						System.debug('*** Now updating development plan ' + dev_plan.Name);
        						System.debug('*** Start date found is ' + dev_plan.Start__c);
        						System.debug('*** and it will receive a phase number of ' +phase_number);
	   							dev_plan.Phase__c = phase_number++;
	   							//dev_plan_list_to_update.add(dev_plan);
	   						}
	   					update dev_plan_list;
	   					}
	   					else System.debug('*** No development plans found corresponding to match');
	   				}
	   					   	if (engagement.Sevis_UEV_SOA_Edit__c == false && engagement != NULL){
		   						System.debug('*** Updating Engagement ' + engagement.Name);
		   						engagement.Sevis_UEV_SOA_Edit__c = true;
		   						update engagement;
		   					}
	   				
	   			}
	   		}
	   		else if (trigger.isInsert){
	   			for (Development_Plan__c newValues : Trigger.new){
	   				if (newValues.Start__c != NULL){
	   					List<Match__c> matches = [select Id, Engagement__c from Match__c where Id = :newValues.Match_Name__c];
	   					Match__c match = matches[0];
	   					Engagement__c engagement = [SELECT ID, Name, Sevis_UEV_SOA_Edit__c FROM Engagement__c WHERE ID = :matches[0].Engagement__c];
	   					System.debug('*** Match ID is: ' + match.Id);
	   					List<Development_Plan__c> dev_plan_list= [select Id, Name, Start__c, Phase__c from Development_Plan__c where Match_Name__c = :match.Id and Start__c != null order by Start__c];
	   					List<Development_Plan__c> dev_plan_list_to_update = new List<Development_Plan__c>();
	   					if (dev_plan_list.size() > 0){
	   						Integer phase_number = 1;
	   						System.debug('*** Number of development plans found for match is ' + dev_plan_list.size());
	   						for (Development_Plan__c dev_plan : dev_plan_list){
        						System.debug('*** Now updating development plan ' + dev_plan.Name);
        						System.debug('*** Start date found is ' + dev_plan.Start__c);
        						System.debug('*** and it will receive a phase number of ' +phase_number);
	   							dev_plan.Phase__c = phase_number++;
	   							//dev_plan_list_to_update.add(dev_plan);
	   						}
	   					update dev_plan_list;
	   					if (engagement.Sevis_UEV_SOA_Edit__c == false){
	   						engagement.Sevis_UEV_SOA_Edit__c = true;
	   						update engagement;
	   					}
	   					}
	   					else System.debug('*** No development plans found corresponding to match');
	   				}
	   			}	   			
	   		}
	   		else if (trigger.isDelete){
	   			for (Development_Plan__c newValues : Trigger.old){
	   				if (newValues.Start__c != NULL){
	   					List<Match__c> matches = [select Id, Engagement__c from Match__c where Id = :newValues.Match_Name__c];
	   					Match__c match = matches[0];
	   					Engagement__c engagement = [SELECT ID, Name, Sevis_UEV_SOA_Edit__c FROM Engagement__c WHERE ID = :matches[0].Engagement__c];
	   					System.debug('*** Match ID is: ' + match.Id);
	   					List<Development_Plan__c> dev_plan_list= [select Id, Name, Start__c, Phase__c from Development_Plan__c where Match_Name__c = :match.Id and Start__c != null order by Start__c];
	   					List<Development_Plan__c> dev_plan_list_to_update = new List<Development_Plan__c>();
	   					if (dev_plan_list.size() > 0){
	   						Integer phase_number = 1;
	   						System.debug('*** Number of development plans found for match is ' + dev_plan_list.size());
	   						for (Development_Plan__c dev_plan : dev_plan_list){
        						System.debug('*** Now updating development plan ' + dev_plan.Name);
        						System.debug('*** Start date found is ' + dev_plan.Start__c);
        						System.debug('*** and it will receive a phase number of ' +phase_number);
	   							dev_plan.Phase__c = phase_number++;
	   							//dev_plan_list_to_update.add(dev_plan);
	   						}
	   					update dev_plan_list;
	   					if (engagement.Sevis_UEV_SOA_Edit__c == false){
	   						engagement.Sevis_UEV_SOA_Edit__c = true;
	   						update engagement;
	   					}
	   					}
	   					else System.debug('*** No development plans found corresponding to match');
	   				}
	   			}	   			
	   		}
	    }
}