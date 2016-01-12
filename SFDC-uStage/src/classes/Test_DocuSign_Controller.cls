@isTest(SeeAllData=true)
public class Test_DocuSign_Controller 
{
    public static testMethod void MethodTCFinalTest() 
    {
        Engagement__c testEng = [SELECT ID, Name FROM Engagement__c LIMIT 1];
        ApexPages.currentPage().getParameters().put('ObjId', testEng.ID);
        ApexPages.currentPage().getParameters().put('event', 'SignComplete');
        ApexPages.currentPage().getParameters().put('uTypeStr', 'Participant');
        DocuSign_Controller ITFinal = new DocuSign_Controller();
        ITFinal.MethodTCFinal();
        
        ApexPages.currentPage().getParameters().put('ObjId', testEng.ID);
        ApexPages.currentPage().getParameters().put('event', 'ViewComplete');
        ApexPages.currentPage().getParameters().put('uTypeStr', 'Participant');
        DocuSign_Controller ITFinal1 = new DocuSign_Controller();
        ITFinal1.MethodTCFinal();
        
        ApexPages.currentPage().getParameters().put('ObjId', testEng.ID);
        ApexPages.currentPage().getParameters().put('event', 'Cancel');
        ApexPages.currentPage().getParameters().put('uTypeStr', 'Participant');
        DocuSign_Controller ITFinal2 = new DocuSign_Controller();
        ITFinal2.MethodTCFinal();
        
        ApexPages.currentPage().getParameters().put('ObjId', testEng.ID);
        ApexPages.currentPage().getParameters().put('event', 'Decline');
        ApexPages.currentPage().getParameters().put('uTypeStr', 'Participant');
        DocuSign_Controller ITFinal3 = new DocuSign_Controller();
        ITFinal3.MethodTCFinal();
        
        ApexPages.currentPage().getParameters().put('ObjId', testEng.ID);
        ApexPages.currentPage().getParameters().put('event', '');
        ApexPages.currentPage().getParameters().put('uTypeStr', 'Participant');
        DocuSign_Controller ITFinal4 = new DocuSign_Controller();
        ITFinal4.MethodTCFinal();
        
        ApexPages.currentPage().getParameters().put('ObjId', 'Test');
        ApexPages.currentPage().getParameters().put('event', 'SignComplete');
        ApexPages.currentPage().getParameters().put('uTypeStr', 'Participant');
        DocuSign_Controller ITFinal5 = new DocuSign_Controller();
        ITFinal5.MethodTCFinal();
        
    }
    
    public static testMethod void MethodIGITCFinalTest() 
    {
        Engagement__c testEng = [SELECT ID, Name FROM Engagement__c LIMIT 1];
        ApexPages.currentPage().getParameters().put('ObjId', testEng.ID);
        ApexPages.currentPage().getParameters().put('event', 'SignComplete');
        ApexPages.currentPage().getParameters().put('uTypeStr', 'Participant');
        DocuSign_Controller ITFinal = new DocuSign_Controller();
        ITFinal.MethodIGITCFinal();
        
        ApexPages.currentPage().getParameters().put('ObjId', testEng.ID);
        ApexPages.currentPage().getParameters().put('event', 'ViewComplete');
        ApexPages.currentPage().getParameters().put('uTypeStr', 'Participant');
        DocuSign_Controller ITFinal1 = new DocuSign_Controller();
        ITFinal1.MethodIGITCFinal();
        
        ApexPages.currentPage().getParameters().put('ObjId', testEng.ID);
        ApexPages.currentPage().getParameters().put('event', 'Cancel');
        ApexPages.currentPage().getParameters().put('uTypeStr', 'Participant');
        DocuSign_Controller ITFinal2 = new DocuSign_Controller();
        ITFinal2.MethodIGITCFinal();
        
        ApexPages.currentPage().getParameters().put('ObjId', testEng.ID);
        ApexPages.currentPage().getParameters().put('event', 'Decline');
        ApexPages.currentPage().getParameters().put('uTypeStr', 'Participant');
        DocuSign_Controller ITFinal3 = new DocuSign_Controller();
        ITFinal3.MethodIGITCFinal();
        
        ApexPages.currentPage().getParameters().put('ObjId', testEng.ID);
        ApexPages.currentPage().getParameters().put('event', '');
        ApexPages.currentPage().getParameters().put('uTypeStr', 'Participant');
        DocuSign_Controller ITFinal4 = new DocuSign_Controller();
        ITFinal4.MethodIGITCFinal();
        
        ApexPages.currentPage().getParameters().put('ObjId', 'Test');
        ApexPages.currentPage().getParameters().put('event', 'SignComplete');
        ApexPages.currentPage().getParameters().put('uTypeStr', 'Participant');
        DocuSign_Controller ITFinal5 = new DocuSign_Controller();
        ITFinal5.MethodIGITCFinal();
        
    }
    
    public static testMethod void MethodJobFinalTest() 
    {
        Match__c testMat = [SELECT ID, Name FROM Match__c LIMIT 1];
        ApexPages.currentPage().getParameters().put('ObjId', testMat.ID);
        ApexPages.currentPage().getParameters().put('event', 'SignComplete');
        ApexPages.currentPage().getParameters().put('uTypeStr', 'Participant');
        DocuSign_Controller ITFinal = new DocuSign_Controller();
        ITFinal.MethodJobFinal();
        
        ApexPages.currentPage().getParameters().put('ObjId', testMat.ID);
        ApexPages.currentPage().getParameters().put('event', 'ViewComplete');
        ApexPages.currentPage().getParameters().put('uTypeStr', 'Participant');
        DocuSign_Controller ITFinal1 = new DocuSign_Controller();
        ITFinal1.MethodJobFinal();
        
        ApexPages.currentPage().getParameters().put('ObjId', testMat.ID);
        ApexPages.currentPage().getParameters().put('event', 'Cancel');
        ApexPages.currentPage().getParameters().put('uTypeStr', 'Participant');
        DocuSign_Controller ITFinal2 = new DocuSign_Controller();
        ITFinal2.MethodJobFinal();
        
        ApexPages.currentPage().getParameters().put('ObjId', testMat.ID);
        ApexPages.currentPage().getParameters().put('event', 'Decline');
        ApexPages.currentPage().getParameters().put('uTypeStr', 'Participant');
        DocuSign_Controller ITFinal3 = new DocuSign_Controller();
        ITFinal3.MethodJobFinal();
        
        ApexPages.currentPage().getParameters().put('ObjId', testMat.ID);
        ApexPages.currentPage().getParameters().put('event', '');
        ApexPages.currentPage().getParameters().put('uTypeStr', 'Participant');
        DocuSign_Controller ITFinal4 = new DocuSign_Controller();
        ITFinal4.MethodJobFinal();
        
        ApexPages.currentPage().getParameters().put('ObjId', testMat.ID);
        ApexPages.currentPage().getParameters().put('event', 'SignComplete');
        ApexPages.currentPage().getParameters().put('uTypeStr', 'HostCompany');
        DocuSign_Controller ITFinal5 = new DocuSign_Controller();
        ITFinal.MethodJobFinal();
        
        ApexPages.currentPage().getParameters().put('ObjId', testMat.ID);
        ApexPages.currentPage().getParameters().put('event', 'ViewComplete');
        ApexPages.currentPage().getParameters().put('uTypeStr', 'HostCompany');
        DocuSign_Controller ITFinal6 = new DocuSign_Controller();
        ITFinal1.MethodJobFinal();
        
        ApexPages.currentPage().getParameters().put('ObjId', testMat.ID);
        ApexPages.currentPage().getParameters().put('event', 'Cancel');
        ApexPages.currentPage().getParameters().put('uTypeStr', 'HostCompany');
        DocuSign_Controller ITFinal7 = new DocuSign_Controller();
        ITFinal2.MethodJobFinal();
        
        ApexPages.currentPage().getParameters().put('ObjId', testMat.ID);
        ApexPages.currentPage().getParameters().put('event', 'Decline');
        ApexPages.currentPage().getParameters().put('uTypeStr', 'HostCompany');
        DocuSign_Controller ITFinal8 = new DocuSign_Controller();
        ITFinal3.MethodJobFinal();
        
        ApexPages.currentPage().getParameters().put('ObjId', testMat.ID);
        ApexPages.currentPage().getParameters().put('event', '');
        ApexPages.currentPage().getParameters().put('uTypeStr', 'HostCompany');
        DocuSign_Controller ITFinal9 = new DocuSign_Controller();
        ITFinal4.MethodJobFinal();
        
        ApexPages.currentPage().getParameters().put('ObjId', 'Test');
        ApexPages.currentPage().getParameters().put('event', 'SignComplete');
        ApexPages.currentPage().getParameters().put('uTypeStr', 'HostCompany');
        DocuSign_Controller ITFinal10 = new DocuSign_Controller();
        ITFinal5.MethodJobFinal();
        
    }
    
     public static testMethod void MethodBGCFinalTest() 
    {
        Member__c testMem = [SELECT ID, Name FROM Member__c LIMIT 1];
        ApexPages.currentPage().getParameters().put('ObjId', testMem.ID);
        ApexPages.currentPage().getParameters().put('event', 'SignComplete');
        ApexPages.currentPage().getParameters().put('uTypeStr', 'Participant');
        DocuSign_Controller ITFinal = new DocuSign_Controller();
        ITFinal.MethodBGCFinal();
        
        ApexPages.currentPage().getParameters().put('ObjId', testMem.ID);
        ApexPages.currentPage().getParameters().put('event', 'ViewComplete');
        ApexPages.currentPage().getParameters().put('uTypeStr', 'Participant');
        DocuSign_Controller ITFinal1 = new DocuSign_Controller();
        ITFinal1.MethodBGCFinal();
        
        ApexPages.currentPage().getParameters().put('ObjId', testMem.ID);
        ApexPages.currentPage().getParameters().put('event', 'Cancel');
        ApexPages.currentPage().getParameters().put('uTypeStr', 'Participant');
        DocuSign_Controller ITFinal2 = new DocuSign_Controller();
        ITFinal2.MethodBGCFinal();
        
        ApexPages.currentPage().getParameters().put('ObjId', testMem.ID);
        ApexPages.currentPage().getParameters().put('event', 'Decline');
        ApexPages.currentPage().getParameters().put('uTypeStr', 'Participant');
        DocuSign_Controller ITFinal3 = new DocuSign_Controller();
        ITFinal3.MethodBGCFinal();
        
        ApexPages.currentPage().getParameters().put('ObjId', testMem.ID);
        ApexPages.currentPage().getParameters().put('event', '');
        ApexPages.currentPage().getParameters().put('uTypeStr', 'Participant');
        DocuSign_Controller ITFinal4 = new DocuSign_Controller();
        ITFinal4.MethodBGCFinal();
        
        ApexPages.currentPage().getParameters().put('ObjId', 'Test');
        ApexPages.currentPage().getParameters().put('event', 'SignComplete');
        ApexPages.currentPage().getParameters().put('uTypeStr', 'Participant');
        DocuSign_Controller ITFinal5 = new DocuSign_Controller();
        ITFinal5.MethodBGCFinal();
        
    }
}