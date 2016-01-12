Public with sharing class Recursive_Handling_class{

    Public Static Boolean handle=true;
    
    public static boolean hasAlreadyCreatedFollowUpTasks() {
          return handle;
    }
    
    public static boolean setAlreadyCreatedFollowUpTasks() {
           return handle=false;
    }       
    
}