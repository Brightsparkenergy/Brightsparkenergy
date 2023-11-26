import { LightningElement, wire, track, api } from 'lwc';
import retriveProjects from '@salesforce/apex/FetchFilesFromContentVersion.retivefiles';
import sendEmailWithAttachments from '@salesforce/apex/FetchFilesFromContentVersion.sendEmailWithAttachments';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


const Columns = [
    { label: 'Title', fieldName: 'Title'  }
];
export default class Displaythebrochers extends LightningElement {
 @track data = [];
 @track SelectedrowID = [];
 @api recordId;
    @track error;
    @track projectColumns = Columns;
    @track searchString;
    @track initialRecords;
    @track selectedRows = [];
    @api SelectRecordId;
    @wire(retriveProjects)
    wiredAccount({ error, data }) {
        if (data) {
            
            this.data = data;
            console.log( JSON.stringify(this.data));
            this.initialRecords = data;
            console.log(this.data)
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.data = undefined;
        }
    }
    handleRowSelection=event => {
   
       this.selectedRow=event.detail.selectedRows;

            this.selectedRow.forEach(currentItem => {
                this.SelectRecordId = currentItem.Id;
                console.log('Selected Record Id: -->' + this.SelectRecordId);

              this.SelectedrowID.push(this.SelectRecordId);
               console.log(this.SelectedrowID.toString());
            });
        //}
    }
    handleButtonClick() {
        // Check if any brochures are deselected
        if (this.SelectedrowID.toString() == '') {
            this.showToast('Error', 'Please select at least one brochure', 'error');
        } else {
            sendEmailWithAttachments({ recordId: this.recordId, fileID: this.SelectedrowID })
                .then((result) => {
                    this.showToast('Success', 'Brochures sent successfully.', 'success');
                    this.SelectedrowID = []; // Clear the selected brochures
                })
                .catch((error) => {
                    this.showToast('Error', 'An error occurred while sending brochures', 'error');
                });
        }
    }
        showToast(title, message, variant) {
            const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
            });
            this.dispatchEvent(event);
        }

    refreshpage(){
        setTimeout(() => {
            eval("$A. get('e. force:refreshView'). fire();");
        },1000
        )
    }
            
    
}