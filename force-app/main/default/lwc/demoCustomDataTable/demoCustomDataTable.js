import { LightningElement, track, api } from 'lwc';
import { updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getTableInformation from '@salesforce/apex/customDataTableController.getTableInformation';

export default class DemoCustomDataTable extends LightningElement {
    @api objectApiName;
    @api fields;

    @track data;
    @track columns;
    @track draftValues = [];

    lastSaveData = [];
    error;
    showSpinner = false;

    connectedCallback() {
        getTableInformation({objectApiName: this.objectApiName, fields: this.fields}) 
            .then(result => {
                this.columns = result.columns;
                this.data = result.data;
                this.lastSaveData = result.data;
            })
    }

    handleSave() {
        const recordInputs = this.draftValues.map(obj => ({fields: obj }))
        const promises = recordInputs.map(recordInput => updateRecord(recordInput));

        Promise.allSettled(promises)
            .then(() => {
                this.showToast('Success', 'Records Updated Successfully!', 'success', 'dismissable');
                this.draftValues = [];
            }).catch(error => {
                this.showToast('Error', 'An Error Occured!!', 'error', 'dismissable');
                console.log(error);
            })
    }
	
	handleCellChange(event) {
        this.updateCells(event.detail.draftValues[0]);
    }
 
    handleValueChange(event) {
        let dataRecieved = event.detail.data;

        this.setClassesOnData(
            dataRecieved.context,
            dataRecieved.name + 'Class',
            'slds-cell-edit slds-is-edited'
        );

        this.updateCells({ Id: dataRecieved.context, [dataRecieved.name]: dataRecieved.value} );
    }

    updateCells(updateItem) {
        this.updateDraftValues(updateItem);
        this.updateDataValues(updateItem);
    }

    updateDraftValues(updateItem) {
        let copyDraftValues = [...this.draftValues];
        let indexDuplicate = copyDraftValues.map(item => item.Id).indexOf(updateItem.Id);

        if (indexDuplicate == -1) {
            copyDraftValues.push(updateItem);
        } else {
            let currentDraftValue = copyDraftValues[indexDuplicate];
            Object.keys(updateItem).forEach(item => {
                    currentDraftValue[item] = updateItem[item];
            })
        }

        this.draftValues = [...copyDraftValues];
    }

    updateDataValues(updateItem) {
        this.data.forEach((item) => {
            if (item.Id === updateItem.Id) {
                for (let field in updateItem) {
                    item[field] = updateItem[field];
                }
            }
        });
    }

    setClassesOnData(id, fieldName, fieldValue) {
        this.data.forEach((detail) => {
            if (detail.Id === id) {
                detail[fieldName] = fieldValue;
            }
        });
    }

    handleCancel() {
        this.draftValues = [];
        this.data = this.lastSaveData;
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