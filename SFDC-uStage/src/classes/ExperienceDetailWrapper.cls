public with sharing class ExperienceDetailWrapper {

public Experience_Detail__c ExperienceDetailChild {get; private set;}
public Integer ident {get; private set;}
   
public ExperienceDetailWrapper(Integer inIdent)
  {
   ident=inIdent;
   ExperienceDetailChild = new Experience_Detail__c(Name='Child');
   //Name='Child ' + ident --- child number
  }
  
public ExperienceDetailWrapper(Integer inIdent, Experience_Detail__c experienceDetail)
  {
   ident=inIdent;
   ExperienceDetailChild = experienceDetail;
  }

}