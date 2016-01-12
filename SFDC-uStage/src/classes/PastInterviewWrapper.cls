public class PastInterviewWrapper {

public Selection__c se{get;set;}

    public PastInterviewWrapper(){
      se = new Selection__c();
    }

    public PastInterviewWrapper(Selection__c s){
        se = s;

    }
}