import { LightningElement } from 'lwc';
import firstMultiplyBy2 from '@salesforce/apex/mockDelays.firstMultiplyBy2';
import secondMultiplyBy2 from '@salesforce/apex/mockDelays.secondMultiplyBy2';
import thirdMultiplyBy2 from '@salesforce/apex/mockDelays.thirdMultiplyBy2';
import fourthMultiplyBy2 from '@salesforce/apex/mockDelays.fourthMultiplyBy2';
import fifthMultiplyBy2 from '@salesforce/apex/mockDelays.fifthMultiplyBy2';

export default class TestPromise extends LightningElement {

    // это первый вариант, который мог бы быть, но от него я отказался, потому что
    // код растет в ширь

    // connectedCallback() {
    //     firstMultiplyBy2({inputNumber: 1}).then(result => {
    //         console.log('result=1==', result)
    //         secondMultiplyBy2({inputNumber: 2}).then(result => {
    //             console.log('result=2==', result)
    //             thirdMultiplyBy2({inputNumber: 3}).then(result => {
    //                 console.log('result=3==', result)
    //                 fourthMultiplyBy2({inputNumber: 4}).then(result => {
    //                     console.log('result=4==', result)
    //                     fifthMultiplyBy2({inputNumber: 5}).then(result => {
    //                         console.log('result=5==', result)
    //                     })
    //                 })
    //             })
    //         })
    //     })
    // }

    initialValue = 1;
    elements = [];

    firstResult;
    secondtResult;
    thirdResult;
    fourthResult;
    fifthResult;

    connectedCallback() {
        this.callFirstPromise()
    }

    callFirstPromise() {
        firstMultiplyBy2({inputNumber: this.initialValue})
            .then(result => {
                this.initialValue = result;
                this.elements.push(this.initialValue);
                this.elements = JSON.parse(JSON.stringify(this.elements));

                this.callSecondPromise();
            })
    }

    callSecondPromise() {
        secondMultiplyBy2({inputNumber: this.initialValue})
            .then(result => {
                this.initialValue = result;
                this.elements.push(this.initialValue);
                this.elements = JSON.parse(JSON.stringify(this.elements));

                this.callThirdPromise();
            })
    }

    callThirdPromise() {
        thirdMultiplyBy2({inputNumber: this.initialValue})
            .then(result => {
                this.initialValue = result;
                this.elements.push(this.initialValue);
                this.elements = JSON.parse(JSON.stringify(this.elements));

                this.callFourthPromise();
            })
    }

    callFourthPromise() {
        fourthMultiplyBy2({inputNumber: this.initialValue})
            .then(result => {
                this.initialValue = result;
                this.elements.push(this.initialValue);
                this.elements = JSON.parse(JSON.stringify(this.elements));

                this.callFifthPromise();
            })
    }

    callFifthPromise() {
        fifthMultiplyBy2({inputNumber: this.initialValue})
            .then(result => {
                this.initialValue = result;
                this.elements.push(this.initialValue);
                this.elements = JSON.parse(JSON.stringify(this.elements));
            })
    }

    async callAsync() {
        this.initialValue = await firstMultiplyBy2({inputNumber: this.initialValue});
        this.elements.push(this.initialValue);
        this.elements = JSON.parse(JSON.stringify(this.elements));

        this.initialValue = await secondMultiplyBy2({inputNumber: this.initialValue});
        this.elements.push(this.initialValue);
        this.elements = JSON.parse(JSON.stringify(this.elements));

        this.initialValue = await thirdMultiplyBy2({inputNumber: this.initialValue});
        this.elements.push(this.initialValue);
        this.elements = JSON.parse(JSON.stringify(this.elements));

        this.initialValue = await fourthMultiplyBy2({inputNumber: this.initialValue});
        this.elements.push(this.initialValue);
        this.elements = JSON.parse(JSON.stringify(this.elements));

        this.initialValue = await fifthMultiplyBy2({inputNumber: this.initialValue});
        this.elements.push(this.initialValue);
        this.elements = JSON.parse(JSON.stringify(this.elements));

    }

}