import { LightningElement, api } from 'lwc';

export default class CustomCombobox extends LightningElement {

    @api label;
    @api placeholder;
    @api options;
    @api value;
    @api context;
    @api contextName;
    @api fieldName;

    connectedCallback() {
        // this.options = [
        //     { label: 'Web', value: 'Web' },
        //     { label: 'Purchased List', value: 'Purchased List' },
        // ];
       
        console.log('options==1=', this.options)
        console.log('placeholder==1=', this.placeholder)
        console.log('label==1=', this.label)     
        console.log('value==1=', this.value)     
        console.log('context==1=', this.context)   
        console.log('contextName==1=', this.contextName)     
        console.log('fieldName==1=', this.fieldName)       

        if (this.options) {
            this.options = Object.values(this.options);
        }


        // console.log('options==1=', this.options)
        //console.log('options===' , {...this.options})
        //console.log('options===' , structuredClone( this.options))
    }

    renderedCallback() {
        console.log('this.options==1=', this.options);

    }

    handleChange(event) {
        // this.editedValue = event.detail.value;
        // console.log('this.editedValue===', this.editedValue);


        //show the selected value on UI

        // this.value = event.detail.value;
        // let draftValue = {};
        // draftValue[this.contextName] = typeof(this.context) == 'number' ? this.context.toString() : this.context;
        // draftValue[this.fieldName] = this.value;
        // let draftValues = [];
        // draftValues.push(draftValue);

        // this.dispatchEvent(new CustomEvent('cellchange', {
        //     composed: true,
        //     bubbles: true,
        //     cancelable: true,
        //     detail: {
        //         'draftValues' : draftValues
        //     }
        // }));
    }
}