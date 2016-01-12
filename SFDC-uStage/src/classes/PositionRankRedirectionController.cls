public class PositionRankRedirectionController {
      Position__c position;
      Position__c pos;
      
      public PositionRankRedirectionController(ApexPages.StandardController controller) {        
           //Get program record Id
           position = (Position__c)controller.getRecord();
           system.debug('***** position: ' + position);         
       }
       
       public PageReference redirect(){
        	PageReference nextPage;
            system.debug('****** position in redirect: ' + position);
            pos=[Select p.RecordTypeId, p.Intrax_Program__c,p.RecordType.Name, p.Id, p.Host_Opportunity_Id__c, p.Host_Company_Id__c From Position__c p where p.Id =:position.Id];
            system.debug('******pos*****'+pos);
            if(pos.Intrax_Program__c == 'Internship' || pos.Intrax_Program__c == 'Work Travel'){
                nextPage = new PageReference('/apex/RankingMatch');
                nextPage.getParameters().put('id',pos.Id);
                nextPage.getParameters().put('prog',pos.Intrax_Program__c);
                nextPage.setRedirect(true);
                return nextPage;
            }else if (pos.Intrax_Program__c == 'Ayusa'){
                nextPage = new PageReference('/apex/AyusaHFRankMatch');
                nextPage.getParameters().put('id',pos.Id);
                nextPage.getParameters().put('prog',pos.Intrax_Program__c);
                nextPage.setRedirect(true);
                return nextPage;
            }else if(pos.Intrax_Program__c == 'AuPairCare'){
            	nextPage = new PageReference('/apex/apc_hf_rank_match');
                nextPage.getParameters().put('id',pos.Id);
                nextPage.getParameters().put('prog',pos.Intrax_Program__c);
                nextPage.setRedirect(true);
                return nextPage;
            }else return null;  
       }

}