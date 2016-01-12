//Wpparer class to hold the opprotunity data with other parameters
public class OpportunityWrapper {
        
    //booloean property to hold the selected record
    public Boolean selected{get; set;}
    public Integer ranking {get; set;}
    public Double sim {get; set;}
    
    //Variable to hold the opportunity instance
    public Opportunity opportunity{get; set;}
    public Task oLI{get; set;}
    
    //constructor
    public OpportunityWrapper(Opportunity opportunity, Double sim, Integer ranking) {
         this.selected = false;
         this.sim = sim;
         this.ranking = ranking;
         this.opportunity = opportunity;
         this.oLI = new Task(WhatId = opportunity.Id);
    }
    
    //constructor
    public OpportunityWrapper(Opportunity opportunity) {
         this.selected = false;
         this.opportunity = opportunity;
         this.oLI = new Task(WhatId = opportunity.Id); 
    }
}