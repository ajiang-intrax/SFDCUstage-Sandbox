public without sharing class Rating_Controller {
	
	public list<Match__c> match{get;set;}
	public list<Rating__c> rating{get;set;}
	
	public string currentRating{get;set;}	
	public string score{get;set;}
	
	public string matchId {get;set;}
	
	public Rating_Controller(){

		if(ApexPages.CurrentPage().getParameters().get('mId') != null){
			match = [SELECT Id, Participant_Id__r.IsPersonAccount FROM Match__c 
						WHERE ID =: ApexPages.CurrentPage().getParameters().get('mId') LIMIT 1];
			
			rating = [SELECT Id, Score__c, Match__r.Participant_Id__r.isPersonAccount, createdById, LastModifiedDate 
						FROM Rating__c 
						WHERE Match__c =: match[0].Id 
						//AND CreatedById =: userInfo.getUserId()
						order by LastModifiedDate DESC LIMIT 1];
			if(rating.size() > 0){
				currentRating = rating[0].Score__c;
			}
		}
	}
	
	public string roundValue(string score){
		string finalScore;
				
		try{
			decimal scoreDec = decimal.ValueOf(score);			
			if( (scoreDec - math.floor(scoreDec)) < 0.49) finalScore = string.valueOf(math.floor(scoreDec) + 0.5);
			else finalScore = string.valueOf(math.floor(scoreDec)+1);
		}catch(Exception e){
			finalScore = '0';
		}
		
		return finalScore;
		
	}
	
	public PageReference saveRating(){
		system.debug('******* MatchId: ' + matchId);
		//system.debug('******* Rating Before: ' + rating[0].Id);
		
		if(ApexPages.CurrentPage().getParameters().get('mId') != null){
			list<Rating__c> lastRating = [SELECT Id, CreatedById FROM Rating__c 
									WHERE Match__c =: ApexPages.CurrentPage().getParameters().get('mId')
									order by CreatedDate desc
									];
			//system.debug('****** Rating after: ' + lastRating[0].id); 
			if(lastRating.size() > 0){
				if(lastRating[0].CreatedById == UserInfo.getUserId()){
					lastRating[0].Score__c = roundValue(score);
					try{
						update lastRating[0];
					}catch(Exception e){
						system.debug('***** ups! ' + e);
					}
				}else{
					try{
						Rating__c newRating = new Rating__c(
							Match__c = match[0].Id,
							Score__c = roundValue(score)			
						); 
						insert newRating;
					}catch(Exception e){
						system.debug('******* Impossible to insert new rating! ' +e);
					}
				}
			}else{
				try{
					Rating__c newRating = new Rating__c(
						Match__c = match[0].Id,
						Score__c = roundValue(score)			
					); 
					insert newRating;
				}catch(Exception e){
					system.debug('******* Impossible to insert new rating! ' +e);
				}
			}	
		}else{
			// mId not specified (we are on the listing pages)
			list<Rating__c> updateRating = [SELECT Score__c, Match__c, CreatedById FROM Rating__c 
												WHERE Match__c =: matchId
												//AND lastModifiedById =: userInfo.getUserId()
												order by LastModifiedDate DESC LIMIT 1];
			
			// If the last one created belong to the user, then update it. Otherwise, create new record							
			if(updateRating.size() > 0 && updateRating[0].CreatedById == userInfo.getUserId()){
				updateRating[0].Score__c = roundValue(score);
				try{
					update updateRating;
				}catch(Exception e){
					system.debug('***** Error! ' + e);
				}
			}else{
				try{
					Rating__c newRating = new Rating__c(
						Match__c = matchId,
						Score__c = roundValue(score)		
					); 
					insert newRating;
				}catch(Exception e){
					system.debug('******* Impossible to insert new rating! ' +e);
				}
			}
		}
				
		return null;
	}
}