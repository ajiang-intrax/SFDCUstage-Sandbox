public with sharing class MatchWrapper {
   public Id MatchId {get; set;}
    //public List<Selectoption> lstRequestedDates {get; set;}
    public string Request1{get;set;}
    public string Request2{get;set;}
    public string Request3{get;set;}
     public string strCompName {get;set;}
      public string strPosName {get;set;}
    public string strSelectedResponse{get;set;}
    public string InterviewStatus{get;set;}
    public string response{get;set;}
    public boolean reject {get; set
            {
                reject = value;
            }
        }
 public boolean notAllowed {get; set
            {
                notAllowed = value;
            }
        }
    public integer Counter{get;set;}
}