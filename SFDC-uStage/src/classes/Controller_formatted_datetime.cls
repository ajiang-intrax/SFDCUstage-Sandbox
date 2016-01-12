public class Controller_formatted_datetime {

    
    public DateTime date_time { get; set; } //property that reads the datetime value from the component attribute tag
    public String defined_format { get; set; } //property that reads the string value from the component attribute tag
    
    public String getFormattedDatetime() {
        if (date_time == null) { //if no date_time value is provided
            return ''; //return blank string
        } else { //otherwise, a date_time value was provided
            if (defined_format == null) { //if the format for the date_time value was not provided
                return date_time.format(); //return the full date/time for the user based upon the locale and time zone (the format() method provides the string in the running user's time zone and locale)
            } else { //otherwise, the format was provided
                return date_time.format(defined_format); //return the date_time value formatted as requested but with the locale and time zone taken into consideration
            }
        }
    }
}