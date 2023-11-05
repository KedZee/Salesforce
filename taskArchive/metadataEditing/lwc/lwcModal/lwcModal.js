import { api } from 'lwc';
import LightningModal from 'lightning/modal';

export default class LwcModal extends LightningModal {
    handleClose() {
        this.close('close popup');
    }
    handleSave() {
        let data = {};
        this.template.querySelectorAll('lightning-input').forEach(currentItem => {
            data[currentItem.name] = currentItem.value;
        });
        console.log('Data===' + JSON.stringify(data) );
        this.close(data);
    }
}