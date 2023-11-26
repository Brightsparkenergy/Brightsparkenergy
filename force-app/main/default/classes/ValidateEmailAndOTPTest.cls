@isTest
public class ValidateEmailAndOTPTest {
    
    @isTest
    static void testValidateOTP() {
        // Create a test Opportunity with the necessary data
        Opportunity testOpportunity = new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Closed Won',
            CloseDate = Date.valueOf('2023-12-31'),
            Email__c = 'TestEmail@gmail.com'
            
            // Set other required fields that contribute to the formula field 'Email__c'
        );
        insert testOpportunity;
        
        // Test case 1: Valid OTP
        // Create a test inov8__PMT_Project__c record with the correct OTP
        inov8__PMT_Project__c testPMTProjectValid = new inov8__PMT_Project__c(
            inov8__Level_of_Effort__c = 'Medium',
            inov8__Portfolio__c = 'P2P',
            inov8__Initial_Start_Date__c = Date.valueOf('2023-12-31'),
            Opportunity_Name__c = testOpportunity.Id, // Link to the test Opportunity
            OTP__c = '123456' // Assuming this is the expected OTP value
        );
        insert testPMTProjectValid;
        
        // Test the validateOTP method with a valid OTP
        Boolean resultValid = ValidateEmailAndOTP.validateOTP(testOpportunity.Email__c, '123456');
         system.debug('resultValid==>'+resultValid);
        System.assertEquals(true, resultValid, 'Valid OTP should return true');
        
        Boolean resultNotFound;
        try {
            resultNotFound = ValidateEmailAndOTP.validateOTP('nonexistent@example.com', '111111');
            //resultNotFound = false;
            system.debug('resultNotFound==>'+resultNotFound);
        } catch (System.QueryException e) {
            system.debug('Error found==>'+e);            
            system.assertEquals('False', e.getMessage());
        }
       // System.assertEquals(false, resultNotFound, 'OTP not found should return false');
    }
}