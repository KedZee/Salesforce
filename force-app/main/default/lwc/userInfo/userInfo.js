import { NavigationMixin } from 'lightning/navigation';

const userInfo = (superclass) => class extends NavigationMixin(superclass) {
    showConsoleLog() {
        console.log('Hello User');
    }
}

export { userInfo }