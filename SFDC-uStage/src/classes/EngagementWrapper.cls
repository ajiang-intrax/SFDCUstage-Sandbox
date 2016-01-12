public class EngagementWrapper {


        
    //booloean property to hold the selected record
    public Boolean selected{get; set;}
    public Integer ranking {get; set;}
    public Double sim {get; set;}
    public match__c mat{get; set;}
    //Variable to hold the opportunity instance
    public Engagement__c engagement{get; set;}
    public Task oLI{get; set;}
    
    //constructor
    public EngagementWrapper(Engagement__c engagement, Double sim, Integer ranking) {
         this.selected = false;
         this.sim = sim;
         this.ranking = ranking;
         this.engagement = engagement;
         this.mat = new Match__c(Engagement__c = engagement.Id);
         this.oLI = new Task(WhatId = engagement.Id);
    }
    
    //constructor
    public EngagementWrapper(Engagement__c engagement) {
         this.selected = false;
         this.engagement = engagement;
         this.mat = new Match__c(Engagement__c = engagement.Id);
         this.oLI = new Task(WhatId = engagement.Id);
    }
}