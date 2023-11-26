public class LeadTriggerHandler {
    public static void updateOpportunityName(List<Lead> newLeads, Map<Id, Lead> oldLeadsMap) {
        List<Opportunity> opportunitiesToUpdate = new List<Opportunity>();

        for (Lead lead : newLeads) {
            Lead oldLead = oldLeadsMap.get(lead.Id);

            // Check if the Lead was converted
            if (!oldLead.IsConverted && lead.IsConverted) {
                // Query the related Opportunity
                Opportunity opportunity = [SELECT Id, Account.Name FROM Opportunity WHERE Id = :lead.ConvertedOpportunityId];

                // Check if the Opportunity exists
                if (opportunity != null) {
                    // Update the Opportunity Name field
                    opportunity.Name = opportunity.Account.Name + '-' + lead.LastName;
                    opportunitiesToUpdate.add(opportunity);
                }
            }
        }

        // Update the Opportunities
        if (!opportunitiesToUpdate.isEmpty()) {
            update opportunitiesToUpdate;
        }
    }
}