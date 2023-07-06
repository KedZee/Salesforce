class CalcHelperClass {

    myArray
    context;

    constructor(myArray, context) {
        this.myArray = myArray;
        this.context = context;
    }
    
    minus1() {
        this.myArray = this.myArray.map(item => item - 1);
        return this;
    }

    multiplyBy2() {
        this.myArray = this.myArray.map(item => item * 2);
        return this;
    }

    plus3() {
        console.log('this.myArray===' , JSON.parse(JSON.stringify(this.myArray)));
        this.myArray = this.myArray.map(item => item + 3);
        return this;
    }


    getProps() { 
        let prop1Value = this.myArray.reduce((sum, current) => sum + current, 0);
        let prop2Value = this.myArray.reduce((sum, current) => current % 2 === 0 ? sum + current : sum, 0);
        let prop3Value = this.myArray.reduce((sum, current) => (current % 2 !== 0) && (current >= 5 && current <= 10) ? sum + current : sum, 0);


        this.context.prop1 = prop1Value;
        this.context.prop2 = prop2Value;
        this.context.prop3 = prop3Value; 
    }
}

export {
    CalcHelperClass
};