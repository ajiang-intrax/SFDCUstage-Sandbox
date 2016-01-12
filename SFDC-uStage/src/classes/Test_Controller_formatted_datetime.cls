@isTest(seeAllData=false)
private class Test_Controller_formatted_datetime{

    static testMethod void myUnitTest() {
     Controller_formatted_datetime cfd = new Controller_formatted_datetime();
     cfd.getFormattedDatetime();
     
     datetime dt = date.today();
     Controller_formatted_datetime cfd1 = new Controller_formatted_datetime();
     cfd1.date_time = dt;
     cfd1.defined_format = 'MM/dd/yyyy HH:mm:ss';
     cfd1.getFormattedDatetime();
     
     Controller_formatted_datetime cfd2 = new Controller_formatted_datetime();
     cfd2.date_time = dt;
     cfd2.getFormattedDatetime();
    }
    
}