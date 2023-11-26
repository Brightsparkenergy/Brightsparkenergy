@isTest
public class AutoAssociateProgramByEmailHelperTest {

    @isTest
    static void testAssociateProgram() {
        // Create test data 
        Opportunity testOpportunity = new Opportunity(
            Name = 'Test Opportunity',
            CloseDate = Date.today(),
            StageName = 'Closed Won',
            Email__c = 'test@example.com'
        );
        insert testOpportunity;
        system.debug('TheOpportunityEmail------>'+testOpportunity.Email__c);
        
        inov8__PMT_Program__c testprogram = new inov8__PMT_Program__c(
            Name = 'TestProgram'
        );
        
        insert testprogram;
        system.debug('The ProgramId--->'+testprogram.Id);

        inov8__PMT_Project__c existingProject = new inov8__PMT_Project__c(
            Name = 'Existing Project',
            Opportunity_Name__c = testOpportunity.Id,
            inov8__Level_of_Effort__c = 'Small',
            inov8__Initial_Start_Date__c = Date.valueOf('2023-12-31'),
            inov8__Portfolio__c = 'R2R',
            E_mail__c = 'test@example.com',
            inov8__Program__c = testprogram.Id //'a1q3L000000ESWNQA4'
        );
        insert existingProject;

        // Mock the existing records in the database
        List<inov8__PMT_Project__c> existingProjects = [SELECT Id, Email__c, inov8__Program__c FROM inov8__PMT_Project__c];

        // Create test data for the new projects
        List<inov8__PMT_Project__c> newProjects = new List<inov8__PMT_Project__c>();
        inov8__PMT_Project__c newProject1 = new inov8__PMT_Project__c(
            Name = 'New Project 1',
            inov8__Level_of_Effort__c = 'Small',
            inov8__Initial_Start_Date__c = Date.valueOf('2023-12-31'),
            inov8__Portfolio__c = 'R2R',
            Opportunity_Name__c = testOpportunity.Id,
            E_mail__c = 'test@example.com'
        );
        newProjects.add(newProject1);
        system.debug('THEProject-1----->'+newProject1.Email__c);
        system.debug('THEProjectOpportunity----->'+newProject1.Opportunity_Name__c);

        inov8__PMT_Project__c newProject2 = new inov8__PMT_Project__c(
            Name = 'New Project 2',
            inov8__Level_of_Effort__c = 'Small',
            inov8__Initial_Start_Date__c = Date.valueOf('2023-12-31'),
            inov8__Portfolio__c = 'R2R',
            E_mail__c = 'nonexistent@example.com'
        );
        newProjects.add(newProject2);

        // Call the method to associate programs
        AutoAssociateProgramByEmailHelper.associateProgram(newProjects);

        // Verify that the new projects have the correct inov8__Program__c values
        System.assertEquals(testprogram.Id, newProject1.inov8__Program__c, 'Program should be associated');
        System.assertEquals(null, newProject2.inov8__Program__c, 'Program should not be associated');

        // You may also want to test scenarios where the Email__c field is null or not found in the map
    }
}