public with sharing class SkylinkXMLParsing 
{
    public static string xmlval = '';
    public static integer startChangeID = 0;
    public static integer endChangeID = 0;
    
    public set<string> IntraxIDList;
    public list<AuPairTravelInfo> TravelInfoList; 
    public map<string,AuPairTravelInfo> TravelInfoMaps;
    
    public SkylinkXMLParsing()
    {
    	IntraxIDList = new set<string>();
        TravelInfoList = new list<AuPairTravelInfo>();
        TravelInfoMaps = new map<string,AuPairTravelInfo>();
    }
    public void fetchXMLData()
    {
    	try{
       /* Travel_Download_Logs__c downloadlogs = [SELECT Start_Change_ID__c, End_Change_ID__c FROM Travel_Download_Logs__c ORDER BY Download_Date_Time__c DESC limit 1];
        
        integer endval = Integer.valueOf(downloadlogs.End_Change_ID__c)+1;
        string endpointVal = 'http://www.travel-sys.com/sthr/export/xml.php?customerId=1&authKey=39dfTo71kdfhlvC6ak878yKbvf365R45&changeId=' + endval;
        */
        string endpointVal = '';
        
        if(!Test.isRunningTest())
        {
        	Application_Constants__c skylinkVal = Application_Constants__c.getInstance('Skylink_Info');
        	integer endval = Integer.valueOf(skylinkVal.Value__c)+1;
        	endpointVal = 'http://www.travel-sys.com/sthr/export/xml.php?customerId=1&authKey=' + skylinkVal.Key__c + '&changeId=' + endval;
        }
       
        
        string strval = '';
        
        Http h = new Http();
        HttpResponse res = new HttpResponse();
        HttpRequest req = new HttpRequest();
        Dom.Document docRes = new Dom.Document();
        
        req.setMethod('GET'); 
       // req.setEndpoint('http://www.travel-sys.com/sthr/export/xml.php?customerId=1&authKey=39dfTo71kdfhlvC6ak878yKbvf365R45&changeId=1562085');
       	if(!Test.isRunningTest())
       	{
        	req.setEndpoint(endpointVal);
        	res = h.send(req);
        	xmlval = res.getBody(); 
       	}
       	else
       	{
       		xmlval = '<?xml version="1.0" encoding="UTF-8"?><export><passengers><passenger exportedAt="2015-05-20 12:07:15" systemId="47024" changeId="1573542" studentNumber="1211692" firstName="ENA" lastName="MAKITA"><program systemId="1031" name="Intrax AYUSA Inbound"/><group systemId="3924" name="INTRAX JAPAN SHINANO 2014 - 15" departureCountry="To All Destination" destinationCountry="To All Destination"/><via name="Los Angeles, CA [Los Angeles International Airport], USA" code="LAX"/><finalDestination name="Osaka [Metropolitan Area], Japan" code="OSA"/><placingOrganization systemId="0"/><pnr filekey="NVNUDP"><outbound><segments><segment carrier="EK" flightNumber="776" departureAirportCode="DUR" departureAirportName="Durban [Louis Botha / Durban International Airport], South Africa" departureAirportTerminal="" departureDateTime="2015-05-17 18:40" arrivalAirportCode="DXB" arrivalAirportName="Dubai [Dubai Intl.], United Arab Emirates" arrivalAirportTerminal="TERMINAL 3" arrivalDateTime="2015-05-18 05:00" vendorLocator="FAEHY6"/><segment carrier="EK" flightNumber="201" departureAirportCode="DXB" departureAirportName="Dubai [Dubai Intl.], United Arab Emirates" departureAirportTerminal="TERMINAL 3" departureDateTime="2015-05-18 08:30" arrivalAirportCode="JFK" arrivalAirportName="New York, NY [John F. Kennedy International Airport], USA" arrivalAirportTerminal="TERMINAL 4" arrivalDateTime="2015-05-18 14:15" vendorLocator="FAEHY6"/><segment carrier="UA" flightNumber="3954" departureAirportCode="EWR" departureAirportName="Newark, NJ [Newark International Airport], USA" departureAirportTerminal="TERMINAL A" departureDateTime="2015-05-21 16:49" arrivalAirportCode="GSP" arrivalAirportName="Greer, SC [Greenville/Spartanburg International Airport], USA" arrivalAirportTerminal="" arrivalDateTime="2015-05-21 18:54" vendorLocator="I96LRG"/></segments></outbound><eTicket>ELECTRONIC TICKET RECORD INV: CUST: PNR:NVNUDP TKT:2059264592996 ISSUED:20MAY15 PCC:5UL1 IATA:23234363 NAME:MAKITA/ENA MS NAME REF:SHINANO TOUR ID:IT5NH2SKL200 FOP: CASH CPN A/L FLT CLS DATE BRDOFF TIME ST F/B STAT 1 UA 1622 S 06JUN ATLORD 0958 OK SGRPS OPEN 2 UA 1114 S 06JUN ORDLAX 1420 OK SGRPS OPEN 3 NH 5 S 07JUN LAXNRT 1245 OK SGRPS OPEN 4 NH 2179 M 08JUN NRTITM 1755 OK SGRPS OPEN </eTicket></pnr><charges><charge type="International" sellFare="1704.0" sellTax="409.0" sellTotal="2113.0"/><charge type="International" sellFare="1311.0" sellTax="412.0" sellTotal="1723.0"/><charge type="International" sellFare="250.0" sellTax="0.0" sellTotal="250.0"/><charge type="International" sellFare="178.0" sellTax="20.0" sellTotal="198.0"/></charges></passenger></passengers></export>';
       	}
       // system.debug('xmlval::::'+xmlval);
        
        docRes.load(xmlval);
        
        list<dom.XmlNode> resnodelist = docRes.getRootElement().getChildElements();
        //system.debug('***** resnodelist: ' + resnodelist);
        
         for (dom.XmlNode node : resnodelist)
         {
             //system.debug('***** node.getName(): ' + node.getName());                            
             if ( node.getName() == 'passengers')
             {
                 list<dom.XmlNode> childNodes = node.getChildElements();
                 //system.debug('***** childNodes: ' + childNodes);   
                 for (dom.XmlNode childnode : childNodes)
                 {
                    if ( childnode.getName() == 'passenger')
                    {
                        //Initialize values (Start)
                        String AuPairIDVal = '';
                        String FirstNameVal = '';
                        String LastNameVal = '';
                        string grouptempVal = '';
                        
                        /*string IntpnrNumberVal = '';
                        string NYArrivalAirportVal = '';
                        string NYArrivalCarrierVal = '';
                        string NYArrivalFlightNumberVal = '';
                        string NYArrivalTerminalVal = '';
                        string NYArrivalTimeVal = '';
                        
                        string NYDepartureTimeVal = '';
                        string IntInboundFlightItineraryIDVal = '';
                        string DompnrNumberVal = '';
                        string NYDepartureAirportVal = '';
                        string NYDepartureCarrierVal = '';
                        string NYDepartureFlightNumberVal = '';
                        
                        string NYDepartureTerminalVal = '';
                        string DomInboundFlightItineraryIDVal = ''; */
                        //Initialize values (End)
                        
                        /*for (Integer k = 0; k< childnode.getAttributeCount(); k++ ) 
                        {
                            if (childnode.getAttributeKeyAt(k) != NULL && childnode.getAttributeKeyAt(k) == 'studentNumber')
                            {
                            System.debug('studentNumber'+childnode.getAttributeValue('studentNumber', null));
                            }
                        } */
                        
                        if (childnode.getAttributeCount() > 0 && childnode.getAttributeValue('changeId', null) != NULL) 
                        {
                            //System.debug('changeId'+childnode.getAttributeValue('changeId', null));
                            if(startChangeID == 0)
                            {
                                startChangeID = integer.valueOf(childnode.getAttributeValue('changeId', null));
                            }
                            else if (startChangeID > integer.valueOf(childnode.getAttributeValue('changeId', null)))
                            {
                                startChangeID = integer.valueOf(childnode.getAttributeValue('changeId', null));
                            }
                            
                            if(endChangeID == 0)
                            {
                                endChangeID = integer.valueOf(childnode.getAttributeValue('changeId', null));
                            }
                            else if (endChangeID < integer.valueOf(childnode.getAttributeValue('changeId', null)))
                            {
                                endChangeID = integer.valueOf(childnode.getAttributeValue('changeId', null));
                            }
                        }
                        
                        if (childnode.getAttributeCount() > 0 && childnode.getAttributeValue('studentNumber', null) != NULL) 
                        {
                            //System.debug('studentNumber'+childnode.getAttributeValue('studentNumber', null));
                            AuPairIDVal = childnode.getAttributeValue('studentNumber', null);
                        }
                        if (childnode.getAttributeCount() > 0 && childnode.getAttributeValue('firstName', null) != NULL) 
                        {
                            FirstNameVal = childnode.getAttributeValue('firstName', null);
                        }
                        if (childnode.getAttributeCount() > 0 && childnode.getAttributeValue('lastName', null) != NULL) 
                        {
                            LastNameVal = childnode.getAttributeValue('lastName', null);
                        }
                        
                      list<dom.XmlNode> childNodes1 = childnode.getChildElements();
                      
                      for (dom.XmlNode childnodelvl1 : childNodes1)
                      {
                      	if ( childnodelvl1.getName() == 'group')
                        {
                            if (childnodelvl1.getAttributeCount() > 0 && childnodelvl1.getAttributeValue('name', null) != NULL) 
                            {
                                grouptempVal = childnodelvl1.getAttributeValue('name', null);
                            }
                        }
                        
                        system.debug('****grouptempVal****'+grouptempVal);
                      	
                        if ( childnodelvl1.getName() == 'pnr')
                        {
                            string pnrtempVal = '';
                            
                            if (childnodelvl1.getAttributeCount() > 0 && childnodelvl1.getAttributeValue('filekey', null) != NULL) 
                            {
                                pnrtempVal = childnodelvl1.getAttributeValue('filekey', null);
                            }
                            
                            list<dom.XmlNode> childNodespnr = childnodelvl1.getChildElements();
                      
                            for (dom.XmlNode childNodespnrsng : childNodespnr)
                            {
                                if ( childNodespnrsng.getName() == 'outbound')
                                {
                                    list<dom.XmlNode> childNodesoutbound = childNodespnrsng.getChildElements();
                                    
                                    for (dom.XmlNode childNodesoutboundsng : childNodesoutbound)
                                    {
                                        if ( childNodesoutboundsng.getName() == 'segments')
                                        {
                                            list<dom.XmlNode> childNodessegments = childNodesoutboundsng.getChildElements();
                                            
                                            
                                            for (dom.XmlNode childNodessegmentssng : childNodessegments)
                                            {
                                                //system.debug('childNodessegmentssng'+childNodessegmentssng);  
                                                if ( childNodessegmentssng.getName() == 'segment')
                                                {
                                                    if (childNodessegmentssng.getAttributeCount() > 0)
                                                    {
                                                    	IntraxIDList.add(AuPairIDVal);
                                                    	AuPairTravelInfo SingleTravelInfo = new AuPairTravelInfo();
                                                    	SingleTravelInfo.ItraxID = AuPairIDVal;
                                                    	SingleTravelInfo.FirstName = FirstNameVal;
                                                    	SingleTravelInfo.LastName = LastNameVal;
                                                    	SingleTravelInfo.RecordLocator = pnrtempVal;
                                                    	SingleTravelInfo.Carrier = childNodessegmentssng.getAttributeValue('carrier', null);
                                                    	SingleTravelInfo.CarrierNumber = childNodessegmentssng.getAttributeValue('flightNumber', null);
                                                    	SingleTravelInfo.ArrivalCity = childNodessegmentssng.getAttributeValue('arrivalAirportName', null);
                                                    	SingleTravelInfo.ArrivingAt = childNodessegmentssng.getAttributeValue('arrivalAirportCode', null);
                                                    	SingleTravelInfo.ArrivalDateTime = childNodessegmentssng.getAttributeValue('arrivalDateTime', null);
                                                    	SingleTravelInfo.DepartureCity = childNodessegmentssng.getAttributeValue('departureAirportName', null);
                                                    	SingleTravelInfo.DepartingFrom = childNodessegmentssng.getAttributeValue('departureAirportCode', null);
                                                    	SingleTravelInfo.DepartureDateTime = childNodessegmentssng.getAttributeValue('departureDateTime', null);
                                                    	SingleTravelInfo.ArrivalTerminal = childNodessegmentssng.getAttributeValue('arrivalAirportTerminal', null);
                                                    	SingleTravelInfo.DepartureTerminal = childNodessegmentssng.getAttributeValue('departureAirportTerminal', null);
                                                    	SingleTravelInfo.ArrivaltoHostCountry = false;
                                                    	SingleTravelInfo.ArrivaltoHostCommunity = false;
                                                    	SingleTravelInfo.GroupName = grouptempVal;
                                                    	SingleTravelInfo.ArrivaltoHostCommunityDate='';
                                                    	
                                                    	if (childNodessegmentssng.getAttributeValue('arrivalAirportCode', null) != NULL)
                                                    	{
                                                    		if (childNodessegmentssng.getAttributeValue('arrivalAirportCode', null) == 'EWR' || childNodessegmentssng.getAttributeValue('arrivalAirportCode', null) == 'JFK' || childNodessegmentssng.getAttributeValue('arrivalAirportCode', null) == 'LGA')
                                                    		{
                                                    			SingleTravelInfo.ArrivaltoHostCountry = true;
                                                    		}
                                                    	}
                                                    	if (childNodessegmentssng.getAttributeValue('departureAirportCode', null) != NULL)
                                                        {
                                                            if (childNodessegmentssng.getAttributeValue('departureAirportCode', null) == 'EWR' || childNodessegmentssng.getAttributeValue('departureAirportCode', null) == 'JFK' || childNodessegmentssng.getAttributeValue('departureAirportCode', null) == 'LGA')
                                                            {
                                                            	SingleTravelInfo.ArrivaltoHostCommunity = true;
                                                            	SingleTravelInfo.ArrivaltoHostCommunityDate = childNodessegmentssng.getAttributeValue('arrivalDateTime', null);
                                                            }
                                                        }
                                                    	
                                                    	TravelInfoList.add(SingleTravelInfo);
                                                        /*
                                                        if (childNodessegmentssng.getAttributeValue('arrivalAirportCode', null) != NULL)
                                                        {
                                                            if (childNodessegmentssng.getAttributeValue('arrivalAirportCode', null) == 'EWR' || childNodessegmentssng.getAttributeValue('arrivalAirportCode', null) == 'JFK' || childNodessegmentssng.getAttributeValue('arrivalAirportCode', null) == 'LGA')
                                                            {
                                                                IntpnrNumberVal = pnrtempVal;
                                                                NYArrivalAirportVal = childNodessegmentssng.getAttributeValue('arrivalAirportCode', null);
                                                                NYArrivalCarrierVal = childNodessegmentssng.getAttributeValue('carrier', null);
                                                                NYArrivalFlightNumberVal = childNodessegmentssng.getAttributeValue('flightNumber', null);
                                                                NYArrivalTerminalVal = childNodessegmentssng.getAttributeValue('arrivalAirportTerminal', null);
                                                                NYArrivalTimeVal = childNodessegmentssng.getAttributeValue('arrivalDateTime', null);
                                                            }
                                                        }
                                                        
                                                        if (childNodessegmentssng.getAttributeValue('departureAirportCode', null) != NULL)
                                                        {
                                                            if (childNodessegmentssng.getAttributeValue('departureAirportCode', null) == 'EWR' || childNodessegmentssng.getAttributeValue('departureAirportCode', null) == 'JFK' || childNodessegmentssng.getAttributeValue('departureAirportCode', null) == 'LGA')
                                                            {
                                                                DompnrNumberVal = pnrtempVal;
                                                                NYDepartureTimeVal = childNodessegmentssng.getAttributeValue('departureDateTime', null);
                                                                NYDepartureAirportVal = childNodessegmentssng.getAttributeValue('departureAirportCode', null);
                                                                NYDepartureCarrierVal = childNodessegmentssng.getAttributeValue('carrier', null);
                                                                NYDepartureFlightNumberVal = childNodessegmentssng.getAttributeValue('flightNumber', null);
                                                                NYDepartureTerminalVal = childNodessegmentssng.getAttributeValue('departureAirportTerminal', null);
                                                            }
                                                        }
                                                        */
                                                    }
                                                    
                                                    
                                                    /*for (Integer j = 0; j< childNodessegmentssng.getAttributeCount(); j++ ) 
                                                    {
                                                        if (childNodessegmentssng.getAttributeKeyAt(j) != NULL && childNodessegmentssng.getAttributeKeyAt(j) == 'flightNumber')
                                                        {
                                                            System.debug('flightNumber'+childNodessegmentssng.getAttributeValue('flightNumber', null));
                                                            ///System.debug('departureAirportCode'+childNodessegmentssng.getAttributeValue('departureAirportCode', null));
                                                            //System.debug('departureAirportName'+childNodessegmentssng.getAttributeValue('departureAirportName', null));
                                                        }
                                                        
                                                    }*/
                                                }
                                            }
                                        }
                                    }
                                    
                                }
                            }
                            
                        }
                        
                      }
                      
                     /* if (AuPairIDVal != null && AuPairIDVal != '')
                     {
                        AuPairTravelInfo SingleTravelInfo = new AuPairTravelInfo(); 
                        SingleTravelInfo.AuPairID = AuPairIDVal;
                        SingleTravelInfo.DompnrNumber = DompnrNumberVal;
                        SingleTravelInfo.IntpnrNumber = IntpnrNumberVal;
                        SingleTravelInfo.NYArrivalAirport = NYArrivalAirportVal;
                        SingleTravelInfo.NYArrivalCarrier = NYArrivalCarrierVal;
                        SingleTravelInfo.NYArrivalFlightNumber = NYArrivalFlightNumberVal;
                        SingleTravelInfo.NYArrivalTerminal = NYArrivalTerminalVal;
                        SingleTravelInfo.NYArrivalTime = NYArrivalTimeVal;
                        SingleTravelInfo.NYDepartureAirport = NYDepartureAirportVal;
                        SingleTravelInfo.NYDepartureCarrier = NYDepartureCarrierVal;
                        SingleTravelInfo.NYDepartureFlightNumber = NYDepartureFlightNumberVal;
                        SingleTravelInfo.NYDepartureTerminal = NYDepartureTerminalVal;
                        SingleTravelInfo.NYDepartureTime = NYDepartureTimeVal;
                        
                        TravelInfoList.add(SingleTravelInfo);
                     }*/
                     
                     
                    }
                      
                 // break;               
                 }
                 
                 
                 
             }
         }
         
         if (TravelInfoList.size()>0)
         {
           	insertTripRecord(IntraxIDList,TravelInfoList);
         }
         system.debug('****StartChangeID****'+startChangeId);
         system.debug('****endChangeId****'+endChangeId);
         if(StartChangeID > 0 && endChangeID > 0)
         {
            /* Travel_Download_Logs__c insLogs = new Travel_Download_Logs__c();
             insLogs.Start_Change_ID__c = startChangeId;
             insLogs.End_Change_ID__c = endChangeId;
             insLogs.Download_Date_Time__c = date.today();
             insert insLogs;
             */
             if(!Test.isRunningTest())
             {
	             Application_Constants__c updskylinkVal = Application_Constants__c.getInstance('Skylink_Info');
	             updskylinkVal.Old_Value__c = updskylinkVal.Value__c;
	        	 updskylinkVal.Value__c = String.valueOf(endChangeId);
	        	 update updskylinkVal;
             }
         }
         system.debug('****TravelInfoList****'+TravelInfoList);
        }
        catch(Exception e)
        {
           system.debug('********* Issue in Parsing Skylink XML ' + e);
        }
    }
    
    public void insertTripRecord(set<string> IxIDList, list<AuPairTravelInfo> TravelList)
    {
    	if (TravelList.size()>0)
    	{
    		list<Trip__c> InsTripList = new list<Trip__c>();
    		map<string,string> IntraxIDENggMap = new map<string,string>();
    		map<string,string> IntraxIDMatchMap = new map<string,string>();
    		map<string,Engagement__c> MapUpdEnggList = new map<string,Engagement__c>();
    		Set<Engagement__c> UpdEnggList = new Set<Engagement__c>();
    		set<string> EnggIdList = new set<string>();
    		
    		list<Engagement__c> enggList = [SELECT ID, Account_Id__r.Casper_Id__c,Account_Id__r.Intrax_Id__c, Arrival_PNR_Number__c, Arrival_Trip_URL__c, Arrival_Trip_Group_Name__c,Arrival_Trip_Update_Count__c, (Select ID, Name, CreatedDate, Status__c From Matches__r WHERE Status__c = 'Confirmed' ORDER BY CreatedDate DESC) FROM Engagement__c WHERE  (Status__c IN ('Program Ready','Processing')) AND (Account_Id__r.Casper_Id__c IN :IxIDList OR Account_Id__r.Intrax_Id__c IN :IxIDList)];
    		//list<Engagement__c> enggList = [SELECT ID, Account_Id__r.Casper_Id__c,Account_Id__r.Intrax_Id__c,  (Select ID, Name, CreatedDate, Status__c From Matches__r WHERE Status__c = 'Confirmed' ORDER BY CreatedDate DESC) FROM Engagement__c WHERE  (Status__c IN ('Program Ready','Processing')) AND (Account_Id__r.Casper_Id__c IN :IxIDList OR Account_Id__r.Intrax_Id__c IN :IxIDList)];
    		
    		if(enggList != NULL && enggList.size() >0)
    		{
    			for(Engagement__c eng: enggList)
    			{
    				if(IxIDList.contains(eng.Account_Id__r.Intrax_Id__c))
    				{
    					IntraxIDENggMap.put(eng.Account_Id__r.Intrax_Id__c,eng.id);
    					MapUpdEnggList.put(eng.id,eng);
    					List<Match__c> getMatchList = eng.Matches__r;
		        		if (getMatchList != null && getMatchList.size() > 0)
		        		{
		        			IntraxIDMatchMap.put(eng.Account_Id__r.Intrax_Id__c, getMatchList[0].id);
		        		}
    				}
    				else if(IxIDList.contains(eng.Account_Id__r.Casper_Id__c))
    				{
    					IntraxIDENggMap.put(eng.Account_Id__r.Casper_Id__c,eng.id);
    					MapUpdEnggList.put(eng.id,eng);
    					List<Match__c> getMatchList = eng.Matches__r;
		        		if (getMatchList != null && getMatchList.size() > 0)
		        		{
		        			IntraxIDMatchMap.put(eng.Account_Id__r.Casper_Id__c, getMatchList[0].id);
		        		}
    				}
    				
    			}
    		}
    		
    		for (AuPairTravelInfo singleTrip: TravelList)
    		{
    			if(IntraxIDENggMap.get(singleTrip.ItraxID) != NULL)
    			{
	    			EnggIdList.add(IntraxIDENggMap.get(singleTrip.ItraxID));
	    			if(MapUpdEnggList.get(IntraxIDENggMap.get(singleTrip.ItraxID)) != NULL)
	    			{
	    				MapUpdEnggList.get(IntraxIDENggMap.get(singleTrip.ItraxID)).Arrival_PNR_Number__c = singleTrip.RecordLocator;
	    				MapUpdEnggList.get(IntraxIDENggMap.get(singleTrip.ItraxID)).Arrival_Trip_URL__c = 'https://www.checkmytrip.com/cmt/apf/cmtng/pnr_retrieve?&SITE=NCMTNCMT&LANGUAGE=US&R=' + singleTrip.RecordLocator + '&N=' + singleTrip.LastName;
	    				system.debug('***singleTrip.GroupName***'+singleTrip.GroupName);
	    				MapUpdEnggList.get(IntraxIDENggMap.get(singleTrip.ItraxID)).Arrival_Trip_Group_Name__c = singleTrip.GroupName;
	    				UpdEnggList.add(MapUpdEnggList.get(IntraxIDENggMap.get(singleTrip.ItraxID)));
	    			}
	    			Trip__c InsTrip = new Trip__c();
	    			InsTrip.Name = singleTrip.FirstName + ' ' + singleTrip.LastName;
	    			//InsTrip.Intrax_Id__c = singleTrip.ItraxID;
	    			InsTrip.Record_Locator__c = singleTrip.RecordLocator; 
	    			InsTrip.Carrier__c = singleTrip.Carrier;
	    			InsTrip.Carrier_Number__c = singleTrip.CarrierNumber;
	    			InsTrip.Arriving_City__c = singleTrip.ArrivalCity;
	    			InsTrip.Arriving_At__c = singleTrip.ArrivingAt;
	    			InsTrip.Arrival_Date_Time__c = singleTrip.ArrivalDateTime;
	    			InsTrip.Departing_City__c = singleTrip.DepartureCity;
	    			InsTrip.Departing_From__c = singleTrip.DepartingFrom;
	    			InsTrip.Departure_Date_Time__c = singleTrip.DepartureDateTime;
	    			InsTrip.Description__c = singleTrip.Description;
	    			InsTrip.Arrival_to_Host_Country__c = singleTrip.ArrivaltoHostCountry;
	    			InsTrip.Arrival_to_Host_Community__c= singleTrip.ArrivaltoHostCommunity;
	    			InsTrip.Arrival_to_Host_Community_Date__c = singleTrip.ArrivaltoHostCommunityDate;
	    			InsTrip.Arrival_Terminal__c= singleTrip.ArrivalTerminal;
	    			InsTrip.Departure_Terminal__c= singleTrip.DepartureTerminal;
	    			InsTrip.Type__c = 'Arrival';
	    			
	    			InsTrip.Engagement__c = IntraxIDENggMap.get(singleTrip.ItraxID);
	    			
	    			//InsTrip.Engagement__c = 'a0d19000000H9OG';
	    			
	    			if(IntraxIDMatchMap.get(singleTrip.ItraxID) != NULL)
	    			{
	    				InsTrip.Match__c = IntraxIDMatchMap.get(singleTrip.ItraxID);
	    			}
	    			
	    			InsTripList.add(InsTrip);
    			}
    		}
    		if(InsTripList.size() > 0)
    		{
    			if(EnggIdList.size() >0)
    			{
    				list<Trip__c> DelTripList = [SELECT Name FROM Trip__c WHERE Engagement__c IN :EnggIdList AND Type__c = 'Arrival'];
    				if(DelTripList.size() > 0)
    				{
    					delete DelTripList;
    				}
    			}
    			insert InsTripList;
    			if(UpdEnggList != NULL && UpdEnggList.size() > 0)
    			{
    				List<Engagement__c> Updlst = new List<Engagement__c>(UpdEnggList);
    				system.debug('***Updlst***'+Updlst);
    				
    				for (Engagement__c ue :Updlst)
    				{
    					if (ue.Arrival_Trip_Update_Count__c == NULL)
	    				{
	    					ue.Arrival_Trip_Update_Count__c = 1;
	    				}
	    				else
	    				{
	    					ue.Arrival_Trip_Update_Count__c = ue.Arrival_Trip_Update_Count__c + 1;
	    				}
    				} 
    				update Updlst;
    			}
    		}
    	}
    }
    
    public class AuPairTravelInfo 
    {
        /*public String AuPairID;
        public string IntpnrNumber;
        public string NYArrivalAirport;
        public string NYArrivalCarrier;
        public string NYArrivalFlightNumber;
        public string NYArrivalTerminal;
        public string NYArrivalTime;
        
        public string NYDepartureTime;
        public string IntInboundFlightItineraryID;
        public string DompnrNumber;
        public string NYDepartureAirport;
        public string NYDepartureCarrier;
        public string NYDepartureFlightNumber;
        
        public string NYDepartureTerminal;
        public string DomInboundFlightItineraryID;
        */
        
        
        public String ItraxID;
        public String FirstName;
        public String LastName;
        public string RecordLocator;
        public string Carrier;
        public string CarrierNumber;
        public string ArrivalCity;
        public string ArrivingAt;
        public string ArrivalDateTime;
        public string DepartureCity;
        public string DepartingFrom;
        public string DepartureDateTime;
        public string Description;
        public boolean ArrivaltoHostCountry;
        public boolean ArrivaltoHostCommunity;
        public string ArrivaltoHostCommunityDate;
        public string GroupName;
        public string ArrivalTerminal;
        public string DepartureTerminal; 
        
        
    }
    
}