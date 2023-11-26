global class EmailToLead implements Messaging.InboundEmailHandler {
    
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.inboundEmail email, Messaging.InboundEnvelope env){
        // Create an InboundEmailResult object for returning the result of the  
        // Apex Email Service 
        system.debug('inbound email class invoked successfully');
        system.debug('Messaging.inboundEmail email---->'+email);
        system.debug('Messaging.InboundEnvelope env'+env);
        system.debug('Messaging.inboundEmail ThreadId---->'+email.inreplyto);
        
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
        String myPlainText= '';
        
        // Add the email plain text into the local variable  
        myPlainText = email.plainTextBody;
        
        // Check for existing leads with this email address   
        /*Lead[] leads = [SELECT Id, Name,firstname,lastname,title,description, Email
                        FROM Lead
                        WHERE Email = :email.fromAddress AND title =:email.subject];*/
        
        //if (leads.isEmpty()) {
            // New Lead object to be created - set LastName and Company to
            // dummy values for simplicity
            Lead newLead = new Lead();
            newLead.Email = email.fromAddress; 
            newLead.LastName = email.fromName;
            newLead.Company = 'No Company';
            newLead.LeadSource = 'Email';
            //newLead.Phone = '0000000000';
            newLead.Description = email.plainTextBody;
            newLead.Title = email.subject;
        newLead.MPAN__c = 11111111 ;
            // newLead.Status = '';
            
            system.debug('newLead.LastName---->'+newLead.LastName);
            system.debug(' newLead.Description'+ newLead.Description);
            
            // Insert a new lead
            insert newLead;    
            
            System.debug('New Lead record: ' + newLead );   
       // } else {
         //   System.debug('Incoming email duplicates existing Lead record(s): ' + leads );    
       // }
        
        // Set the result to true. No need to send an email back to the user      
        // with an error message   
        result.success = true;
        
        // Return the result for the Apex Email Service 
        return result;
    }
}