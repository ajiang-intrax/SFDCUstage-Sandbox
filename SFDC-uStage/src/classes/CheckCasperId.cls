public class CheckCasperId {
    public string nameFile{get;set;}
    public Blob contentFile{get;set;}
    public class Wrapper{
        public string casper {get;set;}
        public string asset {get;set;}
        public string applnid {get;set;}
        public string applnname {get;set;}
    }
    public List<Wrapper> wrap_list {get;set;}
    String[] filelines = new String[]{};
    List<Applicant_Info__c> appInfo;
    List<Applicant_Info__c> qrylist;

    public Pagereference ReadFile()
    {
        nameFile=contentFile.toString();
        filelines = nameFile.split('\n');
        List<String> inputvalues = new List<String>();
        List<String> inputassest = new List<String>();
        for (Integer i=0;i<filelines.size();i++)
         {
            String[] s= filelines[i].split(',');
            //System.debug('String split'+s[0]);
            String[] s1=s[0].split('\r');
            String[] s2=s[1].split('\r');
          //  system.debug('Input string'+s1[0]);
            inputvalues.add(s1[0]);
            inputassest.add(s2[0]);
            
         }
       // system.debug('Inputs'+inputvalues);
       // system.debug('Assests'+inputassest);
        Map<String, String> caspasst = new Map<String,String>();
        for(Integer i=0;i<inputvalues.size();i++)
        {
            caspasst.put(inputvalues[i], inputassest[i]);
        }
        System.debug('Map**'+caspasst);
        String query ;
        query = 'Select Id,Name,Casper_Id__c from Applicant_Info__c WHERE Casper_Id__c IN :inputvalues order by Casper_Id__c desc nulls last limit 1000';  
        List<Applicant_Info__c> qryresult =  Database.query(query);
        Map<String, Applicant_Info__c> appMap=new Map<String, Applicant_Info__c>();
        for(Applicant_Info__c a:qryresult)
        { 
         appMap.put(a.Casper_Id__c, a);  
        }
        wrap_list= new List<Wrapper>();
        for(Integer i=0;i<caspasst.size();i++)
        {
            Wrapper w=new Wrapper();
            if(caspasst.containsKey(inputvalues[i])){
                if(appMap.containskey(inputvalues[i])){
                   w.casper=inputvalues[i];
                   w.asset=caspasst.get(inputvalues[i])+'-'+inputvalues[i]+'.flv';
                   Applicant_Info__c aInfo=appMap.get(inputvalues[i]);
                   w.applnid=aInfo.Id;
                   w.applnname=aInfo.Name;
                   wrap_list.add(w); 
                }
                else{
                   w.casper=inputvalues[i];
                   w.asset=caspasst.get(inputvalues[i])+'-'+inputvalues[i]+'.flv';
                   w.applnid='Not Available';
                   w.applnname='Not Available'; 
                   wrap_list.add(w); 
                }    
            }
                   
        }
    
       return null;
    }  
    public List<Wrapper> getAppId()
    {
        if(wrap_list!= NULL && wrap_list.size()>0)
                return wrap_list;                 
        else
            return null;
    }            
    
}