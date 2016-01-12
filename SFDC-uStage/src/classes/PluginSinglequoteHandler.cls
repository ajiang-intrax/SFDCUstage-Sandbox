global class PluginSinglequoteHandler implements Process.Plugin {


global Process.PluginResult invoke(Process.PluginRequest request) { 
  
      try{
      String cName = (String) request.inputParameters.get('CName');
      
      map<String,String> result = new map<String,String> ();
      String escapeCname;
      
      system.debug('@@@@@Host Company name: ' + cName);
        
      
      if(cName!= null && cName.contains('\'')){
        List<String> tmp =(cName).split('\'');
        if(tmp[0]!=null){
        escapeCname = tmp[0];  
        system.debug('**split name'+escapeCname); 
        }
      }
      else
      {
       escapeCname=cName;
      }
      result.put('escapeCName',escapeCname);
      
      return new Process.PluginResult(result);
      }
         
      catch(Exception e){
        system.debug('@@@@@ Exception in Process.PluginResult invoke() : ' + e);
        return null;
     }
      
    }
  
   // Returns the describe information for the interface
   global Process.PluginDescribeResult describe() { 
        Process.PluginDescribeResult result = new Process.PluginDescribeResult(); 
      
      
        result.inputParameters = new list<Process.PluginDescribeResult.InputParameter>{ 
               new Process.PluginDescribeResult.InputParameter('CName', 
                   Process.PluginDescribeResult.ParameterType.STRING, true)
              
            }; 
          
          
            result.outputParameters = new list<Process.PluginDescribeResult.OutputParameter>{
              new Process.PluginDescribeResult.OutputParameter('escapeCName', 
                   Process.PluginDescribeResult.ParameterType.STRING)
               
               
          };
           
        return result; 
    }

}