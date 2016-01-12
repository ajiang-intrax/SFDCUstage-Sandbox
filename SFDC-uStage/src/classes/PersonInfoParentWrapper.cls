public with sharing class PersonInfoParentWrapper {
	
public Person_Info__c personInfoParent {get; private set;}
public Integer ident {get; private set;}
   
public PersonInfoParentWrapper(Integer inIdent)
  {
   ident=inIdent;
   personInfoParent = new Person_Info__c(Role__c = 'Parent', Family_Member__c = true , RecordTypeId = constants.APC_Parent_Record_Type_Id);
  }
  
public PersonInfoParentWrapper(Integer inIdent, Person_Info__c parentInfo)
  {
   ident=inIdent;
   personInfoParent = parentInfo;
  }

}