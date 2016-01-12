public without sharing class CSignatureGenerator_Member {
    public List<Member__c> memberList { get; set; }
    public string type { get; set; }

    public CSignatureGenerator_Member () {}
    
    public void getMembers(){
     
            memberList = [Select m.Role__c,m.ESSN__c, m.Residency_Status__c, m.Name,m.Account_Name__r.PersonEmail, m.Account_Name__c, m.Last_Name__c,m.email__c, m.Intrax_Program_Option__c, m.Id, m.First_Name__c, m.City__c, m.Background_Check__c, m.Background_Check_Required__c, m.Background_Check_Msg__c, m.Background_Check_Id__c, m.Background_Check_Consent_Received__c, m.Background_Check_By__c, m.Background_Check_At__c, m.Age__c From Member__c m  
					where m.Intrax_program_option__c ='Ayusa High School' and m.Age__c>=18 and m.Residency_Status__c!='Lives Elsewhere' and m.Background_Check__c = 'Not Required' and m.BGC_Signed_Date__c=null  AND m.Account_Name__c IN (SELECT Host_Company_Id__c FROM position__c 
					where Match_Active_Count__c!=0 and Engagement_Start__c <=today 
					AND Engagement_End__c >= today) order by  m.lastmodifieddate asc];
        }            
    }