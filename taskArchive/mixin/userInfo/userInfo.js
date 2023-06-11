import { wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import userId from '@salesforce/user/Id';
import NAME from '@salesforce/schema/User.Name';
import PROFILE_NAME from '@salesforce/schema/User.Profile.Name';

export const UserInfo = SuperClass => class extends SuperClass {
    @wire(getRecord, { recordId: userId, fields: [NAME, PROFILE_NAME] })
    userDetails

    get userId() {
        return userId;
    }

    get userName() {
        return getFieldValue(this.userDetails.data, NAME);
    }

    get userProfileName(){
        return getFieldValue(this.userDetails.data, PROFILE_NAME);;
    }

    showConsoleLog() {
        console.log('Hello User');
    }
}