public class CalendarController {
    @AuraEnabled(cacheable=true)
    public static List<Event> getEvents(string selectedUserId) {
        List<Event> eventList = new List<Event>();
        List<Id> eventIds = new List<Id>();
        try {

            // List<EventRelation> eventRealtionList = [SELECT EventId
            //                             FROM EventRelation

            //                         ];
            // System.debug('eventRealtionList- ' + eventRealtionList);
            // for(EventRelation ev: eventRealtionList){
            //     eventIds.add(ev.EventId);
            // }                                    
            //System.debug('eventIds- ' + eventIds);
            eventList = [SELECT Id, Subject,OwnerId, Owner.Name,StartDateTime,Who.name, IsAllDayEvent, EndDateTime, Location
                            FROM Event WHERE OwnerId =:selectedUserId
                            ORDER BY CreatedDate DESC
                        ];
            System.debug('eventList- ' + eventList);

            return eventList;
        } catch (Exception e) {
            System.debug('Error in getEvents method- ' + e.getMessage());
            return null;
        }
        
         
    }


        @AuraEnabled(cacheable=true)
    public static List<User> getUsers() {
        return [SELECT Id, Name FROM User];
    }
}