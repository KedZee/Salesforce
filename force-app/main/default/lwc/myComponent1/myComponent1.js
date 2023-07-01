import { LightningElement } from 'lwc';

export default class MyComponent1 extends LightningElement {
  

    myArray = [1, 1, 2, 3, 5, 8, 13, 21];

    prop1;
    prop2;
    prop3;

    connectedCallback() {
        // this.plus3();
        // this.minus1();
        // this.plus3();
        // this.multiplyBy2();
        // this.minus1();


        const { prop1Value, prop2Value, prop3Value } = this.getProps();
        this.prop1 = prop1Value;
        this.prop2 = prop2Value;
        this.prop3 = prop3Value;   
    }

    minus1() {
        this.myArray = this.myArray.map(item => item - 1);
    }

    multiplyBy2() {
        this.myArray = this.myArray.map(item => item * 2);
    }

    plus3() {
        this.myArray = this.myArray.map(item => item + 3);
    }

    getProps() { 
        let prop1Value = this.myArray.reduce((sum, current) => sum + current, 0);
        let prop2Value = this.myArray.reduce((sum, current) => current % 2 == 0 ? sum + current : sum + 0, 0);
        let prop3Value = this.myArray.reduce((sum, current) => (current % 2 !== 0) && (current >= 5 && current <= 10) ? sum + current : sum + 0, 0);

        return {
            prop1Value,
            prop2Value,
            prop3Value
        }
    }
}