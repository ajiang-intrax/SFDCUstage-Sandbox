global class Batch_GoogleGeoProcesses implements Database.Batchable<sObject>, Database.AllowsCallouts,Schedulable {
global final String query;
global final String context;
global final String contextText;
	global Batch_GoogleGeoProcesses (String q){
		query = q;		
		//Accounts without igeolocate
		if(query.contains('ID NOT IN')){
			context = 'GeoLocating';
			contextText = 'Google GeoCoding Process :: Creating empty GeoLocate Records';
		}
        //Accounts withiGeoLocate but no lat/long
        else if(query.contains('GeoAddress__Latitude__s = NULL')){
            context = 'GeoCoding';
			contextText = 'Google GeoCoding Process :: Geo Coding | Creating lat long';
        }
		//Accounts with igeolocate and latlong. w/wo geomatch
		else if (query.contains('GeoAddress__Latitude__s != NULL')){
			context = 'GeoValidation';
			contextText = 'Google GeoCoding Process :: Geo Matching | Validating';
		}
	}

   global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator(query);
   }

   global void execute(Database.BatchableContext BC, List<sObject> scope){
   		System.debug('context---->'+context);
		System.debug('scope---->'+scope);
       
       	geoAssignmentValidation geoValidation = new geoAssignmentValidation();   		
        if(context=='GeoLocating'){       
            System.debug('ENTERED GeoLocating----->'); 
            geoValidation.HFAccWOIGeoLocList = scope;
            geoValidation.loadforBatch();
   		}
        else if(context=='GeoCoding'){     
            System.debug('ENTERED GeoCoding----->'); 
            geoValidation.igeosToBeGeoCoded = scope;
            geoValidation.loadforBatch();
        }
   		else if(context=='GeoValidation'){
   			System.debug('ENTERED GeoValidation----->');   			   			   			
   			geoValidation.igeosToBeValidated = scope;
   			geoValidation.loadforBatch();
   		}
    }
    
    global void execute(SchedulableContext ctx) {
   	   Database.executeBatch(this);
    }
	
	global void finish(Database.BatchableContext BC){
	   AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
	      TotalJobItems, CreatedBy.Email
	      FROM AsyncApexJob WHERE Id =
	      :BC.getJobId()];
	   // Send an email to the Apex job's submitter notifying of job completion.
	   Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	   String[] toAddresses = new String[] {a.CreatedBy.Email};
	   mail.setToAddresses(toAddresses);
	   mail.setSubject('ApexJobID:'+BC.getJobId()+contextText+' - '+a.Status);
	  if (context == 'GeoLocating'){
		   mail.setPlainTextBody
		   ('The Empty GeoLocates were created');
	   }
	   else if (context == 'GeoCoding'){
	   		mail.setPlainTextBody
		   ('The empty GeoLocates were geoCoded');
	   }
	   else if (context == 'GeoValidation'){
	   		mail.setPlainTextBody
		   ('GeoValidation done');
	   }
	   Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
	}
}