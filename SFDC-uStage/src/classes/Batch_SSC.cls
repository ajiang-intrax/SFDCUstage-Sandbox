global class Batch_SSC implements Database.Batchable<sObject>, DataBase.Stateful{
  
    global List<sObject> MainAssessments = new List<sObject>();
	     
	    global Batch_SSC(List<sObject> listMainAssessments)
	    {
	    	 system.debug('**listMainAssessments****'+listMainAssessments);
        MainAssessments = listMainAssessments;
         system.debug('**MainAssessments****'+MainAssessments);
	    }
	    
    global List<sObject> start(Database.BatchableContext BC ){        
     
     system.debug('**MainAssessments****'+MainAssessments);
        return MainAssessments;  
       
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope ){
     system.debug('**scope****'+scope);
       system.debug('**MainAssessments****'+MainAssessments);
     List<Database.SaveResult> sr = Database.insert(scope,true);
       }
          
               
      
    
    global void finish(Database.BatchableContext BC){
     
       system.debug('**MainAssessments****'+MainAssessments);   
    }

}