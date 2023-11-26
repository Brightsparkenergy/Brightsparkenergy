import { LightningElement, api, wire, track } from 'lwc';
import FullCalendarJS from '@salesforce/resourceUrl/fullcalendarv3';
import { loadStyle, loadScript } from 'lightning/platformResourceLoader';
import getEvents from '@salesforce/apex/CalendarController.getEvents';

export default class Calendar extends LightningElement {
    @api userId;
    jsInitialised = false;
    @track _events;
    _selectedUserId;

    @api
    get selectedUserId() {
        return this._selectedUserId;
    }
    set selectedUserId(value) {
        this._selectedUserId = value;
        if (this.jsInitialised) {
            this.fetchAndLoadEvents();
        }
    }

    @api
    get events() {
        return this._events;
    }
    set events(value) {
        this._events = [...value];
        if (this.jsInitialised) {
            this.updateCalendar();
        }
    }

    renderedCallback() {
        if (!this.jsInitialised) {
            Promise.all([
                loadScript(this, FullCalendarJS + '/FullCalenderV3/jquery.min.js'),
                loadScript(this, FullCalendarJS + '/FullCalenderV3/moment.min.js')
            ])
                .then(() => {
                    return loadScript(this, FullCalendarJS + '/FullCalenderV3/fullcalendar.min.js');
                })
                .then(() => {
                    return loadStyle(this, FullCalendarJS + '/FullCalenderV3/fullcalendar.min.css');
                })
                .then(() => {
                    this.initialiseCalendarJs();
                    this.jsInitialised = true;
                })
                .catch(error => {
                    console.log('Error loading scripts or styles: ', error);
                });
        }
    }

    fetchAndLoadEvents() {
        getEvents({ selectedUserId: this.selectedUserId })
            .then(result => {
                let records = result.map(event => {
                    return {
                        Id: event.Id,
                        title: event.Subject + '\n' + event.Owner.Name,
                        start: event.StartDateTime,
                        end: event.EndDateTime,
                        allDay: event.IsAllDayEvent
                    };
                });
                this.events = JSON.parse(JSON.stringify(records));
                this.updateCalendar();
            })
            .catch(error => {
                console.error(error);
            });
    }

    updateCalendar() {
        const ele = this.template.querySelector('div .fullcalendarjs');
        $(ele).fullCalendar('removeEvents');
        $(ele).fullCalendar('addEventSource', this.events);
    }

    initialiseCalendarJs() {
        const that = this;
        const ele = this.template.querySelector('div .fullcalendarjs');
        
        $(ele).fullCalendar({
            header: {
                left: 'prev,next today',
                center: 'title',
                right: 'month,basicWeek,basicDay'
            },
            defaultDate: new Date(),
            navLinks: true,
            editable: true,
            eventLimit: true,
            events: this.events,
            eventClick: function (info) {
                const selectedEvent = new CustomEvent('eventclicked', { detail: info.Id });
                that.dispatchEvent(selectedEvent);
            }
        });
    }
}