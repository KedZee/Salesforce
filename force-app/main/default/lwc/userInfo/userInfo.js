import { NavigationMixin } from 'lightning/navigation';

const UserInfo = (superclass) => class extends NavigationMixin(superclass) {
    showConsoleLog() {
        console.log('Hello User');
    }
}

export { UserInfo }