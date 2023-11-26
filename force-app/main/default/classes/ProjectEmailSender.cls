public class ProjectEmailSender {
 public static void sendEmailWithOTP(inov8__PMT_Project__c proj) {
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setTemplateId('00X3L000000JQbUUAW'); // Replace with your email template ID
        //email.setWhatId(proj.Opportunity_Name__c); // Assuming Opportunity is related to Project
        email.setSaveAsActivity(false);
     
     // Set recipient email address
        Opportunity opp = [SELECT Owner.Email, Email__c FROM Opportunity WHERE Id = :proj.Opportunity_Name__c LIMIT 1];
        String emailAddr = opp.Email__c;
        email.setToAddresses(new List<String>{emailAddr});
     // Set target object ID
        email.setTargetObjectId(opp.OwnerId);
        
     
      // Set merge fields
        Map<String, String> templateMergeFields = new Map<String, String>();
        templateMergeFields.put('inov8__PMT_Project__c.Email__c', proj.Email__c); // Assuming the email field on Opportunity is 'Email__c'
       templateMergeFields.put('inov8__PMT_Project__c.OTP__c', proj.OTP__c);
        //email.setTemplateMergeFields(templateMergeFields);

        // Send the email
        Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });

        if (results[0].isSuccess()) {
            System.debug('Email sent successfully.');
        } else {
            System.debug('Email failed to send: ' + results[0].getErrors()[0].getMessage());
        }

        /* Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        if (results[0].isSuccess()) {
            System.debug('Email sent successfully.');
        } else {
            System.debug('Email failed to send: ' + results[0].getErrors()[0].getMessage());
        } */
    }
}