@isTest
private class ProjectEmailSenderTest {

    @isTest
    static void testSendEmailWithOTP() {
        //Create Oppo Record
        Opportunity testOpportunity = new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Closed Won',
            CloseDate = Date.valueOf('2023-12-31'),
            Email__c = 'TestEmail@gmail.com'
            
        );
        insert testOpportunity;
        
        
        // Create a test Project record
        inov8__PMT_Project__c testProject = new inov8__PMT_Project__c(
            Name = 'Test Project',
            Opportunity_Name__c = testOpportunity.Id, // Associate the new Project with the Opportunity
            inov8__Level_of_Effort__c = 'Small',
            inov8__Portfolio__c = 'P2P',
            //Email__c = 'test@email.com',
            OTP__c = '123456'
            
        );
        insert testProject;

        // Call the method to test
        Test.startTest();
        ProjectEmailSender.sendEmailWithOTP(testProject);
        Test.stopTest();

       
    }
}