trigger Trigger_Group on Group__c (after insert, after update,before insert, before update) {
 
 
 if(trigger.isBefore){
 	if((trigger.isInsert) ||  (trigger.isUpdate))
 	{
 		string newString = ''; 
    	  string newIPO='';
    	    string strIPOValues;
			boolean blnExists=false;
	   for(Group__c grp: trigger.new){
           
         if(grp.Intrax_Program_Option__c!=null)
          {
       strIPOValues= grp.Intrax_Program_Option__c;
          }
         
         
         If((grp.Intrax_Program_Category__c=='Business' || grp.Intrax_Program_Category__c=='Information Media & Communications' || grp.Intrax_Program_Category__c=='Public Administration & Law' || grp.Intrax_Program_Category__c=='Engineering')) 
         {
         
         	newIPO += 'Business Internship';         	
         } 
         else if(grp.Intrax_Program_Category__c=='Social Development')  
         {
         	
         	newIPO += 'Social Development';
         } 
         else if(grp.Intrax_Program_Category__c=='Hospitality & Tourism')  
         {
         
         	newIPO += 'Hospitality Internship';
         }  
         if(strIPOValues!=null)
         {
         if(strIPOValues.contains('Practical Training') || strIPOValues.contains('Internship Group') || strIPOValues.contains('Internship - J1') || strIPOValues.contains('WEST'))
         blnExists = true;
         
           List<String> partsIPO = strIPOValues.split(';');      
             if(blnExists)
             {             
             for(String s: partsIPO)
             {
             if(s.contains('Practical Training'))
             newString = newString + s + ';' ;
          
              if(s.contains('Internship Group'))
             newString = newString + s + ';' ;
             
              if(s.contains('Internship - J1'))
             newString = newString + s + ';' ;
             
              if(s.contains('WEST'))
             newString = newString + s + ';' ;
             
             }
             }
          }
             system.debug('**news-3 **'+newString );
         
         if(grp.Intrax_Program_Category__c  != null && grp.Intrax_Program__c=='Internship')
         {
            grp.Intrax_Program_Option__c= newString + newIPO ;
         }
 	}
 	}       
        
  
        }
}