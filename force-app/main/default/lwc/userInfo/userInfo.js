import { wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import userId from '@salesforce/user/Id';
import Name from '@salesforce/schema/User.Name';
import ProfileName from '@salesforce/schema/User.Profile.Name';

export const UserInfo = SuperClass => class extends SuperClass {
    @wire(getRecord, { recordId: userId, fields: [Name, ProfileName] })
    userDetails

    get userId() {
        return userId;
    }

    get userName() {
        const main = this.userDetails.data?.fields
        if (main) return main.Name.value;
    }

    get userProfileName(){
        const main = this.userDetails.data?.fields
        if (main) return main.Profile.value.fields.Name.value;
    }

    showConsoleLog() {
        console.log('Hello User');
    }
}