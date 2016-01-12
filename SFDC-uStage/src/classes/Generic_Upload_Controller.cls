public class Generic_Upload_Controller {
  public List<Position__c> lstPos;
  public string partialUrl {get;set;}
  public string derivedUrl{get;set;}
  public String strEid{get;set;}
  public string strUrl{get;set;}
  public string strRef {get;set;}
  public String envId {get;set;}
  public String orgId {get;set;}
  public String retParam{get;set;}
  public PageReference nextPage;
  public List<Applicant_Info__c> lstApp;
  //public List<Candidate__c> lstCand;
  public List<Engagement__c> lstCand;
  public List<Account> lstAcc;
  public List<Match__c> lstMatch;
  public List<Opportunity> lstOpp;
  public List<Position_Info__c> lstPosInf;
  public List<Person_Info__c> lstPerInf;
  public List<Case> lstCas;
  public List<Group__c> lstGrp;
  public List<User_Profile__c> lstUsrPro;
  public static boolean isApexNotTested= True;
  public static string applicantId;

    public Generic_Upload_Controller()
     {
       
        // redirect();
        
       
     }
     
     public PageReference redirect()
     {
     
        if(isApexNotTested)
        {
        strRef = ApexPages.currentPage().getHeaders().get('Referer');
        }
        else
        {
         strRef = 'https://cs15.salesforce.com/servlet/servlet.Integration?lid=00be0000000QHwU&eid='+applicantId+'&ic=1&retURL=%2Fa0Ue0000000J4eb&wrapMassAction=1&scontrolCaching=1';
        }
         system.debug('*******strRef*******'+strRef); 
         system.debug('*******Site.getCurrentSiteUrl()  *******'+Site.getCurrentSiteUrl()  ); 
         system.debug('******* ApexPages.currentPage()  *******'+ ApexPages.currentPage()  );
       
        nextPage = new PageReference(Constants.UploadServiceUrl); 
         system.debug('*******nextPage*******'+nextPage);
          
        orgId = UserInfo.getOrganizationId();
        envId= Constants.CONFG_ENV;
       
        
           system.debug('*******nextPage*******'+nextPage);    
        //strUrl=strRef.substringAfter('https://');
        //strUrl=strUrl.substringBefore('.salesforce.com');
     
    
        /*if(strRef.contains('eid'))
        {
            strEid=strRef.substringAfter('eid=');
             system.debug('*******strEid*******'+strEid);
            strEid=strEid.substringBefore('&ic');
             system.debug('*******strEid*******'+strEid);
        }*/
        
        strEid = ApexPages.currentPage().getParameters().get('eid');
        nextPage.getParameters().put('OrgId',orgId);
      

          lstApp =[Select Id, Name,type__c,RecordType.Name,Intrax_Program__c from Applicant_Info__c  WHERE id=: strEid limit 1];
          if(lstApp!=null && lstApp.size()!=0)
          {
            nextPage.getParameters().put('rType','app');
            for(Applicant_Info__c app :lstApp)
            {
                if (app.Type__c == 'Participant')
                {
                    //Check for centers application
                    if(app.RecordType.Name == 'Centers') {
                       nextPage.getParameters().put('pid','centers-pt');    
                    } else if(app.RecordType.Name == 'ICD Intern PT' || app.RecordType.Name == 'PW Participant') {
                       nextPage.getParameters().put('pid','igi-pt');
                    } else if(app.RecordType.Name == 'Work Travel PT') {
                       nextPage.getParameters().put('pid','wt-pt');
                    } else if(app.RecordType.Name == 'AuPairCare HF') {
                       nextPage.getParameters().put('pid','apc-hf');
                    } else if(app.RecordType.Name == 'AuPairCare PT') {
                       nextPage.getParameters().put('pid','apc-pt');
                    }                      
                    else {
                        nextPage.getParameters().put('pid','ayusa-pt');
                    }
                }
                else if (app.Type__c == 'Host Family' && app.RecordType.Name == 'Ayusa HF')
                {
                    nextPage.getParameters().put('pid','ayusa-hf');
                }
                else if (app.Type__c == 'Host Family' && app.RecordType.Name == 'AuPairCare HF')
                {
                   nextPage.getParameters().put('pid','apc-hf');
                }
            }
          }
          
          lstPos =[Select Id, Name from Position__c  WHERE id=: strEid limit 1];
          if(lstPos!=null && lstPos.size()!=0)
          {
            nextPage.getParameters().put('rType','pos');            
            nextPage.getParameters().put('pid','upload_pos');           
          }
          lstPosInf =[Select Id, Name from Position_Info__c  WHERE id=: strEid limit 1];
          if(lstPosInf!=null && lstPosInf.size()!=0)
          {
            nextPage.getParameters().put('rType','pos_inf');            
            nextPage.getParameters().put('pid','upload_pos_inf');           
          } 
          lstPerInf =[Select Id, Name from Person_Info__c  WHERE id=: strEid limit 1];
          if(lstPerInf!=null && lstPerInf.size()!=0)
          {
            nextPage.getParameters().put('rType','per_inf');            
            nextPage.getParameters().put('pid','upload_per_inf');           
          }              
          lstCas =[Select Id from Case  WHERE id=: strEid limit 1];
          if(lstCas!=null && lstCas.size()!=0)
          {
            nextPage.getParameters().put('rType','cas');            
            nextPage.getParameters().put('pid','upload_cas');           
          }                  
          lstOpp =[Select Id, Name from Opportunity  WHERE id=: strEid limit 1];
          if(lstOpp!=null && lstOpp.size()!=0)
          {
            nextPage.getParameters().put('rType','opp');
            nextPage.getParameters().put('pid','upload_opp');
          }
          lstMatch =[Select Id, Name from Match__c  WHERE id=: strEid limit 1];
          if(lstMatch!=null && lstMatch.size()!=0)
          {
            nextPage.getParameters().put('rType','mat');
            nextPage.getParameters().put('pid','upload_mat');
          }
          lstCand =[Select Id, Name from Engagement__c  WHERE id=: strEid limit 1];
          if(lstCand!=null && lstCand.size()!=0)
          {
             nextPage.getParameters().put('rType','eng');
             nextPage.getParameters().put('pid','upload_eng');
          }
          lstAcc =[Select Id, Name from Account WHERE id=: strEid limit 1];
          if(lstAcc!=null && lstAcc.size()!=0)
          {
             nextPage.getParameters().put('rType','acc');
             nextPage.getParameters().put('pid','upload_acc');
          }
          lstUsrPro =[Select Id, Name from User_Profile__c WHERE id=: strEid limit 1];
          if(lstUsrPro!=null && lstUsrPro.size()!=0)
          {
             nextPage.getParameters().put('rType','usr_pro');
             nextPage.getParameters().put('pid','upload_usr_pro');
          }
          lstGrp =[Select Id, Name from Group__c WHERE id=: strEid limit 1];
          if(lstGrp!=null && lstGrp.size()!=0)
          {
             nextPage.getParameters().put('rType','grp');
             nextPage.getParameters().put('pid','upload_grp');
          }
          ID sID = strEid;
          nextPage.getParameters().put('aid',sID);
          
          string retString;
          if(Site.getCurrentSiteUrl() != null){
            system.debug('***** Trying to set retParam');
            retString = Site.getCurrentSiteUrl() + sID;
            //retString = Site.getCurrentSiteUrl().removeEnd('/') + '/' + sID;
            system.debug('####### retString' +retString);
          //    system.debug('####### Site.getCurrentSiteUrl().removeEnd('/')' +Site.getCurrentSiteUrl().removeEnd('/'));
            //retParam = EncodingUtil.urlEncode(retString,'UTF-8');
            system.debug('####### retParam' +retParam);
            nextPage.getParameters().put('retparam',retString);
          }else{
          //    system.debug('We are coming from SFDC directly (not communities): ' + ApexPages.currentPage().getHeaders().get('Referer') );
          
          strUrl=Constants.source;
          system.debug('***** Trying to set strUrl: ' + strUrl);
          system.debug('***** Trying to set envId: ' + envId);
          nextPage.getParameters().put('src',strUrl); 
          nextPage.getParameters().put('env',envId);  
          }
          
          
          //nextPage.getParameters().put('aid',strEid);
          system.debug('*******nextPage*******'+nextPage);
        nextPage.setRedirect(false);
   
        
        return nextPage;
     }

}