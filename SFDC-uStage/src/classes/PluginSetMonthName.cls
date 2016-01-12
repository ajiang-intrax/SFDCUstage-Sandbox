global class PluginSetMonthName implements Process.Plugin {


global Process.PluginResult invoke(Process.PluginRequest request) { 
		// Integer of the HF DUE DATE Month
	    
	    try{
	    DateTime DueDate = (DateTime) request.inputParameters.get('DueDate');
	    
	    Date myDate = date.newinstance(DueDate.year(), DueDate.month(), DueDate.day());
	    
	    map<String,String> result = new map<String,String> ();
	    String MonthName;
	    
	   	system.debug('@@@@@DueDate: ' + DueDate);
        
        //system.debug('****** Potential Matches: ' + avProcessor.potentialMatchesList);
        if(DueDate != null){
        	
        	//Step 1 get the month Name
        	Integer currentMonth = myDate.month();
			
			if(currentMonth == 1){
				MonthName = 'January';
			}else if(currentMonth == 2){
				MonthName = 'February';
			}else if(currentMonth == 3){
				MonthName = 'March';
			}else if(currentMonth == 4){
				MonthName = 'April';
			}else if(currentMonth == 5){
				MonthName = 'May';
			}else if(currentMonth == 6){
				MonthName = 'June';
			}else if(currentMonth == 7){
				MonthName = 'July';
			}else if(currentMonth == 8){
				MonthName = 'August';
			}else if(currentMonth == 9){
				MonthName = 'September';
			}else if(currentMonth == 10){
				MonthName = 'October';
			}else if(currentMonth == 11){
				MonthName = 'November';
			}else if(currentMonth == 12){
				MonthName = 'December';
			}
			result.put('out_MonthName',MonthName);
			
			//Step 2 set next Due Date
			
			String nextDueDate;
			Integer DayDueDate = (myDate.addMonths(2).toStartOfMonth() - 1).day();
			Integer MonthDueDate = (myDate.addMonths(2).toStartOfMonth() - 1).month();
			Integer YearDueDate = (myDate.addMonths(2).toStartOfMonth() - 1).year();
			
			nextDueDate = string.valueof(YearDueDate) + '-' + string.valueof(MonthDueDate) + '-' + string.valueof(DayDueDate);
			
			system.debug('@@@@@nextDueDate: ' + nextDueDate);
			
			result.put('out_nextDueDate',nextDueDate);
			
	    	
	    }
		
		return new Process.PluginResult(result);
         
	    }catch(Exception e){
	    	system.debug('@@@@@ Exception in Process.PluginResult invoke() : ' + e);
	    	return null;
	    }
	    
	}
	
	 // Returns the describe information for the interface
    global Process.PluginDescribeResult describe() { 
        Process.PluginDescribeResult result = new Process.PluginDescribeResult(); 
        //result.Name = "flowchatplugin";
        //result.Tag = "chat";
        result.inputParameters = new list<Process.PluginDescribeResult.InputParameter>{ 
               new Process.PluginDescribeResult.InputParameter('DueDate', 
               		Process.PluginDescribeResult.ParameterType.DATETIME, true)
              
            }; 
        	
        	
            result.outputParameters = new list<Process.PluginDescribeResult.OutputParameter>{
            	new Process.PluginDescribeResult.OutputParameter('out_MonthName', 
               		Process.PluginDescribeResult.ParameterType.STRING),
           		new Process.PluginDescribeResult.OutputParameter('out_nextDueDate', 
               		Process.PluginDescribeResult.ParameterType.STRING)
           		
        	};
           
        return result; 
    }

}