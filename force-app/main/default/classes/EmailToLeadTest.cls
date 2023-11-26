@isTest
public class EmailToLeadTest {

    @isTest
    static void testEmailToLeadHandler() {
        // Create a test inbound email
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        email.plainTextBody = 'This is the plain text body of the email.';
        email.fromAddress = 'test@example.com';
        email.fromName = 'Test User';
        email.subject = 'Test Subject';
        email.inreplyto = 'test-reply-id';

        // Create a test inbound envelope
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        

        // Call the email handler and capture the result
        EmailToLead emailHandler = new EmailToLead();
        Messaging.InboundEmailResult result = emailHandler.handleInboundEmail(email, env);

        // Verify the result
        System.assertEquals(true, result.success, 'The email should be processed successfully');

        // Query the created lead to verify if it exists
        Lead[] leads = [SELECT Id, FirstName, LastName, Email, Company, Title, Description, LeadSource, MPAN__c
                        FROM Lead WHERE Email = :email.fromAddress AND Title = :email.subject LIMIT 1];

        System.assertEquals(1, leads.size(), 'One lead should be created');
        Lead createdLead = leads[0];
        System.assertEquals(email.fromAddress, createdLead.Email, 'Email should match');
        System.assertEquals(email.fromName, createdLead.LastName, 'Last Name should match');
        System.assertEquals('No Company', createdLead.Company, 'Company should be set');
        System.assertEquals(email.subject, createdLead.Title, 'Title should match');
        System.assertEquals(email.plainTextBody, createdLead.Description, 'Description should match');
        System.assertEquals('Email', createdLead.LeadSource, 'Lead Source should be set');
        System.assertEquals(11111111, createdLead.MPAN__c, 'MPAN should be set');
    }
}