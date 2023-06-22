import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import multiplyBy2 from '@salesforce/apex/mockDelays.multiplyBy2';
import multiplyBy3 from '@salesforce/apex/mockDelays.multiplyBy3';
import multiplyBy4 from '@salesforce/apex/mockDelays.multiplyBy4';
import multiplyBy5 from '@salesforce/apex/mockDelays.multiplyBy5';
import multiplyBy6 from '@salesforce/apex/mockDelays.multiplyBy6';

export default class TestPromise extends LightningElement {

    @track elements = [];

    connectedCallback() {
        this.callPyramid()
    }

    callPyramid() {
        multiplyBy2({inputNumber: 1})
            .then(result => {
                this.elements.push(result);
                return multiplyBy3({inputNumber: result})
            })
            // .then(this.thenTest)
            .then(result => {
                console.log(JSON.stringify(this.thenTest));
                this.showToastError
                this.elements.push(result);
                return multiplyBy4({inputNumber: result})
            })
            .then(result => {
                this.elements.push(result);
                return multiplyBy5({inputNumber: result})
            })
            .then(result => {
                this.elements.push(result);
                this.showToast('Helloy 2');
                return Promise.resolve(result * 20)
          
            })
            .then(result => {
                this.elements.push(result);
                return multiplyBy6({inputNumber: result})
            })
            .then(result => {
                this.elements.push(result);
            })
            .catch(this.showToastError)
    }

    showToastError = error => {
        console.error(JSON.stringify(error));
        this.dispatchEvent(new ShowToastEvent({
            title: 'Error!',
            message: error?.body?.message,
            variant: 'error',
            mode: 'sticky'
        }));
    }

    thenTest = result => {
        console.log('Test then');
        this.elements.push(result);
        return Promise.resolve(result * 20)
    }

    showToast(message, title = 'Success!!!!') {
        this.dispatchEvent(new ShowToastEvent({
            title: title,
            message: message,
            variant: 'success',
        }));
    }

    async callAsync() {
        let initialValue = 1;

        initialValue = await multiplyBy2({inputNumber: initialValue});
        this.elements.push(initialValue);

        initialValue = await multiplyBy3({inputNumber: initialValue});
        this.elements.push(initialValue);

        initialValue = await multiplyBy4({inputNumber: initialValue});
        this.elements.push(initialValue);

        initialValue = await multiplyBy5({inputNumber: initialValue});
        this.elements.push(initialValue);

        initialValue = await multiplyBy6({inputNumber: initialValue});
        this.elements.push(initialValue);
    }
}