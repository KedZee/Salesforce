import { LightningElement } from 'lwc';
import { CalcHelperClass } from './CalcHelperClass';

export default class MyComponent3 extends LightningElement {
  

    myArray = [1, 1, 2, 3, 5, 8, 13, 21];

    prop1;
    prop2;
    prop3;

    connectedCallback() {

        const myCalcHelperClass = new CalcHelperClass(this.myArray, this);
        myCalcHelperClass
            .plus3()
            .minus1()
            .plus3()
            .multiplyBy2()
            .minus1()
            .getProps()
    }
}