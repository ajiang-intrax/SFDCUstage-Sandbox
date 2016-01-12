global class PluginSharingObject implements Process.Plugin {

// The main method to be implemented. The Flow calls this at runtime.  

global Process.PluginResult invoke(Process.PluginRequest request) { 
        // Get the subject of the Chatter post from the flow
        String sObjectID = (String) request.inputParameters.get('sObjectID');
        String SharingUser = (String) request.inputParameters.get('SharingUser');
        String S_Object = (String) request.inputParameters.get('S_Object');
               
        system.debug('******sObjectID: ' + sObjectID);
        system.debug('******SharingUser: ' + SharingUser);
        system.debug('******SObject: ' + S_Object);
   
        //get User from Application 
        //list<Applicant_Info__c> applicationList = [SELECT Id, Name, CreatedBy__c from Applicant_Info__c where Id =: ApplicationID];
        //system.debug('******applicationList: ' + applicationList);
        
       
        //sharing assessment with selected User 
        try{
        	
		  if(S_Object == 'Assessment__c'){
			  list<Assessment__Share> lstAssShare = new list<Assessment__Share>();
			  Assessment__Share  assShare = new Assessment__Share();
			  assShare.ParentId = sObjectID;
			  assShare.UserOrGroupId = SharingUser;
			  assShare.AccessLevel = 'Read';
			  lstAssShare.add(assShare);
			  List<Database.SaveResult> sr = Database.insert(lstAssShare,false);
          }
        
        }catch(Exception e){
        	system.debug('Exception: ' + e);
        }
                    
       
        // return to Flow
        Map<String,Object> result = new Map<String,Object>(); 
        return new Process.PluginResult(result); 
    } 

    // Returns the describe information for the interface
    global Process.PluginDescribeResult describe() { 
        Process.PluginDescribeResult result = new Process.PluginDescribeResult(); 
        //result.Name = "flowchatplugin";
        //result.Tag = "chat";
        result.inputParameters = new 
           List<Process.PluginDescribeResult.InputParameter>{ 
               new Process.PluginDescribeResult.InputParameter('sObjectID', 
               Process.PluginDescribeResult.ParameterType.STRING, true),
               new Process.PluginDescribeResult.InputParameter('SharingUser', 
               Process.PluginDescribeResult.ParameterType.STRING, true), 
                new Process.PluginDescribeResult.InputParameter('S_Object', 
               Process.PluginDescribeResult.ParameterType.STRING, true)
           
            }; 
        result.outputParameters = new List<Process.PluginDescribeResult.OutputParameter>{ }; 
       
       return result; 
      
        
   }
    
}