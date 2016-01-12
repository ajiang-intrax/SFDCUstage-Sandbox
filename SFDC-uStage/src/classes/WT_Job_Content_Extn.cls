public class WT_Job_Content_Extn 
{
	public String MatchID;
	//public string ParticipantFname {get; set;}
	//public string ParticipantLname {get; set;}
	//public string ParticipantMname {get; set;}
	public string ParticipantName {get; set;}
	public string ParticipantIntraxID {get; set;}
	public string ParticipantSEVISID {get; set;}
	public Date EngagementStartDate {get; set;}
	public Date EngagementEndDate {get; set;}
	public Date ParticipantBDate {get; set;}
	public string Participantgender {get; set;}
	public string ParticipantBirthCity {get; set;}
	public string ParticipantBirthCountry {get; set;}
	public string ParticipantStreet {get; set;}
	public string ParticipantCity {get; set;}
	public string ParticipantState {get; set;}
	public string ParticipantZip {get; set;}
	public string ParticipantCountry {get; set;}
	public string ParticipantCitizenship {get; set;}
	public string ParticipantPhone {get; set;}
	public string ParticipantResidence {get; set;}
	public string ParticipantPersonMobile {get; set;}
	public string ParticipantSchool {get; set;}
	public string ParticipantEmail {get; set;}
	
	
	public string HCName {get; set;}
	//public string HCLname {get; set;}
	public string HCIndustry {get; set;}
	public string HCStreet {get; set;}
	public string HCCity {get; set;}
	public string HCState {get; set;}
	public string HCZip {get; set;}
	public string HCCountry {get; set;}
	public string HCPhone {get; set;}
	public string HCEmail {get; set;}
	public string HCWebsite {get; set;}
	public string HCEIN {get; set;}
	public string HCWorkerComp {get; set;}
	public string HCWorkerCompCarrier {get; set;}
	
	public string PositionTitle {get; set;}
	public string PositionCode {get; set;}
	public Decimal PositionRate {get; set;}
	public Date PositionStartDate {get; set;}
	public Date PositionEndDate {get; set;}
	
	public string PositionStreet {get; set;}
	public string PositionStreet2 {get; set;}
	public string PositionPostalCode {get; set;}
	public string PositionCountry {get; set;}	
	public string PositionCity {get; set;}
	public string PositionState {get; set;}
	public string PositionDesc {get; set;}
	public string PositionDuties {get; set;}
	public string PositionPayfrq {get; set;}
	public string PositionHrsWk {get; set;}
	public Decimal PositionOvertimeRate {get; set;}
	public string PositionTipped {get; set;}
	public string PositionOverTime {get; set;}
	public string PositionTypical {get; set;}
	public string PositionNotes {get; set;}
	public string PositionSupplies {get; set;}
	public Decimal PositionSuppliesCost {get; set;}
	public string PositionSpecialNotes {get; set;}
	public string HCPolicies {get; set;}
	public string HCProvidedHousing {get; set;}
	public string PositionSupervisorFname {get; set;}
	public string PositionSupervisorLname {get; set;}
	public string PositionSupervisorRole {get; set;}
	
	public string AccomodateHCRecommended {get; set;}
	public String AccomodateHCArranged {get; set;}
	public Decimal AccomodateHCEstimatedCost {get; set;}
	public string AccomodateHCAdditionalCostsDesc {get; set;}
	public Decimal AccomodateHCAdditionalCosts {get; set;}
	public String AccomodateHCCommuteOptions {get; set;}
	public Decimal AccomodateHCCommuteCost {get; set;}
	public String AccomodateHCEstimatedDistance {get; set;}
	public String AccomodateHCTransportationProvided {get; set;}
	public String AccomodateHCGenderRestriction {get; set;}
	public String AccomodateHCDescription {get; set;}
	public String AccomodateSiteHCType {get; set;}
	public String AccomodateSiteHCFeatures {get; set;}
	public String AccomodateSiteHCAddlInfo {get; set;}
	
	public String OpportunityDtlsSession {get; set;}
	public String OpportunityDtlsProgramYear {get; set;}
	
	public String HCSigningName {get; set;}
	public String HCSigningTitle {get; set;}
	
	//public list<Accommodation_Option__c> listAccomodationOtion{get; set;}
	
	public WT_Job_Content_Extn(ApexPages.StandardController controller)
	{
		//listAccomodationOtion = new list<Accommodation_Option__c>();
		MatchID = controller.getId();
		
		Match__c MatchDetails = [SELECT ID, Engagement__r.Account_Id__c, Engagement__r.SEVIS_ID__c,
		Engagement__r.Engagement_Start__c, Engagement__r.Engagement_End__c,
		Position_Name__r.Host_Company_Id__c,Position_Name__r.Title__c, Position_Name__r.Code__c,
		Position_Name__r.Pay_Rate__c, Position_Name__r.Engagement_Start__c, Position_Name__r.Engagement_End__c,
		Position_Name__r.Street__c, Position_Name__r.Street_2__c, Position_Name__r.Postal_Code__c, Position_Name__r.Country__c,
		Position_Name__r.City__c, Position_Name__r.State__c, Position_Name__r.Description__c, Position_Name__r.Required_Duties__c,
		Position_Name__r.Pay_Frequency__c,Position_Name__r.Employment_Hrs_Wk__c, Position_Name__r.Overtime_Rate__c,
		Position_Name__r.Tipped_Position__c,Position_Name__r.Overtime_Available__c, Position_Name__r.Typical_Schedule__c,
		Position_Name__r.Pay_Notes__c, Position_Name__r.Supplies_Required__c, Position_Name__r.Supplies_Cost__c,
		Position_Name__r.Special_Notes__c, Position_Name__r.Company_Provided_Housing__c,
		Position_Name__r.ID, Position_Name__r.Host_Opportunity_Id__c,
		Position_Name__r.Position_Supervisor__r.FirstName, Position_Name__r.Position_Supervisor__r.LastName,
		Position_Name__r.Supervisor_Role__c, Start_Date__c, End_Date__c
		 FROM Match__c WHERE ID = :MatchID];
		 
		list<Opportunity> OpportunityDtls = [SELECT ID, Season__c, Program_Year__c FROM Opportunity WHERE ID = :MatchDetails.Position_Name__r.Host_Opportunity_Id__c];
		
		
		
		Account pAccountDetails = [SELECT Name, Intrax_Id__c,
			PersonBirthdate, Gender__pc, Birth_City__pc, Birth_Country__pc,PersonMailingStreet,
			PersonMailingCity, PersonMailingState, PersonMailingPostalCode, PersonMailingCountry,
			Citizenship__pc,Phone, Legal_Residence__pc, PersonMobilePhone, School_Name__pc, PersonEmail
			FROM Account WHERE ID = :MatchDetails.Engagement__r.Account_Id__c];
			
		Account HFAccountDetails = [SELECT Name, Intrax_Id__c,
			PersonBirthdate, Gender__pc, Birth_City__pc, Birth_Country__pc,BillingStreet,
			BillingCity, BillingState, BillingPostalCode, BillingCountry,
			Citizenship__pc,Phone, Legal_Residence__pc, PersonMobilePhone, School_Name__pc, Email_Business__c,
			Industry,Website,EIN__c,Workers_Comp_Policy_Number__c,Worker_Comp_Provider__c,
			Company_Policies__c
			FROM Account WHERE ID = :MatchDetails.Position_Name__r.Host_Company_Id__c];
		
		/*list<Accommodation_Option__c> listAccomodationOtion = [SELECT ID ,Host_Recommended__c,Host_Arranged__c,
		Estimated_Cost__c,Additional_Costs_Description__c, Additional_Costs__c,Commute_Options__c,
		Commute_Cost__c, Estimated_Distance__c, Transportation_Provided__c, Gender_Restriction__c,
		Description__c, Accommodation_Site__r.Type__c, Accommodation_Site__r.Features__c,
		Accommodation_Site__r.Additional_Information__c	
		FROM Accommodation_Option__c 
		WHERE Account__r.Id = :MatchDetails.Position_Name__r.Host_Company_Id__c
		//AND Position_Name__c = :MatchDetails.Position_Name__r.ID 
		//AND Opportunity_Name__c =:MatchDetails.Position_Name__r.Host_Opportunity_Id__c
		];*/
		
		list<User> HFSignDetails = [Select Id, Name, email, title from User where Id =: UserInfo.getUserId()]; 
		
		if (HFSignDetails.size() > 0)
		{
			HCSigningName = HFSignDetails[0].Name;
			HCSigningTitle = HFSignDetails[0].Title;
		}
			
		ParticipantName = pAccountDetails.Name;
		//ParticipantLname = pAccountDetails.LastName;
		//ParticipantMname = '';
		ParticipantIntraxID = pAccountDetails.Intrax_Id__c;	
		ParticipantSEVISID = MatchDetails.Engagement__r.SEVIS_ID__c;
		EngagementStartDate = MatchDetails.Engagement__r.Engagement_Start__c;
		EngagementEndDate = MatchDetails.Engagement__r.Engagement_End__c;
		ParticipantBDate = pAccountDetails.PersonBirthdate;
		Participantgender = pAccountDetails.Gender__pc;
		ParticipantBirthCity = pAccountDetails.Birth_City__pc;
		ParticipantBirthCountry = pAccountDetails.Birth_Country__pc;
		ParticipantStreet = pAccountDetails.PersonMailingStreet;
		ParticipantCity = pAccountDetails.PersonMailingCity;
		ParticipantState = pAccountDetails.PersonMailingState;
		ParticipantZip = pAccountDetails.PersonMailingPostalCode;
		ParticipantCountry = pAccountDetails.PersonMailingCountry;
		ParticipantCitizenship = pAccountDetails.Citizenship__pc;
		ParticipantPhone = pAccountDetails.Phone;
		ParticipantResidence = pAccountDetails.Legal_Residence__pc;
		ParticipantPersonMobile = pAccountDetails.PersonMobilePhone;
		ParticipantSchool = pAccountDetails.School_Name__pc;
		ParticipantEmail = pAccountDetails.PersonEmail;
		
		HCName = HFAccountDetails.Name;
		//HCLname = HFAccountDetails.LastName;
		HCIndustry = HFAccountDetails.Industry;
		HCStreet = HFAccountDetails.BillingStreet;
		HCCity = HFAccountDetails.BillingCity;
		HCState = HFAccountDetails.BillingState;
		HCZip = HFAccountDetails.BillingPostalCode;
		HCCountry = HFAccountDetails.BillingCountry;
		HCPhone = HFAccountDetails.Phone;
		HCEmail = HFAccountDetails.Email_Business__c;
		HCWebsite = HFAccountDetails.Website;
		HCEIN = HFAccountDetails.EIN__c;
		HCWorkerComp = HFAccountDetails.Workers_Comp_Policy_Number__c;
		HCWorkerCompCarrier = HFAccountDetails.Worker_Comp_Provider__c;
		
		PositionSupervisorFname = MatchDetails.Position_Name__r.Position_Supervisor__r.FirstName;
		PositionSupervisorLname = MatchDetails.Position_Name__r.Position_Supervisor__r.LastName;
		PositionSupervisorRole = MatchDetails.Position_Name__r.Supervisor_Role__c;
		
		PositionTitle = MatchDetails.Position_Name__r.Title__c;
		PositionCode = MatchDetails.Position_Name__r.Code__c;
		PositionRate = MatchDetails.Position_Name__r.Pay_Rate__c;
		//PositionStartDate = MatchDetails.Position_Name__r.Engagement_Start__c;
		//PositionEndDate = MatchDetails.Position_Name__r.Engagement_End__c;
		PositionStartDate = MatchDetails.Start_Date__c;
		PositionEndDate = MatchDetails.End_Date__c;
		PositionCity = MatchDetails.Position_Name__r.City__c;
		PositionState = MatchDetails.Position_Name__r.State__c;
		
		PositionStreet = MatchDetails.Position_Name__r.Street__c;
		PositionStreet2 = MatchDetails.Position_Name__r.Street_2__c;
		PositionPostalCode = MatchDetails.Position_Name__r.Postal_Code__c;
		PositionCountry = MatchDetails.Position_Name__r.Country__c;
		
		PositionDesc = MatchDetails.Position_Name__r.Description__c;
		PositionDuties = MatchDetails.Position_Name__r.Required_Duties__c;
		PositionPayfrq = MatchDetails.Position_Name__r.Pay_Frequency__c;
		PositionHrsWk = MatchDetails.Position_Name__r.Employment_Hrs_Wk__c;
		PositionOvertimeRate = MatchDetails.Position_Name__r.Overtime_Rate__c;
		PositionTipped = MatchDetails.Position_Name__r.Tipped_Position__c;
		if (MatchDetails.Position_Name__r.Overtime_Available__c)
		{
			PositionOverTime = 'Yes';
		}
		else
		{
			PositionOverTime = 'No';
		}
		//PositionOverTime = MatchDetails.Position_Name__r.Overtime_Available__c;
		
		PositionTypical = MatchDetails.Position_Name__r.Typical_Schedule__c;
		PositionNotes = MatchDetails.Position_Name__r.Pay_Notes__c;	
		PositionSupplies = MatchDetails.Position_Name__r.Supplies_Required__c;
		PositionSuppliesCost = MatchDetails.Position_Name__r.Supplies_Cost__c;
		PositionSpecialNotes = MatchDetails.Position_Name__r.Special_Notes__c;
		HCPolicies = HFAccountDetails.Company_Policies__c;
		HCProvidedHousing = MatchDetails.Position_Name__r.Company_Provided_Housing__c;
		
		if (OpportunityDtls.size() > 0)
		{
			OpportunityDtlsSession = OpportunityDtls[0].Season__c;
			OpportunityDtlsProgramYear = OpportunityDtls[0].Program_Year__c;
		}
		
		AccomodateHCRecommended = 'No';
		AccomodateHCArranged = 'No';
		AccomodateHCTransportationProvided = 'No';
		
		/*if (AccomodationOtion.size() > 0)
		{
			for (integer i = 0; i < AccomodationOtion.size(); i++)
			{
				if (AccomodationOtion[i].Host_Recommended__c)
				{
					AccomodateHCRecommended = 'Yes';
				}
				else
				{
					AccomodateHCRecommended = 'No';
				}
				
				if (AccomodationOtion[i].Host_Arranged__c)
				{
					AccomodateHCArranged = 'Yes';
				}
				else
				{
					AccomodateHCArranged = 'No';
				}
				//AccomodateHCRecommended = AccomodationOtion[i].Host_Recommended__c;
				//AccomodateHCArranged = AccomodationOtion[i].Host_Arranged__c;
				AccomodateHCEstimatedCost = AccomodationOtion[i].Estimated_Cost__c;
				AccomodateHCAdditionalCostsDesc = AccomodationOtion[i].Additional_Costs_Description__c;
				AccomodateHCAdditionalCosts = AccomodationOtion[i].Additional_Costs__c;
				AccomodateHCCommuteOptions = AccomodationOtion[i].Commute_Options__c;
				AccomodateHCCommuteCost = AccomodationOtion[i].Commute_Cost__c;
				AccomodateHCEstimatedDistance = AccomodationOtion[i].Estimated_Distance__c;
				
				if (AccomodationOtion[i].Transportation_Provided__c)
				{
					AccomodateHCTransportationProvided = 'Yes';
				}
				else
				{
					AccomodateHCTransportationProvided = 'No';
				}
				
				//AccomodateHCTransportationProvided = AccomodationOtion[i].Transportation_Provided__c;
				AccomodateHCGenderRestriction = AccomodationOtion[i].Gender_Restriction__c;
				AccomodateHCDescription = AccomodationOtion[i].Description__c;
				AccomodateSiteHCType = AccomodationOtion[i].Accommodation_Site__r.Type__c;
				AccomodateSiteHCFeatures = AccomodationOtion[i].Accommodation_Site__r.Features__c;
				AccomodateSiteHCAddlInfo = AccomodationOtion[i].Accommodation_Site__r.Additional_Information__c;	
			}
		}*/
	}
	
	    public list<Accommodation_Option__c> getAccOptionInfo()
	    {
	    Match__c MtchDetails = [SELECT Position_Name__r.Host_Company_Id__c FROM Match__c WHERE ID = :MatchID];
		 
        list<Accommodation_Option__c> listAccomodationOtion = [SELECT ID ,Name, Host_Recommended__c,Host_Arranged__c,
		Estimated_Cost__c,Additional_Costs_Description__c, Additional_Costs__c,Commute_Options__c,
		Commute_Cost__c, Estimated_Distance__c, Transportation_Provided__c, Gender_Restriction__c,
		Description__c, Accommodation_Site__r.Type__c, Accommodation_Site__r.Features__c,
		Accommodation_Site__r.Additional_Information__c	
		FROM Accommodation_Option__c 
		WHERE Account__r.Id = :MtchDetails.Position_Name__r.Host_Company_Id__c
		//AND Position_Name__c = :MatchDetails.Position_Name__r.ID 
		//AND Opportunity_Name__c =:MatchDetails.Position_Name__r.Host_Opportunity_Id__c
		];
        return listAccomodationOtion;
    }
}