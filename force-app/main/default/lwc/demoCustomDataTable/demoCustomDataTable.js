import { LightningElement, track, api } from 'lwc';
import { updateRecord } from 'lightning/uiRecordApi';
import getDataTable from '@salesforce/apex/customDataTableController.getDataTable';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getColumnTable from '@salesforce/apex/customDataTableController.getColumnTable';

export default class DemoCustomDataTable extends LightningElement {
    @track draftValues = [];
    @track picklistOptions;
    @track data = [];
    @api objectApiName;
    @api fields;

    @track columns ;

    connectedCallback() {
        this.getAllData();
    }

    getAllData() {
        getColumnTable({objectApiName: this.objectApiName, fields: this.fields}) 
        .then(result => {
            this.columns = JSON.parse(result);
            this.picklistOptions = this.columns.map(item => item?.typeAttributes?.picklistoptions).filter(item => item).reduce((acc, item) =>  item, {})

            return getDataTable({objectApiName: this.objectApiName, fields: this.fields}) 
        }).then(result => {
            this.data = result.map(obj => ({ ...obj, ...this.picklistOptions }))
            
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
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
            mode: mode
        });
        this.dispatchEvent(evt);
    }
}