public without sharing class ValidateEmailAndOTP {

    @AuraEnabled
    public static Boolean validateOTP(String email, String enteredOTP) {
        // Query the custom object to find the stored OTP for the provided email
        List<inov8__PMT_Project__c> otpRecord = [SELECT Id FROM inov8__PMT_Project__c WHERE Email__c = :email and OTP__c = :enteredOTP LIMIT 1];
        
        // Check if a record was found
        if (otpRecord.size()>0) {
            system.debug('found record');
            return true; // Record found, return true
            
        } else {
            system.debug('not found');
            return false; // Record not found, return false
            
        }
    }
}