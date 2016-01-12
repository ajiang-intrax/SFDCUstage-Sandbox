public class EndPointGenerator {
	
	public static Map<String,String> endPointMap {get;set;}
	static{
		endPointMap = new Map<String,String>();
		List<ExternalEndPoints__mdt> allEndPoints = [select DeveloperName,endPoint__c from ExternalEndPoints__mdt where isActive__c = true];
		for (ExternalEndPoints__mdt endPoint : allEndPoints){
			endPointMap.put(endPoint.DeveloperName,endPoint.endPoint__c);
		}
	}   
	
	public static Boolean endPointExists(String serviceName){
		if (endPointMap.containsKey(serviceName)){
			return true;
		}
		else
			return false;
	}
	
	public static String getEndpoint(String serviceName){
		if (endPointExists(serviceName)){
			return endPointMap.get(serviceName);
		}
		else{
			return '';
		}
	}
}