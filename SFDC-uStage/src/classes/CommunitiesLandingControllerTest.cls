/**
 * An apex page controller that takes the user to the right start page based on credentials or lack thereof
 */
 @isTest
private class CommunitiesLandingControllerTest {
	
	
static testMethod void testCommunitiesLandingController() {
	
	CommunitiesLandingController controller = new CommunitiesLandingController();
pagereference pg = controller.forwardToStartPage();
}}