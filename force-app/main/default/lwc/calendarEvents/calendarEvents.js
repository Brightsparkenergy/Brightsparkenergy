import { LightningElement, api, wire, track} from 'lwc';
import getEvents from '@salesforce/apex/CalendarController.getEvents';
import { NavigationMixin } from 'lightning/navigation';
import getUsers from '@salesforce/apex/CalendarController.getUsers';
export default class CalendarEvents extends NavigationMixin(LightningElement) {
    userOptions = [];
    @api selectedUserId = '';
    @wire(getUsers)
    wiredUsers({ data, error }) {
        if (data) {
            this.userOptions = data.map(user => ({
                label: user.Name,
                value: user.Id
            }));
        } else if (error) {
            console.error(error);
        }
    }
    handleUserChange(event) {
        this.selectedUserId = event.detail.value;
        const calendarComponent = this.template.querySelector('c-calendar');
        if (calendarComponent) {
            calendarComponent.selectedUserId = this.selectedUserId;
        }
    }
    
}