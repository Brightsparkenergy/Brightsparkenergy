/**
* @author            : Tushar
* @team              : BrighrSpark Team
* @last modified by  : Tushar    
**/

public class AutoAssociateProgramByEmailHelper {

 

    public static void associateProgram(List<inov8__PMT_Project__c> lstProject) {
        Map<String, String> emailToProgramMap = new Map<String, String>();

 

        // First, create a map of Email to Program from the existing records
        for (inov8__PMT_Project__c objProject : [SELECT Id, Email__c,E_mail__c, inov8__Program__c FROM inov8__PMT_Project__c]) {
            if (objProject.E_mail__c != null && objProject.inov8__Program__c != null) {
                emailToProgramMap.put(objProject.E_mail__c, objProject.inov8__Program__c);
            }
        }

 

        // Loop through the new records and update Program based on email if found
        for (inov8__PMT_Project__c newProject : lstProject) {
            system.debug('insdie for');
            if (newProject.E_mail__c != null && emailToProgramMap.containsKey(newProject.E_mail__c)) {
                
                system.debug('email is>>'+newProject.E_mail__c);
                String programId = emailToProgramMap.get(newProject.E_mail__c);
                newProject.inov8__Program__c = programId;
            }
        }
    }
}