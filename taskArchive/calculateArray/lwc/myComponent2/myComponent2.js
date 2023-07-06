import { LightningElement } from 'lwc';
import { CalcHelperClass } from './CalcHelperClass';

export default class MyComponent2 extends LightningElement {
  

    myArray = [1, 1, 2, 3, 5, 8, 13, 21];

    prop1;
    prop2;
    prop3;

    connectedCallback() {

        const myCalcHelperClass = new CalcHelperClass(this.myArray);
        // myCalcHelperClass.plus3();
        // myCalcHelperClass.minus1();
        // myCalcHelperClass.plus3();
        // myCalcHelperClass.multiplyBy2();
        // myCalcHelperClass.minus1();

        let result = myCalcHelperClass.getProps()
        const { prop1Value, prop2Value, prop3Value } = result;
        this.prop1 = prop1Value;
        this.prop2 = prop2Value;
        this.prop3 = prop3Value;   
    }


}