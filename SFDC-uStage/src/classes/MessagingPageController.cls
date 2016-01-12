/**
 * An apex page controller that exposes the Notification Messaging functionality and redirect to login redirection
 */

public with sharing class MessagingPageController {
       
      public static String matchAndReplace(String regEx,String sourceString, String replacementString){
        // First, instantiate a new Pattern object "MyPattern"
        pattern MyPattern = pattern.compile(regEx);
        
        // Then instantiate a new Matcher object "MyMatcher"
        Matcher MyMatcher = MyPattern.matcher(sourceString);
        
        // You can use the system static method assert to verify the match
        return MyMatcher.replaceAll(replacementString);
        }
       
       public static List<Site_Message__c> checkmsg(){
       
           List<Site_Message__c> lstsysmsges= new List<Site_Message__c>();
           string SiteName= Site.getName();
           Datetime currentDateTime = System.now();
           system.debug('debug::siteid'+siteName );
           
           if(!Test.isRunningTest()){
           lstsysmsges =[select id,Type__c,Summary__c,Display_Start_Date_Time__c,Display_End_Date_Time__c,Planned_Start_Date_Time__c,Planned_End_Date_Time__c,Message__c,Sites__c,User_Interests__c,Title__c from Site_Message__c where Display_Start_Date_Time__c <= :currentDateTime and (Display_End_Date_Time__c >= :currentDateTime or Display_End_Date_Time__c = null) 
           and sites__c includes (:SiteName) and Type__c =: 'System Message'];
           }
           else{
           lstsysmsges =[select id,Type__c,Summary__c,Display_Start_Date_Time__c,Display_End_Date_Time__c,Planned_Start_Date_Time__c,Planned_End_Date_Time__c,Message__c,Sites__c,User_Interests__c,Title__c from Site_Message__c WHERE Type__c =: 'System Message' limit 1];
           }
           system.debug('debug::Size of List'+lstsysmsges);
           return lstsysmsges;  
       }
       
       public static List<Site_Message__c> checkPriorityAnnouncement(){
       
           List<Site_Message__c> lstAnnouncements= new List<Site_Message__c>();
           string SiteName= Site.getName();
           Datetime currentDateTime = System.now();
           string userType, defaultConIP;          
           
           User u = [SELECT Id, Type__c, ContactId, Contact.Intrax_Programs__c, Contact.PTR_Portal_Intrax_Program_Default__c FROM User WHERE Id=:UserInfo.getUserId() LIMIT 1];
           if(u!=NULL){
                userType = u.Type__c;    
                if(u.Contact.PTR_Portal_Intrax_Program_Default__c != null){
                	defaultConIP = u.Contact.PTR_Portal_Intrax_Program_Default__c;
                }           
           }
           system.debug('debug::userType'+userType);           
           
           String sOQLQueryForAnn = 'SELECT id,Type__c,Summary__c,Promote_To_Front__c,Target_User_Type__c,Intrax_Program__c,Display_Start_Date_Time__c,Display_End_Date_Time__c,Planned_Start_Date_Time__c,Planned_End_Date_Time__c,Message__c,Sites__c,User_Interests__c,CreatedDate,Title__c FROM Site_Message__c WHERE Display_Start_Date_Time__c <= :currentDateTime AND (Display_End_Date_Time__c >= :currentDateTime OR Display_End_Date_Time__c = NULL)'
                                    +' AND sites__c INCLUDES (:SiteName) AND Type__c = \''+'Announcement'+'\' AND Target_User_Type__c=:userType AND Promote_To_Front__c = TRUE AND'; //ORDER BY Promote_To_Front__c DESC, CreatedDate DESC';
           
           if(defaultConIP != null){
           		sOQLQueryForAnn += ' Intrax_Program__c INCLUDES(\'' + defaultConIP + '\') AND';
           }
             
           system.debug('debug::sOQLQueryForAnn'+sOQLQueryForAnn);    
           //Trim String
           sOQLQueryForAnn.trim();
      
           //If query ends with 'AND' 
           if(sOQLQueryForAnn.endsWith('AND')) {   
                
               //fetching the value in between two 'AND's
               sOQLQueryForAnn = sOQLQueryForAnn.subString(0, sOQLQueryForAnn.lastIndexOf('AND')); 
           }  
           
           
           sOQLQueryForAnn += ' ORDER BY ' + 'CreatedDate' + ' DESC';                  
           system.debug('debug::sOQLQueryForAnn'+sOQLQueryForAnn);
           lstAnnouncements = Database.query(sOQLQueryForAnn);                 
           
           system.debug('debug::Size of Priority Announcements'+lstAnnouncements.size());
           return lstAnnouncements;     
       }
       
       public static List<Site_Message__c> checkAnnouncement(){
       
           List<Site_Message__c> lstAnnouncements= new List<Site_Message__c>();
           string SiteName= Site.getName();
           Datetime currentDateTime = System.now();
           string userType, defaultConIP;           
           
           User u = [SELECT Id, Type__c, ContactId, Contact.Intrax_Programs__c, Contact.PTR_Portal_Intrax_Program_Default__c FROM User WHERE Id=:UserInfo.getUserId() LIMIT 1];
           if(u!=NULL){
                userType = u.Type__c;                                  
                if(u.ContactId != null && u.Contact.PTR_Portal_Intrax_Program_Default__c != null){
                    defaultConIP = u.Contact.PTR_Portal_Intrax_Program_Default__c;                                 
                }              
           }
           system.debug('debug::userType'+userType);           
           
           String sOQLQueryForAnn = 'SELECT id,Type__c,Summary__c,Promote_To_Front__c,Target_User_Type__c,Intrax_Program__c,Display_Start_Date_Time__c,Display_End_Date_Time__c,Planned_Start_Date_Time__c,Planned_End_Date_Time__c,Message__c,Sites__c,User_Interests__c,CreatedDate,Title__c FROM Site_Message__c WHERE Display_Start_Date_Time__c <= :currentDateTime AND (Display_End_Date_Time__c >= :currentDateTime OR Display_End_Date_Time__c = NULL)'
                                    +' AND sites__c INCLUDES (:SiteName) AND Type__c = \''+'Announcement'+'\' AND Target_User_Type__c=:userType AND Promote_To_Front__c = FALSE AND'; //ORDER BY Promote_To_Front__c DESC, CreatedDate DESC';
           
           if(defaultConIP != null){
           		sOQLQueryForAnn += ' Intrax_Program__c INCLUDES(\''+ defaultConIP + '\') AND';
           }     
                           
               
           //Trim String
           sOQLQueryForAnn.trim();
      	   system.debug('debug::sOQLQueryForAnn'+sOQLQueryForAnn+'::::');
           //If query ends with 'AND' 
           if(sOQLQueryForAnn.endsWith('AND')) {   
                
               //fetching the value in between two 'AND's
               sOQLQueryForAnn = sOQLQueryForAnn.subString(0, sOQLQueryForAnn.lastIndexOf('AND')); 
           } 
           
           
           sOQLQueryForAnn += ' ORDER BY ' + 'CreatedDate' + ' DESC';                  
           system.debug('debug::sOQLQueryForAnn'+sOQLQueryForAnn);
           lstAnnouncements = Database.query(sOQLQueryForAnn);                 
           
           system.debug('debug::Size of Announcements'+lstAnnouncements.size());
           return lstAnnouncements;     
       }
       
       public static List<Site_Message__c> checkAnnouncement_Top3(){       
                        
           List<Site_Message__c> nonPriorAnn = new List<Site_Message__c>();
           List<Site_Message__c> priorityAnn = new List<Site_Message__c>();
           List<Site_Message__c> nonPriorAnn_Top3 = new List<Site_Message__c>();
           
           nonPriorAnn = checkAnnouncement();
           priorityAnn = checkPriorityAnnouncement();
           
           if(priorityAnn!=NULL){  
           		//if priority 0; non-prior 3 
           		if(priorityAnn.size()==0 ){
	           		integer count = 0;
	           		for(Site_Message__c a: nonPriorAnn){
	           			count++;
	           			if(count<=3)
	           			nonPriorAnn_Top3.add(a);           			
	           		}
	           }  
	           //if priority 1; non-prior 2      	
	           else if(priorityAnn.size()==1 ){
	           		integer count = 0;
	           		for(Site_Message__c a: nonPriorAnn){
	           			count++;
	           			if(count<=2)
	           			nonPriorAnn_Top3.add(a);           			
	           		}
	           }
	           //if priority 2; non-prior 1
	           else if(priorityAnn.size()==2 ){
	           		integer count = 0;
	           		for(Site_Message__c a: nonPriorAnn){
	           			count++;
	           			if(count<=1)
	           			nonPriorAnn_Top3.add(a);           			
	           		}
	           }	           
           }
           
           system.debug('debug::Size of nonPriorAnn_Top3'+nonPriorAnn_Top3.size());
           return nonPriorAnn_Top3;     
       }
       
       public static List<Site_Message__c> checkPriorAnnouncement_Top3(){                               
          
           List<Site_Message__c> priorityAnn = new List<Site_Message__c>();
           List<Site_Message__c> PriorAnn_Top3 = new List<Site_Message__c>();
                      
           priorityAnn = checkPriorityAnnouncement();
           
           if(priorityAnn!=NULL && priorityAnn.size()>0){  
           		//return only top 3           		
           		integer count = 0;
           		for(Site_Message__c p: priorityAnn){
           			count++;
           			if(count<=3)
           			PriorAnn_Top3.add(p);           			
           		}	                    
           }
           
           system.debug('debug::Size of PriorAnn_Top3'+PriorAnn_Top3.size());
           return PriorAnn_Top3;     
       }
       
       public String processSOQLQueryString(String sOQLString) {
        
        //String to hold the sOQLQuery String
        String sOQLQueryForsObject;
        
        //Trim String
        sOQLQueryForsObject = sOQLString.trim();
  
        //If query ends with 'AND' 
        if(sOQLQueryForsObject.endsWith('AND')) {   
            
            //fetching the value in between two 'AND's
            sOQLQueryForsObject = sOQLQueryForsObject.subString(0, sOQLQueryForsObject.lastIndexOf('AND')); 
        }        
        //If  the query ends with 'WHERE' i.e. unfilled values     
        if(sOQLQueryForsObject.endsWith('WHERE')){
        
            //fetching the value in between two 'WHERE's
            sOQLQueryForsObject = sOQLQueryForsObject.subString(0, sOQLQueryForsObject.lastIndexOf('WHERE'));             
        }         
        //Return string
        return sOQLQueryForsObject;
    }
    

}