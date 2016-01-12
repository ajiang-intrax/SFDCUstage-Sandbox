public with sharing class PersonInfoFamilyWrapper {
	
public Person_Info__c personInfoFamily {get; private set;}
public Integer ident {get; private set;}
   
public PersonInfoFamilyWrapper(Integer inIdent)
  {
   ident=inIdent;
   personInfoFamily = new Person_Info__c(Role__c = 'Sibling', Family_Member__c = true , RecordTypeId = constants.APC_Spouse_Record_Type_Id);
  }
  
public PersonInfoFamilyWrapper(Integer inIdent, Person_Info__c FamilyInfo)
  {
   ident=inIdent;
   personInfoFamily = FamilyInfo;
  }
}