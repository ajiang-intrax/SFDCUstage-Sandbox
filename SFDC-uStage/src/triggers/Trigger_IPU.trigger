trigger Trigger_IPU on Intrax_Program_Upload__c (before insert, before update,before delete,after update,after insert) {
    Intrax_Program_Upload__c IPUU;
    if(Trigger.isAfter) {   
        if(trigger.isUpdate){
            
            for(Intrax_Program_Upload__c i :trigger.new){
                string strOldDesc = Trigger.oldMap.get(i.Id).Description__c;
                string strNewDesc =  Trigger.NewMap.get(i.Id).Description__c;
                if(strOldDesc!=strNewDesc)
                {
                IPUU = [select ID,Document_Guid__c,Document_service__c,Description__c,Delete_Pending__c from Intrax_Program_Upload__c where id = :i.Id];
                if (IPUU.Delete_Pending__c != true)
                    IPUUpdate.updateMeta(IPUU.Document_Guid__c , IPUU.Description__c,IPUU.Document_service__c);
                }
            }
            
            //B-01530
            for(Intrax_Program_Upload__c  ip: Trigger.new){
                Intrax_Program_Upload__c ipuOldD = Trigger.oldMap.get(ip.Id);
                if(ip.Position__c != NULL && ip.RecordTypeId !=Constants.AuPairCareHF_Record_Type_Id){
                    IUtilities.getAcceptedPhotoCount(Trigger.new);  
                }
                //JOSE B-02918 Adding Dynamic Content
                if(ip.Engagement__c != NULL){
                    Notification_Generator.callAPCNotifications(ipuOldD, ip);//old,new, 
                }
            }   
            
            system.debug('*****trigger.new insert********'+trigger.new);
            for(Intrax_Program_Upload__c  ip: Trigger.new){
                  if(ip.Delete_Pending__c == true)
                  {
                    IPUTriggerHelper.deleteIPU(ip.id);
                  }
            }
            /*
            list<String> ipList = new  list<String>();
            for(Intrax_Program_Upload__c  ip: Trigger.new){
                  if(ip.Delete_Pending__c == true)
                  {
                    //IPUTriggerHelper.deleteIPU(ip.id);
                    ipList.add(ip.id);
                  }
            }
            IPUTriggerHelper.deleteIPUBulk(ipList);
            */
         }
         
         //AYII 465 (Start)
         if(trigger.isInsert)
         {
            system.debug('*here we are****');
            string ProgCategory;
            Id AppId;
            List<Match__c> listMat = new List<Match__c>();
            List<Position__c> listPos = new List<Position__c>();
            List<Engagement__c> listEngg = new List<Engagement__c>();
            List<Applicant_Info__c> lstRelatedAppInfo = new List<Applicant_Info__c>();
            Map<id,id> IPUToBeUpdated = new Map<id,id>();
            Map<id,id> WTIPUToBeUpdated = new Map<id,id>();
            
            for(Intrax_Program_Upload__c ins :trigger.new)
            {
                system.debug('*here we are ins****'+ins);
                    if (ins.Document_Type__c != 'DS-2019' && ins.Document_Type__c != 'DS-7002-(Unsigned)')
                    {
                        list <Match__c> mat = [SELECT ID, SNK_Permission__c, Parent_Permission__c, Student_Permission__c, School_Permission__c, Host_Permission__c FROM Match__c WHERE ID = :ins.Match__c];
                        if (mat.size() > 0)
                        {
                            if (ins.Document_Type__c == 'SNK-Placement-Agreement' || ins.Document_Type__c == 'NP-Double-Placement-Agreement' || ins.Document_Type__c == 'PT-Double-Placement-Agreement' || ins.Document_Type__c == 'School-Permission' || ins.Document_Type__c == 'HF-Double-Placement-Agreement')
                            {
                                for (Match__c onemat : mat)
                                {
                                    if (ins.Document_Type__c == 'SNK-Placement-Agreement')
                                    {
                                        onemat.SNK_Permission__c = date.today();
                                    }
                                    if (ins.Document_Type__c == 'NP-Double-Placement-Agreement')
                                    {
                                        onemat.Parent_Permission__c = date.today();
                                    }
                                    if (ins.Document_Type__c == 'PT-Double-Placement-Agreement')
                                    {
                                        onemat.Student_Permission__c = date.today();
                                    }
                                    if (ins.Document_Type__c == 'School-Permission')
                                    {
                                        onemat.School_Permission__c = date.today();
                                    }
                                    if (ins.Document_Type__c == 'HF-Double-Placement-Agreement')
                                    {
                                        onemat.Host_Permission__c = date.today();
                                    }
                                    listMat.add(onemat);
                                }
                                
                            }
                        }
                        
                        list <Position__c> pos = [SELECT ID FROM Position__c WHERE ID = :ins.Position__c];
                        if (pos.size() > 0)
                        {
                            for (Position__c onepos : pos)
                            {
                                if (ins.Document_Type__c == 'HF-Orientation-Agreement')
                                {
                                    onepos.Orientation_Agreement__c = date.today();
                                    listpos.add(onepos);
                                }
                            }
                            
                        }
                        
                        list <Engagement__c> Engg = [SELECT ID,Intrax_Program__c,Initial_Match_Offer_Received__c FROM Engagement__c WHERE ID = :ins.Engagement__c];
                        system.debug('eng' +Engg);
                        if (Engg.size() > 0)
                        {
                            for (Engagement__c oneEngg : Engg)
                            {
                                if (ins.Document_Type__c == 'Student-Arrival-Orientation-Agreement')
                                {
                                    oneEngg.Orientation_Agreement__c = date.today();
                                    listEngg.add(oneEngg);
                                }
                                //B-03377 starts
                                if(ins.Document_Type__c == 'Offer-Document' && oneEngg.Intrax_Program__c == 'Work Travel')
                                {
                                 system.debug('rcvd' +oneEngg.Initial_Match_Offer_Received__c +ins.Document_Type__c +oneEngg.Intrax_Program__c);
                                 if(oneEngg.Initial_Match_Offer_Received__c == null)
                                 {
                                     system.debug('rcvd' +oneEngg.Initial_Match_Offer_Received__c);
                                     oneEngg.Initial_Match_Offer_Received__c = date.today();
                                 }
                                 if(oneEngg.Initial_Match_Offer_Accepted__c == null && ins.Review_Status__c == 'Accepted')
                                 {
                                     oneEngg.Initial_Match_Offer_Accepted__c = date.today();
                                 }
                                  listEngg.add(oneEngg);
                                }
                                //B-03377 ends
                            }
                        }
                        
                        if(ins.Applicant_Info__c!=null && ins.Engagement__c==null)
                        {
                
                            system.debug('*inside block****');
                            lstRelatedAppInfo = [Select a.Intrax_Region__c, a.Application_Level__c,a.Last_App_Sync__c,a.Application_Stage__c,a.Intrax_Program__c,a.RecordTypeId,a.engagement__c, a.Intrax_Program_Options__c, a.Intrax_Program_Category__c, a.Intrax_Id__c From Applicant_Info__c a where a.Id=:ins.Applicant_Info__c and a.RecordTypeId=:Constants.ICD_Intern_PT_Record_Type_Id  ];
                            system.debug('*inside block lstRelatedAppInfo****'+lstRelatedAppInfo);
                            if(lstRelatedAppInfo!=null && lstRelatedAppInfo.size()>0)
                            {
                                for(Applicant_Info__c ap :lstRelatedAppInfo)   
                                {
                                    ProgCategory= ap.Intrax_Program_Category__c;
                                    AppId = ap.Id;              
                                    if(ap.Application_Level__c == 'Main' && ap.Application_Stage__c =='Submitted' && ap.Last_App_Sync__c!=null)
                                        IPUToBeUpdated.put(ins.Id,ap.Engagement__c);
                                    //ins.Engagement__c = ap.engagement__c;
                        
                                }
                            }
                            
                            //B-01441 (Start)
                            List<Applicant_Info__c> lstWTRelatedAppInfo = [Select a.Intrax_Region__c, a.Application_Level__c,a.Last_App_Sync__c,a.Application_Stage__c,a.Intrax_Program__c,a.RecordTypeId,a.engagement__c, a.Intrax_Program_Options__c, a.Intrax_Program_Category__c, a.Intrax_Id__c From Applicant_Info__c a where a.Id=:ins.Applicant_Info__c and a.RecordTypeId=:Constants.WT_PT_Record_Type_Id];
                            system.debug('*inside block lstWTRelatedAppInfo****'+lstWTRelatedAppInfo);
                            if(lstWTRelatedAppInfo!=null && lstWTRelatedAppInfo.size()>0)
                            {
                                for(Applicant_Info__c wtap :lstWTRelatedAppInfo)   
                                {
                                    if(wtap.Engagement__c != NULL)
                                        WTIPUToBeUpdated.put(ins.Id,wtap.Engagement__c);
                                }
                            }
                            
                            //B-01441 (End)
                        }
                
                }
                
            }
            
            //B-01530     
            if(IPUToBeUpdated != null && IPUToBeUpdated.size()>0)
            {      
                try{                
                    IPUTriggerHelper.TagEngOnIPU(IPUToBeUpdated);
                    Notification_Generator.MarkIGINotifyComplete(AppId,ProgCategory);
                }
                catch(Exception e){
                    system.debug('********* IPUToBeUpdated  Error: ' + e);
                }
            }
            
            //B-01441 (Start)
            if(WTIPUToBeUpdated!=null && WTIPUToBeUpdated.size()>0)
            {                   
                IPUTriggerHelper.TagEngOnIPU(WTIPUToBeUpdated);
            }
            //B-01441 (End)
         
            if (listMat.size() > 0)
            {
                update listMat;
            }
            if (listpos.size() > 0)
            {
                update listpos;
            }
            if (listEngg.size() > 0)
            {
                update listEngg;
            }
         }
         
        
         //AYII 465 (End)
    }       
        if(Trigger.isBefore){
            if(trigger.isUpdate){
                list<String> engIds = new list<string>();
                for(Intrax_Program_Upload__c ipu : trigger.new){
                    string review_status_old = trigger.oldMap.get(ipu.Id).Review_Status__c;
                    string review_status_new = trigger.newMap.get(ipu.Id).Review_Status__c;
                    
                    if(review_status_old != review_status_new && review_status_new == 'Accepted' && (ipu.Document_Type__c == 'Participant-Eligibility-Form' || ipu.Document_Type__c == 'Offer-Document')){
                        engIds.add(ipu.Engagement__c);
                        //Engagement__c eng = [SELECT Id, Eligibility_Document_Accepted__c FROM Engagement__c WHERE Id =: ipu.Engagement__c];
                        //eng.Eligibility_Document_Accepted__c = date.today();
                        //update eng;
                    
                    }
                    
                }
                
                if(engIds.size() > 0){
                    list<Engagement__c> engs = [SELECT Id,Intrax_Program__c, Eligibility_Document_Accepted__c,Initial_Match_Offer_Received__c FROM Engagement__c WHERE Id IN: engIds];
                    if(engs.size() > 0){
                        for(Engagement__c e : engs){
                            e.Eligibility_Document_Accepted__c = date.today();  
                           if(e.Intrax_Program__c == 'Work Travel')
                             {
                              if(e.Initial_Match_Offer_Received__c == null)
                                 e.Initial_Match_Offer_Received__c = date.today();
                              if(e.Initial_Match_Offer_Accepted__c == null)
                                 e.Initial_Match_Offer_Accepted__c = date.today();   
                             } 
                           
                            
                        }
                        update engs;
                    }
                }
            }
            if(Trigger.isDelete) {
                 Intrax_Program_Upload__c loadDoc;
                 string docService;
                 string id;
                 string docGuid;
                 for(Intrax_Program_Upload__c ipu:trigger.old){
                    loadDoc = [Select Document_service__c,document_Guid__c,id from Intrax_Program_Upload__c where id =: ipu.id  ];
                    docService = loadDoc.Document_Service__c;
                    id=loadDoc.Id;
                    docGuid=loadDoc.Document_GUID__c;
                    system.debug('*******loadDoc**********'+loadDoc);
                    system.debug('******docService***********'+docService);
                    system.debug('**********id*******'+id);
                    system.debug('******docGuid***********'+docGuid);
                    IPUTriggerHelper.deleteUpload(docService,id,docGuid);
                 }
                //call helper class method to execute the logic to update the related opportunity record
                //IPUTriggerHelper.deleteUpload(docService,id,docGuid);
                
                IUtilities.DecreaseAcceptedPhotoCount(trigger.old);     
         
                
            }
            
            // B-02503 (Start)
            if(Trigger.isInsert)
            {
             system.debug('INSERT HERE');   
                for(Intrax_Program_Upload__c insipu : trigger.new)
                {
                    if(insipu.Applicant_Info__c != NULL && insipu.Document_Type__c != 'DS-2019' && insipu.Document_Type__c != 'DS-7002-(Unsigned)' && insipu.Account__c == NULL)
                    {
                        list<Applicant_Info__c> appt = [SELECT Name, Account__c, Position__c FROM Applicant_Info__c WHERE ID =: insipu.Applicant_Info__c AND Account__c != NULL];
                        if(appt != NULL && appt.size()>0)
                        {
                            insipu.Account__c = appt[0].Account__c;
                            if(appt[0].Position__c != NULL)
                            {
                                insipu.Position__c = appt[0].Position__c;
                            }
                        }
                    }
                }
                // B-02503 (End) 
             }

            

    }

    
}