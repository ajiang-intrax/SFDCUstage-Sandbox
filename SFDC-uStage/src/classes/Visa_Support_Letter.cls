public class Visa_Support_Letter 
{
	public String EngagementID;
	public string ParticipantName {get; set;}
	public string ParticipantFname {get; set;}
	public string ParticipantLname {get; set;}
	public string ParticipantMname {get; set;}
	public Date ParticipantBDate {get; set;}
	public string Participantgender {get; set;}
	public string ParticipantBirthCity {get; set;}
	public string ParticipantBirthCountry {get; set;}
	public string ParticipantCitizenship {get; set;}
	public string ParticipantResidence {get; set;}
	public string ParticipantServLvl {get; set;}
	public Decimal ParticipantAge {get; set;}
	public string HCName {get; set;}
	public string HCStreet {get; set;}
	public string HCCity {get; set;}
	public string HCState {get; set;}
	public string HCZip {get; set;}
	public string HCCountry {get; set;}
	public string HCPhone {get; set;}
	public string HCPositionTitle {get; set;}
	public string HCCurrency {get; set;}
	public string PositionDesc {get; set;}
	public Decimal PositionRate {get; set;}
	public Date PositionStartDate {get; set;}
	public Date PositionEndDate {get; set;}
	public string PrimaryContactName {get; set;}
	public string PrimaryContactEmail {get; set;}
	
	public Visa_Support_Letter(ApexPages.StandardController controller)
	{
		EngagementID = controller.getId();
		Engagement__c engagement = [SELECT ID, Account_Id__c, Service_Level__c FROM Engagement__c WHERE ID = :EngagementID];
		
		Account pAccountDetails = [SELECT Name, FirstName, LastName,Middle_Name__pc, 
			PersonBirthdate, Gender__pc, Birth_City__pc, Birth_Country__pc,
			Citizenship__pc, Legal_Residence__pc, Age__pc
			FROM Account WHERE ID = :engagement.Account_Id__c];
			
		list<Match__c> MatchDetails = [SELECT ID, 
		Position_Name__r.Host_Company_Id__c,Position_Name__r.Title__c, Position_Name__r.Pay_Rate__c, Position_Name__r.Description__c, 
		Start_Date__c, End_Date__c,Position_Name__r.Host_Opportunity_Id__c, Position_Name__r.CurrencyIsoCode
		 FROM Match__c WHERE Engagement__c = :EngagementID AND Status__c = 'Confirmed'
		 ORDER BY CreatedDate ASC];
			
		ParticipantName = pAccountDetails.Name;
		ParticipantFname = pAccountDetails.FirstName;
		ParticipantLname = pAccountDetails.LastName;
		ParticipantMname = pAccountDetails.Middle_Name__pc;
		ParticipantBDate = pAccountDetails.PersonBirthdate;
		Participantgender = pAccountDetails.Gender__pc;
		ParticipantBirthCity = pAccountDetails.Birth_City__pc;
		ParticipantBirthCountry = pAccountDetails.Birth_Country__pc;
		ParticipantCitizenship = pAccountDetails.Citizenship__pc;
		ParticipantResidence = pAccountDetails.Legal_Residence__pc;
		ParticipantAge = pAccountDetails.Age__pc;
		
		if (engagement.Service_Level__c == 'Premium')
		{
			ParticipantServLvl = 'Yes';
		}
		else if (engagement.Service_Level__c == 'Independent')
		{
			ParticipantServLvl = 'No';
		}
		else 
		{
			ParticipantServLvl = '';
		}
		
		if (MatchDetails.size() > 0)
		{
			list<Account> HFAccountDetails = [SELECT Name,
			BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry, Phone
			FROM Account WHERE ID = :MatchDetails[0].Position_Name__r.Host_Company_Id__c];
			
			list <OpportunityContactRole> prContactID = [SELECT ID, ContactId, IsPrimary FROM OpportunityContactRole WHERE OpportunityId = :MatchDetails[0].Position_Name__r.Host_Opportunity_Id__c AND isPrimary= true];
			
			if (prContactID.size() > 0)
			{
				list <Contact> PrimaryContact = [SELECT name, email FROM Contact WHERE ID = :prContactID[0].ContactId];
				if (PrimaryContact.size() > 0)
				{
					PrimaryContactName = PrimaryContact[0].Name;
					PrimaryContactEmail = PrimaryContact[0].Email;
				}
				
			}
			
			if (HFAccountDetails.size() > 0)
			{
				HCName = HFAccountDetails[0].Name;
				HCStreet = HFAccountDetails[0].BillingStreet;
				HCCity = HFAccountDetails[0].BillingCity;
				HCState = HFAccountDetails[0].BillingState;
				HCZip = HFAccountDetails[0].BillingPostalCode;
				HCCountry = HFAccountDetails[0].BillingCountry;
				HCPhone = HFAccountDetails[0].phone;
			}
			
			HCPositionTitle = MatchDetails[0].Position_Name__r.Title__c;
			PositionDesc = MatchDetails[0].Position_Name__r.Description__c;
			PositionRate = MatchDetails[0].Position_Name__r.Pay_Rate__c;
			PositionStartDate = MatchDetails[0].Start_Date__c;
			PositionEndDate = MatchDetails[0].End_Date__c;
			HCCurrency = MatchDetails[0].Position_Name__r.CurrencyIsoCode;
			
		}
		
	}
	public void updNotification()
	{
		list<Notification__c> NotInfo = [SELECT ID, Status__c FROM Notification__c WHERE Engagement__c =: EngagementID AND Type__c = 'Visa Support Letter'];
		if (NotInfo.size() > 0)
		{
        NotInfo[0].Status__c = 'Confirmed';
        update NotInfo[0];
		}
		
	}
}