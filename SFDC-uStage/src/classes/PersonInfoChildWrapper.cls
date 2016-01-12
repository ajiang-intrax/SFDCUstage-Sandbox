public with sharing class PersonInfoChildWrapper {
	
public Person_Info__c personInfoChild {get; private set;}
public Integer ident {get; private set;}
   
public PersonInfoChildWrapper(Integer inIdent)
  {
   ident=inIdent;
   personInfoChild = new Person_Info__c(Name='', Role__c = 'Child', Family_Member__c = true, RecordTypeId = constants.APC_Child_Record_Type_Id);
   //Name='Child ' + ident --- child number
  }
  
public PersonInfoChildWrapper(Integer inIdent, Person_Info__c childInfo)
  {
   ident=inIdent;
   personInfoChild = childInfo;
  }

}