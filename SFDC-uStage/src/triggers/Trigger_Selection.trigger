trigger Trigger_Selection on Selection__c (after insert,after update) 
{
    set<ID> allPos = new set<ID>();
    set<ID> allEngg = new set<ID>();
        
    if(Trigger.isAfter) 
    {   
        if(trigger.isInsert)
        {
            for(Selection__c sel :trigger.new)
            {
                if(sel.Position__c != NULL && sel.Engagement__c != NULL)
                {
                    allPos.add(sel.Position__c);
                    allEngg.add(sel.Engagement__c);
                }
                
                if(sel.Intrax_Program__c == 'AuPairCare'){                           
                    Notification_Generator.callAPCNotifications(null, sel);//old,new,                                                                     
                }
                                
            }
            
            if (allPos.size() > 0 && allEngg.size() >0)
            {
                Sharing_Security_Controller.shareselection(allPos,allEngg);
            }
            
            
        }
        
        if(trigger.isUpdate)
        {
            for(Selection__c sel :trigger.new)
            {
                Selection__c selOld = Trigger.oldMap.get(sel.Id);                                       
                if(sel.Intrax_Program__c == 'AuPairCare'){                           
                    Notification_Generator.callAPCNotifications(selOld, sel);//old,new,                                                                     
                }
                
                //For Sharing
                if(sel.Position__c != NULL && sel.Engagement__c != NULL && Trigger.oldMap.get(sel.id).Status__c != Trigger.newMap.get(sel.id).Status__c && sel.Status__c=='Active')
                {
                    allPos.add(sel.Position__c);
                    allEngg.add(sel.Engagement__c);
                }
                
            }
            
            //For Sharing   
            if (allPos.size() > 0 && allEngg.size() >0)
            {
                Sharing_Security_Controller.shareselection(allPos,allEngg);
            }
            
        }
    } 
}