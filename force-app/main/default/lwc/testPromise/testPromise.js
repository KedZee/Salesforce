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

    firstResult;
    secondtResult;
    thirdResult;
    fourthResult;
    fifthResult;

    connectedCallback() {
        this.callPromises()
    }

    callFirstPromise() {
        firstMultiplyBy2({inputNumber: 1})
            .then(result => {
                this.firstResult = result;
                this.callSecondPromise();
            })
    }

    callSecondPromise() {
        secondMultiplyBy2({inputNumber: 2})
            .then(result => {
                this.secondtResult = result;
                this.callThirdPromise();
            })
    }

    callThirdPromise() {
        thirdMultiplyBy2({inputNumber: 3})
            .then(result => {
                this.thirdResult = result;
                this.callFourthPromise();
            })
    }

    callFourthPromise() {
        fourthMultiplyBy2({inputNumber: 4})
            .then(result => {
                this.fourthResult = result;
                this.callFifthPromise();
            })
    }

    callFifthPromise() {
        fifthMultiplyBy2({inputNumber: 5})
            .then(result => {
                this.fifthResult = result;
            })
    }

    async callPromises() {
        this.firstResult = await firstMultiplyBy2({inputNumber: 1});
        this.secondtResult = await secondMultiplyBy2({inputNumber: 2});
        this.thirdResult = await thirdMultiplyBy2({inputNumber: 3});
        this.fourthResult = await fourthMultiplyBy2({inputNumber: 4});
        this.fifthResult = await fifthMultiplyBy2({inputNumber: 5});
    }

}