//Wpparer class to hold the position data with other parameters
public with sharing class PositionWrapper {
	
	//booloean property to hold the selected record
    public Boolean selected{get; set;}
    public Integer ranking {get; set;}
    public Double sim {get; set;}
    
    //Variable to hold the opportunity instance
    public Position__c position {get; set;}
      public match__c mat{get; set;}
    
    //constructor
    public PositionWrapper(Position__c position, Double sim, Integer ranking) {
         this.selected = false;
         this.sim = sim;
         this.ranking = ranking;
         this.position = position;
          this.mat = new Match__c(Position_Name__c = position.Id);
    }
    
    //constructor
    public PositionWrapper(Position__c position) {
         this.selected = false;
         this.position = position;
         this.mat = new Match__c(Position_Name__c = position.Id);
    }
}