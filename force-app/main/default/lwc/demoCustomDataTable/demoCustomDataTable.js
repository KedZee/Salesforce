import { LightningElement, track, api } from 'lwc';
import { updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getDataTableInformation from '@salesforce/apex/customDataTableController.getDataTableInformation';

export default class DemoCustomDataTable extends LightningElement {
    @track draftValues = [];
    @track picklistOptions;
    @track data = [];
    @api objectApiName;
    @api fields;

    @track columns;

    connectedCallback() {
        this.getAllData();
    }

    getAllData() {
        getDataTableInformation({objectApiName: this.objectApiName, fields: this.fields}) 
        .then(result => {
            this.columns = result.columns; 
            this.data = result.data; 
        })
    }

    handleCellChange(event) {
        let updateItem = event.detail.draftValues[0];
        let indexDuplicate = this.draftValues.map(item => item.Id).indexOf(updateItem.Id);

        if (indexDuplicate == -1) {
            this.draftValues.push(updateItem);
        } else {
            let currentDraftValue = this.draftValues[indexDuplicate];
            let currentValueType =  Object.keys(updateItem)[0];

            currentDraftValue[currentValueType] = updateItem[currentValueType];
        }
    }
 
    handleSave() {
        const recordInputs = this.draftValues.map(obj => ({fields: obj }))
        const promises = recordInputs.map(recordInput => updateRecord(recordInput));

        Promise.allSettled(promises)
            .then(() => {
                this.showToast('Success', 'Records Updated Successfully!', 'success', 'dismissable');
                this.getAllData();
                this.draftValues = [];
            }).catch(error => {
                this.showToast('Error', 'An Error Occured!!', 'error', 'dismissable');
                console.log(error);
            })
    }
 
    handleCancel() {
        this.draftValues = [];
    }  

    showToast(title, message, variant, mode) {
        this.dispatchEvent(new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
            mode: mode
        }));
    }
}