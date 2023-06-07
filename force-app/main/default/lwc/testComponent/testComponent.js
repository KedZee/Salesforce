import { LightningElement } from 'lwc';
import { UserInfo } from 'c/userInfo';

export default class TestComponent extends UserInfo(LightningElement) {

    connectedCallback() {
        this.showConsoleLog();
    }
}