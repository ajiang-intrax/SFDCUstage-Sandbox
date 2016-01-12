public with sharing class SearchWrapper {

public Boolean checked{ get; set; }
public Applicant_Info__c sw { get; set;}
public Engagement__c eng{get;set;}

    public SearchWrapper(){
        sw = new Applicant_Info__c();
        eng = new Engagement__c();
        checked = false;
    }

    public SearchWrapper(Applicant_Info__c w){
        sw = w;
        checked = false;

    }
	
	public SearchWrapper(Engagement__c w){
        eng = w;
        checked = false;

    }

}