public class FetchFilesFromContentVersion {
    public static Id leadId;

    @AuraEnabled(cacheable = true)
    public static list<ContentVersion> retivefiles(){
        try {
            return [SELECT Id, Title, ContentSize, FileType, VersionData,ContentDocumentId FROM ContentVersion WHERE Title IN ('SolarEdge Home Fundamentals Brochure UK', 'Fire and Solar PV systems flyer UK','Why SolarEdge Inverters and Optimisers 2022', 'EN Powerwall Brochure')];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable = true)
    public static void sendEmailWithAttachments(Id recordId, String[] fileID) {
        System.debug('return value' + recordId + 'File ID' + fileID);
        Lead ls = [SELECT Id, Email, Brochure_Send_Successfully__c FROM Lead WHERE Id = :recordId];
        leadId = recordId; // Store the leadId for later use

        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();

        if (ls != null && !String.isEmpty(ls.Email)) {
            EmailTemplate emailTemplate = [Select Id, name, Subject, Description, HtmlValue, DeveloperName, Body from EmailTemplate where name = 'Brochers Sending Email Template'];

            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setTargetObjectId(recordId);
            mail.setSenderDisplayName('Bright Spark Energy');
            mail.setUseSignature(false);
            mail.setBccSender(false);
            mail.setSaveAsActivity(false);
            mail.setTemplateID(emailTemplate.Id);
            mail.toAddresses = new List<String>{ ls.Email };

            List<Messaging.EmailFileAttachment> attachments = new List<Messaging.EmailFileAttachment>();
            list<ContentVersion> getcv = [SELECT Id, ContentDocumentId, Title, VersionData, FileExtension FROM ContentVersion WHERE Id = :fileID and FileExtension = 'pdf'];

            System.debug(getcv);
            for(ContentVersion cv : getcv){
                System.debug('cv------->' + cv);
                Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                Blob Data = cv.VersionData;
                system.debug('Blob Data -------->' + Data);
                system.debug('Data Size' + Data.size());
                if (Data.size() > 0){
                    efa.setBody(Data);
                    efa.setFileName(cv.Title+ '.pdf');
                    efa.setContentType('application/pdf');
                    attachments.add(efa);
                    system.debug('Inside Data size');
                }
            } 
            mail.setFileAttachments(attachments);
            emailList.add(mail);
            system.debug('emailList-----' + emailList);
        }

        if (emailList.size() > 0) {
            Messaging.SendEmailResult[] results = Messaging.sendEmail(emailList);

            if (results[0].success) {
                // Email sent successfully, call the asynchronous event creation method
                System.debug('Email sent successfully. Initiating event creation.');
                createEventAsync(recordId);
            } else {
                System.debug('The email failed to send: ' + results[0].errors[0].message);
            }
        }
    }

    @future
    public static void createEventAsync(Id leadId) {
        Lead ld = [Select Id,Brochure_Send_Successfully__c from Lead where Id =: leadId];
        ld.Brochure_Send_Successfully__c = TRUE;
        update ld;
    }
}