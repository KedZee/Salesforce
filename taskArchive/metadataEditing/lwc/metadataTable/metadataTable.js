import { LightningElement,track } from 'lwc';
import getData from '@salesforce/apex/metadataTableController.getData';
import apex__SettingsController_updateSettings from '@salesforce/apex/SettingsController.updateSettings';
import lWCModal from 'c/lwcModal';


const columns = [
    { label: 'Label', fieldName: 'MasterLabel' },
    { label: 'metadata Text', fieldName: 'metadata_Text__c' },
];

export default class MetadataTable extends LightningElement {
    data = [];
    columns = columns;

    connectedCallback() {
        getData()
        .then(result => {
            this.data = result;
            console.log('result===',result);
        })
    }

    openModal() {
        lWCModal.open({
            size: 'small', //small, medium, or large default :medium
            description: 'Accessible description of modal\'s purpose'
        }).then(result => {
            console.log('result==rr===', JSON.stringify(result));
            this.data.push(JSON.parse(JSON.stringify(result)) );

            return apex__SettingsController_updateSettings({metadataText: result.metadataText, label: result.Label});
        }).then(result => {
            console.log('createMetadata===', result);
        })
    }

    // async openModal() {
    //     const result = await lWCModal.open({
    //         size: 'small', //small, medium, or large default :medium
    //         description: 'Accessible description of modal\'s purpose'
    //     });
    //     console.log('result==rr===', JSON.stringify(result.Label));

    //     createMetadata({metadataText: result.metadataText, label: result.Label})
    //         .then(result=> {
    //             this.getData();
    //         })
    //     console.log('result===' + JSON.stringify(result.metadataText));
    // }

    getData() {
        getData()
        .then(result => {
            this.data = result;
            console.log('result===',result);
        })
    }

    createNewMetadata() {
        
    }

    handleCreate() {
        this.isShowModal = false;
    }

    handleDelete() {

    }


}