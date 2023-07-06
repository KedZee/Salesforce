class CalcHelperClass {
    myArray

    constructor(myArray) {
        this.myArray = myArray;
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

export {
    CalcHelperClass
};