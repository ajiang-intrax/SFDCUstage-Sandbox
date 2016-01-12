public class EngagementRankRedirectionController {


      Engagement__c engagement;
      Engagement__c eng;
      public EngagementRankRedirectionController(ApexPages.StandardController controller) {
        
                 //Get program record Id
            engagement = (Engagement__c)controller.getRecord();
           system.debug('***** engagement: ' + engagement);
         
       }
       
       public PageReference redirect()
       {
        PageReference nextPage;
                system.debug('****** engagement in redirect: ' + engagement);
                eng=[Select e.RecordTypeId, e.Intrax_Program__c,e.RecordType.Name, e.Id, e.Opportunity_Id__c From Engagement__c e where e.Id =:engagement.Id];
                system.debug('******eng*****'+eng);
                if(eng.Intrax_Program__c == 'Internship')
                {
                nextPage = new PageReference('/apex/IGIParticipantRankingMatch');
                nextPage.getParameters().put('id',eng.Id);
                nextPage.getParameters().put('prog',eng.Intrax_Program__c);
                nextPage.setRedirect(true);
                return nextPage;
                }
                else if (eng.Intrax_Program__c == 'Ayusa')
                {
                nextPage = new PageReference('/apex/ParticipantRankingMatch');
                nextPage.getParameters().put('id',eng.Id);
                nextPage.getParameters().put('prog',eng.Intrax_Program__c);
                nextPage.setRedirect(true);
                return nextPage;
                }
                else
                return null;
           
                     
     
       }

}