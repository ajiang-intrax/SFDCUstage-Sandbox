//Apex class to hold all the generic methods
public without sharing class Utility {

    //Method for getting System Administrator Users list
    public static List<User> getSystemAdministartors() {
    
        //Fetching System Administrators from the system
        List<User> users = [select Name, Profile.Name, Email from User where Profile.Name = 'System Administrator' and isActive = true];
        System.debug('###### value in users After' + users); 
        
        //Return List of Users
        return users;
    
    }
}