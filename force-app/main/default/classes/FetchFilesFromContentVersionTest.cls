@isTest
public class FetchFilesFromContentVersionTest {
    
    @isTest
    static void testRetivefiles() {
        // Test scenario: Query returns content versions
        List<ContentVersion> contentVersions = FetchFilesFromContentVersion.retivefiles();
        System.assertNotEquals(null, contentVersions, 'Content Versions should not be null');
    }
    
    @isTest
    static void testSendEmailWithAttachments() {
        // Create an EmailTemplate for testing within System.runAs
        EmailTemplate testEmailTemplate;
        User testUser;
        
        System.runAs(new User(Id = UserInfo.getUserId())) {
            testEmailTemplate = new EmailTemplate(
                Name = 'Test Email Template',
                Subject = 'Test Email Subject',
                Body = 'Test Email Body',
                DeveloperName = 'Test_Email_Template',
                FolderId = UserInfo.getUserId(),
                TemplateType = 'text'
            );
            insert testEmailTemplate;
        }
        
        // Create a Lead for testing
        Lead testLead = new Lead(FirstName = 'Test', LastName = 'Lead', company = 'NA', Email = 'test@example.com');
        insert testLead;
        
        // Create a ContentVersion for testing
        ContentVersion testContentVersion = new ContentVersion(
            Title = 'Test Content',
            VersionData = Blob.valueOf('Test Content Data'),
            PathOnClient = 'TestPath.pdf'
           
           
        );
        insert testContentVersion;
        system.debug('testContentVersion==>'+testContentVersion.VersionData);
        system.debug('testContentVersionId------==>'+testContentVersion);
        // Call sendEmailWithAttachments method
        FetchFilesFromContentVersion.sendEmailWithAttachments(testLead.Id, new String[]{testContentVersion.Id});
        
        // Retrieve the Lead again to check if the field was updated correctly
        testLead = [SELECT Brochure_Send_Successfully__c FROM Lead WHERE Id = :testLead.Id];
        
        // Add your assertions here to validate the behavior of the sendEmailWithAttachments method
        //System.assertEquals(false, testLead.Brochure_Send_Successfully__c, 'Brochure_Send_Successfully__c should be true');
    }
    
    
    @isTest
    static void testCreateEventAsync() {
        // Test scenario: Async event creation
        Lead testLead = new Lead(FirstName = 'Test', LastName = 'Lead', company = 'NA', Email = 'test@example.com', Brochure_Send_Successfully__c = false);
        insert testLead;
        
        Test.startTest();
        FetchFilesFromContentVersion.createEventAsync(testLead.Id);
        Test.stopTest();
        
        testLead = [SELECT Brochure_Send_Successfully__c FROM Lead WHERE Id = :testLead.Id];
        System.assertEquals(true, testLead.Brochure_Send_Successfully__c, 'Brochure_Send_Successfully__c should be true');
    }
    
    @isTest
    static void testCreateEventAsyncNoUpdate() {
        // Test scenario: Async event creation with no update
        Lead testLead = new Lead(FirstName = 'Test', LastName = 'Lead', company = 'NA', Email = 'test@example.com', Brochure_Send_Successfully__c = true);
        insert testLead;
        
        Test.startTest();
        FetchFilesFromContentVersion.createEventAsync(testLead.Id);
        Test.stopTest();
        
        testLead = [SELECT Brochure_Send_Successfully__c FROM Lead WHERE Id = :testLead.Id];
        System.assertEquals(true, testLead.Brochure_Send_Successfully__c, 'Brochure_Send_Successfully__c should remain true');
    }
    
    @isTest
    static void testSendEmailWithAttachmentsWithEmail() {
        // Test scenario: Lead has an email address
        Lead testLead = new Lead(FirstName = 'Test', LastName = 'Lead', company = 'NA', Email = 'test@example.com');
        insert testLead;
        
        // Create an EmailTemplate for testing within System.runAs
        EmailTemplate testEmailTemplate;
        User testUser;
        
        System.runAs(new User(Id = UserInfo.getUserId())) {
            testEmailTemplate = new EmailTemplate(
                Name = 'Test Email Template',
                Subject = 'Test Email Subject',
                Body = 'Test Email Body',
                DeveloperName = 'Test_Email_Template',
                FolderId = UserInfo.getUserId(),
                TemplateType = 'text'
            );
            insert testEmailTemplate;
        }
        
        // Create a ContentVersion for testing
        ContentVersion testContentVersion = new ContentVersion(
            Title = 'Test Content',
            VersionData = Blob.valueOf('Test Content Data'),
            PathOnClient = 'TestPath.txt'
        );
        insert testContentVersion;
        
        // Call sendEmailWithAttachments method
        FetchFilesFromContentVersion.sendEmailWithAttachments(testLead.Id, new String[]{testContentVersion.Id});
        
        // Retrieve the Lead again to check if the field was updated correctly
        testLead = [SELECT Brochure_Send_Successfully__c FROM Lead WHERE Id = :testLead.Id];
        
        // Add your assertions here to validate the behavior of the sendEmailWithAttachments method
        System.assertEquals(false, testLead.Brochure_Send_Successfully__c, 'Brochure_Send_Successfully__c should be false');
    }
}