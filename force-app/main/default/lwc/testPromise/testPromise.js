import { LightningElement, track } from 'lwc';
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
        multiplyBy2({inputNumber: 1}).then(result => {
            this.elements.push(result);
            multiplyBy3({inputNumber: result}).then(result => {
                this.elements.push(result);
                multiplyBy4({inputNumber: result}).then(result => {
                    this.elements.push(result);
                    multiplyBy5({inputNumber: result}).then(result => {
                        this.elements.push(result);
                        multiplyBy6({inputNumber: result}).then(result => {
                            this.elements.push(result);
                        })
                    })
                })
            })
        })
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