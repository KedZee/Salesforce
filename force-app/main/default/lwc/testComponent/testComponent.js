import { LightningElement } from 'lwc';
import { userInfo } from 'c/userInfo';

export default class TestComponent extends userInfo(LightningElement) {

    connectedCallback() {
        this.showConsoleLog();
    }
}